module Food
  module CategoryService
    class Manager
      attr_reader :status

      def initialize(status = "active")
        @status = status
      end

      def list
        begin
          response = []

          categories = Food::Category.where(status: @status)
          categories&.each do |category|
            response << { name: category&.name, description: category&.description, image: category&.image, token: category&.token }
          end

          return response
        rescue => error
          raise error
        end
      end
    end
  end
end
