class WeatherController < ApplicationController
  def location
    if params[:id]
      @response = Openweather::Search.by_location(params[:id])
      @response.body
      @response_hash = get_response_by_location(@response.body)
      #JSON.generate(@response_hash)
      render json: @response_hash
      #JSON.parse(foo)['banks'].map { |e| e['name'] }
    end
  end
  def summary
    if params[:unit]
      unit = params[:unit]
    end
    if params[:locations]
      locations = params[:locations]
    end
      @response = Openweather::Search.by_summary(locations)
      @response.body
      debugger
  end
  def get_response_by_location(response)
    today = Date.today.strftime('%d-%m-%Y')
    city_info_hash = Hash.new
    date_hash = Hash.new
    temp_arr = Array.new

    JSON.parse(response)["city"].map do |city|
      if city[0] == "id" ||  city[0] == "name" ||  city[0] == "country"
        city_info_hash[city[0]] = city[1]
      end
    end

    JSON.parse(response)["list"].map do |list|
      dt_date = list["dt_txt"].to_date.strftime('%d-%m-%Y')
      if today != dt_date
         unless date_hash.key?(dt_date)
           temp_arr = Array.new
         end
         temp_arr << list["main"]["temp"]
	       date_hash[list["dt_txt"].to_date.strftime('%d-%m-%Y')] = temp_arr
      end
    end
    date_temp_hash = Hash[date_hash.map { |k,v| [k, (v.inject(:+) / v.size).round()] }]
    @response_hash = city_info_hash.merge(date_temp_hash)
    return @response_hash
  end
end
