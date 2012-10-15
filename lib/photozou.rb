require 'photozou/configurable'
require 'photozou/client'

module Photozou
  class << self
    include Photozou::Configurable

    def client
      @client = Photozou::Client.new
    end
  end
end

Photozou.setup
