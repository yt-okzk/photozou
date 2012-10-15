module Photozou
  module Default
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
    end
  end
end
