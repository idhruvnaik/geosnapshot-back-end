class OrderController < ApplicationController
  before_action :authenticate

  def place
    unless has_sufficient_params(["table_token"])
      return
    end

    begin
      object = OrderService::Manager.new(@table)
      object.place(params&.dig("items"))

      render_success_response "Order placed"
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end

  def list
    unless has_sufficient_params(["table_token"])
      return
    end

    begin
      object = OrderService::Manager.new(@table, params.dig("status"))
      list = object.list()

      render_success_response list
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end
end
