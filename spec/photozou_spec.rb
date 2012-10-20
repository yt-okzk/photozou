require 'spec_helper'

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

  let(:photo_album_ok) {<<-EOXML
<?xml version="1.0" encoding="UTF-8" ?>
<rsp stat="ok">
<info>
  <album>
    <album_id>87654321</album_id>
    <user_id>12345678</user_id>
    <name><![CDATA[album name]]></name>
    <description>description</description>
    <perm_type>deny</perm_type>
    <perm_type2>all</perm_type2>
    <order_type>upload</order_type>
    <copyright_type>normal</copyright_type>
    <copyright_commercial>yes</copyright_commercial>
    <copyright_modifications>yes</copyright_modifications>
    <photo_num>9</photo_num>
    <perm_msg>private</perm_msg>
    <cover_photo_id>12344321</cover_photo_id>
    <cover_image_url>http://cover</cover_image_url>
    <cover_original_image_url>http://original</cover_original_image_url>
    <cover_thumbnail_image_url>http://thumb</cover_thumbnail_image_url>
    <upload_email>test@photozou.jp</upload_email>
    <created_time>2012-08-26T20:38:18+09:00</created_time>
    <updated_time>2012-08-26T20:44:14+09:00</updated_time>
  </album>
</info>
</rsp>
    EOXML
  }

  let(:photo_album_photo_ok) {<<-EOXML
<?xml version="1.0" encoding="UTF-8" ?>
<rsp stat="ok">
  <info>
    <cover_photo_id>10203040</cover_photo_id>
    <cover_image_url>http://cover_image</cover_image_url>
    <cover_original_image_url>http://cover_original</cover_original_image_url>
    <cover_thumbnail_image_url>http://cover_thumb</cover_thumbnail_image_url>
    <photo_num>1</photo_num>
    <photo>
      <photo_id>1</photo_id>
      <user_id>12345678</user_id>
      <album_id>876554321</album_id>
      <photo_title>title</photo_title>
      <favorite_num>1</favorite_num>
      <comment_num>0</comment_num>
      <view_num>10</view_num>
      <copyright>normal</copyright>
      <original_height>360</original_height>
      <original_width>480</original_width>
      <date>2012-08-15</date>
      <regist_time>2012-08-26T20:44:12+09:00</regist_time>
      <url>http://photozou.jp/test</url>
      <image_url>http://image</image_url>
      <original_image_url>http://original</original_image_url>
      <thumbnail_image_url>http://thumb</thumbnail_image_url>
      <tags>
        <tag>tag1</tag>
        <tag>tag2</tag>
      </tags>
    </photo>
  </info>
</rsp>
    EOXML
  }

  before(:all) do
    Photozou.setup
  end

  def create_http_mock(result)
    http = Net::HTTP.new("127.0.0.1")
    http.should_receive(:request).with(kind_of(Net::HTTP::Get)).and_return do |request|
      response = Net::HTTPOK.new(nil, 200, nil)
      response.stub!(:body).and_return(result)
      response
    end
    Net::HTTP.should_receive(:new).at_least(1).and_return(http)
  end

  describe "nop" do
    it "should request to nop API via GET" do
      create_http_mock(nop_ok)

      xml = Photozou.nop
      xml.rsp.info.user_id.text.should == "123456789"
    end
  end

  describe "photo_album" do
    it "should request to photo_album API via GET" do
      create_http_mock(photo_album_ok)

      xml = Photozou.photo_album
      xml.rsp.info.album.album_id.text.should == "87654321"
      xml.rsp.info.album.user_id.text.should  == "12345678"
    end
  end

  describe "photo_album_photo" do
    it "should request to photo_album_photo API via GET" do
      create_http_mock(photo_album_photo_ok)

      xml = Photozou.photo_album_photo :album_id => 1234
      xml.rsp.info.photo.photo_id.text.should == "1"
      xml.rsp.info.photo.user_id.text.should  == "12345678"
    end
  end
end
