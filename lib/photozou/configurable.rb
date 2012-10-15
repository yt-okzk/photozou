require 'photozou/default'

module Photozou
  module Configurable
    attr_writer :username, :password

    class << self
      def keys
        @keys ||= [:username, :password]
      end
    end

    def configure
      yield self
      self
    end

    def options
      Hash[Photozou::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def reset!
      Photozou::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", Photozou::Default.options[key])
      end
    end
    alias setup reset!
  end
end
