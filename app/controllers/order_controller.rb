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
    unless has_sufficient_params(["table_token", "status"])
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

  def update_order_item
    unless has_sufficient_params(["order_item_token", "quantity"])
      return
    end

    begin
      object = OrderService::Manager.new(@table, nil, nil, params.dig("order_item_token"))
      list = object.update_order_item(params)

      render_success_response "Updated successfully !!"
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end

  def update_order
    unless has_sufficient_params(["order_token", "status"])
      return
    end

    begin
      object = OrderService::Manager.new(@table, nil, params.dig("order_token"), nil)
      list = object.update_order(params)

      render_success_response "Updated successfully !!"
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end

  def delete_order_item
    unless has_sufficient_params(["order_item_token", "table_token"])
      return
    end

    begin
      object = OrderService::Manager.new(@table, nil, nil, params.dig("order_item_token"))
      list = object.delete_order_item()

      render_success_response "Deleted successfully !!"
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end
end
