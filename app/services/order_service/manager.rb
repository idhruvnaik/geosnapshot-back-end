module OrderService
  class Manager
    def initialize(table, status = "pending", order_token = nil, order_item_token = nil, allow_order_update = false)
      @table = table
      @status = status
      @allow_order_update = allow_order_update

      if order_item_token.present?
        @order_item = Order::Item.includes(:order).find_by_token order_item_token
        if @order_item.nil?
          raise "food item not found !!"
        end
      end

      if order_token.present?
        @order = Order.find_by_token order_token
        if @order.nil?
          raise "Order not found !!"
        end
      end
      puts "Initialized"
    end

    def place(items = [])
      begin
        order = nil

        ActiveRecord::Base.transaction do
          order = Order.create!(serving_table_id: @table&.id, status: "pending", estimated_time: "NA", submission_time: Time.now.utc, total_price: 0)

          items&.each do |item|
            food = Food::Item.find_by_token item.dig("food_token")

            if food.present?
              order_item = Order::Item.new
              order_item.order_id = order.id
              order_item.food_item_id = food&.id
              order_item.quantity = item.dig("quantity").to_i
              order_item.price = item.dig("price").to_f
              order_item.instructions = item.dig("instructions")
              order_item.save
            end
          end
        end

        order = order.reload
        ActionCable.server.broadcast("orders_channel", OrderService::Manager.order_formatter(order)) # ? Broadcast to WS
      rescue => error
        ActiveRecord::Rollback
        raise error
      end
    end

    def list()
      begin
        response = []
        if @table.present?
          orders = Order.includes([order_items: :food_item]).where(status: @status, serving_table_id: @table&.id).order(:submission_time)
        else
          orders = Order.includes([order_items: :food_item]).where(status: @status).order(:submission_time)
        end

        orders&.each do |order|
          response << OrderService::Manager.order_formatter(order)
        end

        return response
      rescue => error
        puts error
        raise error
      end
    end

    def update_order_item(params)
      begin
        order = nil
        ActiveRecord::Base.transaction do
          order = @order_item&.order rescue nil
          if order.nil?
            raise "Order not found !!"
          end

          if order.status != "pending"
            raise "Sorry !! Order can not be updated now."
          end

          quantity = params.dig("quantity").to_i
          if quantity === 0
            @order_item.destroy
          else
            @order_item.update(quantity: quantity)
          end
        end

        if order.order_items.length === 0 # !! All the
          ActionCable.server.broadcast("orders_channel", { state: "deleted", order_token: order.token }) # ? Broadcast to WS
        else
          order = order.reload
          ActionCable.server.broadcast("orders_channel", OrderService::Manager.order_formatter(order)) # ? Broadcast to WS
        end
      rescue => error
        puts error
        raise error
      end
    end

    def update_order(params)
      begin
        ActiveRecord::Base.transaction do
          if @order.status != "pending" && @allow_order_update === false
            raise "Sorry !! Order can not be updated now."
          end

          status = params.dig("status")
          estimated_time = params.dig("estimated_time")

          @order.status = status if status&.present?
          @order.estimated_time = estimated_time if estimated_time&.present?
          @order.save

          return @order
        end

        if @order.status === "pending"
          ActionCable.server.broadcast("orders_channel", OrderService::Manager.order_formatter(@order)) # ? Broadcast to WS
        end
      rescue => error
        puts error
        raise error
      end
    end

    def delete_order_item()
      begin
        ActiveRecord::Base.transaction do
          @order_item.destroy
        end
      rescue => error
        puts error
        raise error
      end
    end

    def self.order_formatter(order)
      food_items = []
      order_items = order&.order_items

      order_items&.each do |order_item|
        food_item = order_item&.food_item rescue nil
        if food_item.present?
          food_items << { name: food_item&.name, description: food_item&.description, serving: food_item&.serving, image: food_item&.image, quantity: order_item&.quantity, price: order_item&.price, instructions: order_item&.instructions, order_item_token: order_item&.token }
        end
      end

      return { status: order&.status, total_price: order&.total_price, estimated_time: order&.estimated_time, submission_time: order&.submission_time, food_items: food_items, order_token: order&.token }
    end
  end
end
