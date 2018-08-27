require 'net/http'
require 'json'

class FeedCurrenciesJob < ApplicationJob
  queue_as :default

  def getDataFromServer currencies
    route = 'http://data.fixer.io/api/latest';
    access_key = 'e763fa85c83936298ea73a446ee1eed5'
    base = 'EUR'

    access_key_path = '?access_key=' + access_key
    base_path = '&base=' + base
    symbols_path = '&symbols=' + currencies.join(',')
    format_path = '&format=1'

    # puts route + access_key_path + base_path + symbols_path + format_path

    url = URI.parse(route + access_key_path + base_path + symbols_path + format_path)
    request = Net::HTTP::Get.new(url.to_s)
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.request(request)
    }

    responseJSON = (JSON.parse response.body)
    responseJSON['rates']
  end

  def updateData(currencies)
    currencies.keys.map { |currency|
      Country.update_conversation_rate currency, currencies[currency]
    }
  end

  def perform()
    data = (getDataFromServer(Country.get_currencies) rescue [])
    updateData( data )
  end
end
