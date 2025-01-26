class Food::CategoryController < ApplicationController
  before_action :authenticate

  def list
    begin
      object = Food::CategoryService::Manager.new()
      list = object.list()

      render_success_response list
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end
end
