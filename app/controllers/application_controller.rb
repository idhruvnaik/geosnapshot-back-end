class ApplicationController < ActionController::Base
  def render_success_response(data, message = "Excecuted successfully")
    response = { status: "success", data: data, message: message }
    render json: response, status: 200
  end

  def render_500_json(message)
    response = { status: "error", message: message }
    render json: response, status: 500
  end
end
