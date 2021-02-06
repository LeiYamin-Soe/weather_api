class Api::V1::WeatherController < ActionController::API
  def location
    if params[:id]
      @response = Openweather::Search.by_location(params[:id])
      debugger
      render json: {results: @response_body}.to_json, status: :ok
    end
  end
end
