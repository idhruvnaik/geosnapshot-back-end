class ServingTableController < ApplicationController
  before_action :authenticate

  def list
    begin
      instance = Table::Manager.new("active")
      list = instance.list()

      render_success_response list
    rescue => error
      puts error
      render_500_json "Sorry !! Something went wrong"
    end
  end
end
