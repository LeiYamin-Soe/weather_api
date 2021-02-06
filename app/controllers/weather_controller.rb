class WeatherController < ApplicationController
  def location
    if params[:id]
      api_response = Openweather::Search.by_location(params[:id])
      api_response_body = JSON.parse(api_response.body)
      if api_response_body["cod"].present? && api_response_body["cod"] != "200"
        render json: api_response_body
      else
        @response = get_response_by_location(api_response_body)
        render json: @response
      end
    end
  end
  def summary
    unit_num = 0;
    unit = "";
    if params[:unit]
      unit_num = params[:unit].scan(/\d+/)[0]
      if params[:unit].gsub(unit_num, "") == "C" || params[:unit].gsub(unit_num, "") == "c"
        unit = "metric"
      else
        unit = "imperial"
      end
      unit_num = unit_num.to_i
    end
    if params[:locations]
      locations = params[:locations]
    end
      api_response = Openweather::Search.by_summary(locations, unit)
      api_response_body = JSON.parse(api_response.body)
      if api_response_body["cod"].present? && api_response_body["cod"] != "200"
        render json: api_response_body
      else
        @response = get_response_by_summary(api_response_body, unit_num)
        render json: @response
      end
  end
  def get_response_by_location(response)
    today = Date.today.strftime('%d-%m-%Y')
    city_info_hash = Hash.new
    date_hash = Hash.new
    temp_arr = Array.new
    response["city"].map do |city|
      if city[0] == "id" ||  city[0] == "name" ||  city[0] == "country"
        city_info_hash[city[0]] = city[1]
      end
    end
    response["list"].map do |list|
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
    response_hash = city_info_hash.merge(date_temp_hash)
    return response_hash
  end

  def get_response_by_summary(response, unit_num)
    city_info_arr = Array.new
    response["list"].map do |list|
      city_info_hash = Hash.new
      if list["main"]["temp"] > unit_num
        city_info_hash["id"] = list["id"]
        city_info_hash["name"] = list["name"]
        city_info_hash["country"] = list["sys"]["country"]
        city_info_hash["temp"] = list["main"]["temp"].round()
      end
      city_info_arr << city_info_hash
    end
    return city_info_arr
  end
end
