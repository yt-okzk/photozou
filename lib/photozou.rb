require 'photozou/configurable'
require 'photozou/client'

module Photozou
  class << self
    include Photozou::Configurable

    def client
      @client = Photozou::Client.new
    end

  private
    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

Photozou.setup
