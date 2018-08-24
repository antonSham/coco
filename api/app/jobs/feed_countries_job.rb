require 'net/http'
require 'json'

class FeedCountriesJob < ApplicationJob
  queue_as :default

  def getData()
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

  # def updateData(countries)
  #   countries.forEach { |country| {
  #     Model.country
  #   }}
  # end

  def perform()
    countries = getData()
    puts countries
  end
end
