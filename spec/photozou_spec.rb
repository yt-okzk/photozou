require 'helper'

describe Photozou do
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
end