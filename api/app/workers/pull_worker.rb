require 'net/http'
require 'json'

class PullWorker
  include Sidekiq::Worker

  def pull_countries
    fields = ['name', 'alpha3Code', 'population', 'area', 'currencies']
    route =  'http://restcountries.eu/rest/v2/all'

    url = URI.parse(route + '?fields=' + fields.join(';'))
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(request)
    }
    JSON.parse response.body
  rescue
    []
  end

  def convert_countries server_countries_list
    server_countries_list.map { |country| {
      :name => country['name'],
      :code => country['alpha3Code'],
      :population_density => (
        (country['population'] / country['area']).round(2) rescue nil
      ),
      :currency => (country['currencies'][0]['code'] rescue nil)
    }}
  end

  def pull_conversions currencies
    route = 'http://data.fixer.io/api/latest';
    access_key = 'e763fa85c83936298ea73a446ee1eed5'
    base = 'EUR'

    access_key_path = '?access_key=' + access_key
    base_path = '&base=' + base
    symbols_path = '&symbols=' + currencies.join(',')
    format_path = '&format=1'

    url = URI.parse(route + access_key_path + base_path + symbols_path + format_path)
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(request)
    }

    responseJSON = (JSON.parse response.body)
    responseJSON['rates']
  rescue
    {}
  end

  def perform()
    server_countries_list = pull_countries
    countries_list = convert_countries server_countries_list

    countries_list.map { |country| Country.update_info country }

    currencies = Country.get_currencies
    conversions = pull_conversions currencies

    conversions.keys.map { |currency|
      Country.update_conversation_rate currency, conversions[currency]
    }
  end
end
