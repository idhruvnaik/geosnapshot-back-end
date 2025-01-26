class Food::ItemController < ApplicationController
    before_action :authenticate

  def list
    unless has_sufficient_params(["category_token"])
        return 
    end

    begin
      object = Food::ItemService::Manager.new('active', params['category_token'])
      list = object.list()

      render_success_response list
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end
end
