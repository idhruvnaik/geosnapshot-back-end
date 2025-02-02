module Table
  class Manager
    attr_reader :status

    def initialize(status = "active")
      @status = status
    end

    def list
      begin
        response = []

        tables = Serving::Table.where(status: @status)
        tables&.each do |table|
          response << { token: table&.token, name: table&.name }
        end

        return response
      rescue => error
        raise error
      end
    end
  end
end
