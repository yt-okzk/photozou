require 'helper'

describe Photozou do
  before(:all) do
    Photozou.setup
  end

  it "should be configurable" do
    lambda {
      Photozou.configure do |config|
        config.username = 'hoge'
        config.password = 'fuga'
      end
    }.should_not raise_error

    Photozou.options[:username].should == 'hoge'
    Photozou.options[:password].should == 'fuga'
  end

  it "should accept ENV variables as configuration" do
    original_username = ENV['PHOTOZOU_USERNAME']
    original_password = ENV['PHOTOZOU_PASSWORD']

    ENV['PHOTOZOU_USERNAME'] = 'hoge'
    ENV['PHOTOZOU_PASSWORD'] = 'fuga'

    Photozou.options[:username].should == 'hoge'
    Photozou.options[:password].should == 'fuga'

    # Restore original ENV
    ENV['PHOTOZOU_USERNAME'] = original_username
    ENV['PHOTOZOU_PASSWORD'] = original_password
  end
end

describe Photozou::Client do
  let(:nop_ok) {<<-EOXML
    <?xml version="1.0" encoding="UTF-8" ?>
    <rsp stat="ok">
      <info>
        <user_id>123456789</user_id>
      </info>
    </rsp>
    EOXML
  }

  before(:all) do
    Photozou.setup
  end

  describe "nop" do
    it "should request to nop API via GET" do
      http = Net::HTTP.new("localhost")
      http.should_receive(:request).with(kind_of(Net::HTTP::Get)).and_return do |request|
        response = Net::HTTPOK.new(nil, 200, nil)
        response.stub!(:body).and_return(nop_ok)
        response
      end
      Net::HTTP.should_receive(:new).at_least(1).and_return(http)

      xml = Photozou.nop
      xml.rsp.info.user_id.text.should == "123456789"
    end
  end
end
