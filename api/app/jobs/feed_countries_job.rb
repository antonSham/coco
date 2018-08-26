require 'net/http'
require 'json'

class FeedCountriesJob < ApplicationJob
  queue_as :default

  def getDataFromServer()
    fields = ['name', 'alpha3Code', 'population', 'area', 'currencies']
    route =  'http://restcountries.eu/rest/v2/all'

    url = URI.parse(route + '?fields=' + fields.join(';'))
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(request)
    }
    countries = (JSON.parse response.body)
    countries.map { |country| {
      :name => country['name'],
      :code => country['alpha3Code'],
      :population_density => (
        (country['population'] / country['area']).round(2) rescue nil
      ),
      :currency => (country['currencies'][0]['code'] rescue nil)
    }}
  end

  def updateData(countries)
    countries.map { |country| Country.update_info country }
  end

  def perform()
    data = (getDataFromServer() rescue [])
    updateData( data )
  end
end
