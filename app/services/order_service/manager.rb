module OrderService
  class Manager
    def initialize(table, status = "pending", order_token = nil, order_item_token = nil)
      @table = table
      @status = status

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
      rescue => error
        ActiveRecord::Rollback
        raise error
      end
    end

    def list()
      begin
        response = []
        orders = Order.includes([order_items: :food_item]).where(status: @status, serving_table_id: @table&.id).order(:submission_time)

        orders&.each do |order|
          food_items = []
          order_items = order&.order_items

          order_items&.each do |order_item|
            food_item = order_item&.food_item rescue nil
            if food_item.present?
              food_items << { name: food_item&.name, description: food_item&.description, serving: food_item&.serving, image: food_item&.image, quantity: order_item&.quantity, price: order_item&.price, instructions: order_item&.instructions, order_item_token: order_item&.token }
            end
          end

          response << { status: order&.status, total_price: order&.total_price, estimated_time: order&.estimated_time, submission_time: order&.submission_time, food_items: food_items, order_token: order&.token }
        end

        return response
      rescue => error
        puts error
        raise error
      end
    end

    def update_order_item(params)
      begin
        ActiveRecord::Base.transaction do
          order = @order_item&.order rescue nil
          if order.nil?
            raise "Order not found !!"
          end

          if order.status != "pending"
            raise "Sorry !! Order can not be updated now."
          end

          quantity = params.dig("quantity").to_i
          @order_item.update(quantity: quantity)

          return @order_item
        end
      rescue => error
        puts error
        raise error
      end
    end

    def update_order(params)
      begin
        ActiveRecord::Base.transaction do
          if @order.status != "pending"
            raise "Sorry !! Order can not be updated now."
          end

          status = params.dig("status")
          @order.update(status: status)

          return @order
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
  end
end
