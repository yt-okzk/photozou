module Photozou
  module Default
    ENDPOINT = 'http://api.photozou.jp/rest'

    class << self
      def options
        Hash[Photozou::Configurable.keys.map{|key| [key, send(key)]}]
      end

      def username
        ENV['PHOTOZOU_USERNAME']
      end

      def password
        ENV['PHOTOZOU_PASSWORD']
      end

      def endpoint
        ENDPOINT
      end
    end
  end
end
