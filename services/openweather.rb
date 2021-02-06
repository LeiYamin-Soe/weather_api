module Openweather
  class Search
    def self.by_location(id)
      Faraday.get 'https://api.openweathermap.org/data/2.5/forecast?id=' + id + '&appid=271efb0cbf1b16ae131a15aa6b26ded3'
    end
    def self.by_summary(ids)
      Faraday.get 'http://api.openweathermap.org/data/2.5/group?id='+ ids + '&appid=271efb0cbf1b16ae131a15aa6b26ded3'
    end
  end
end
