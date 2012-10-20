require 'net/http'
require 'uri'
require 'nokogiri'

Net::HTTP.version_1_2

module Photozou
  class Client
    def nop
      request(:get, "/nop")
    end

    def photo_album
      request(:get, "/photo_album")
    end

    def photo_album_photo(params={})
      request(:get, "/photo_album_photo", {:album_id => nil, :limit => 100, :offset => 0}.merge(params))
    end


  private
    def request(method, path, params={})
      url = URI.parse(Photozou.endpoint + path)

      Net::HTTP.start(url.host, url.port) do |http|
        # Get class name from string dynamically
        req = class_from_string("Net::HTTP::#{method.to_s.capitalize}").new(url.path)

        req.basic_auth Photozou.options[:username],
                       Photozou.options[:password]
        return Nokogiri.Slop http.request(req).body
      end
    end

    def class_from_string(str)
      str.split("::").inject(Object) do |mod, class_name|
        mod.const_get(class_name)
      end
    end
  end
end
