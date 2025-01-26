class ApplicationController < ActionController::Base
  def authenticate
    table_token = params.dig("table_token")

    if table_token.nil?
      return render_unauthorised_json("Unauthorized")
    end

    unless ::Serving::Table.active.exists?(token: table_token)
      return render_unauthorised_json("Unauthorized")
    end
  end

  def has_sufficient_params(params_list)
    params_list.each do |param|
      unless params[param].present?
        render_error_json "#{param} is mandatory".camelize
        return false
      end
    end
    return true
  end

  def render_success_response(data, message = "Excecuted successfully")
    response = { status: "success", data: data, message: message }
    render json: response, status: 200
  end

  def render_500_json(message)
    response = { status: "error", message: message }
    render json: response, status: 500
  end

  def render_unauthorised_json(message)
    response = { status: "error", message: message }
    render json: response, status: 401
  end
end
