module Food
  module ItemService
    class Manager
      attr_reader :status

      def initialize(status = "active", category_token)
        @status = status
        @category = Food::Category.includes(:food_items).find_by_token category_token
        if @category.nil?
          raise "Invalid food category !!"
        end
      end

      def list
        begin
          response = []

          food_items = @category.food_items
          food_items&.each do |food_item|
            response << { name: food_item&.name, description: food_item&.description, image: food_item&.image, token: food_item&.token, serving: food_item&.serving }
          end

          return response
        rescue => error
          raise error
        end
      end
    end
  end
end
