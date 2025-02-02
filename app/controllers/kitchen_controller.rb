class KitchenController < ApplicationController
  def list
    unless has_sufficient_params(["status"])
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

  def update_order
    unless has_sufficient_params(["order_token"])
      return
    end

    begin
      object = OrderService::Manager.new(@table, nil, params.dig("order_token"), nil, true)
      list = object.update_order(params)

      render_success_response "Updated successfully !!"
    rescue => error
      render_500_json error
    end
  end
end
