require File.dirname(__FILE__) + '/../lib/burst_sms'
require 'spec_helper'


describe BurstSms do
  
  context "Creates a well formed and sanitised XML request for API" do 
  
    before(:all) do
      @burst = BurstSms::API.new("79798797897", "x")
      #numbers cocktail has numbers which are valid(5 out of 10 in array), too short, too long, landlines, duplicates, non-numerical. tests gsub formula
      @numbers_cocktail = ['61490900900', '61490900910', '+61 414 899 766', '0403 855 445', '0403-855-445', '0487-000-777', '0987 788 665', '0455 777 3334', '0455 678 87', '09AB 009 456']
      @request = @burst.build_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @nok_request = Nokogiri::XML(@request)
    end
  
    it "Builds correct XML structure" do
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/mobile', '//request/params/message', '//request/params/caller_id']
      nodes.each { |n| @nok_request.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      stub_http_request(:post, BurstSms::API::API_URL).with(:body => File.read(File.dirname(__FILE__) + '/fixtures/api_requests/send_message_body.txt')).to_return(:status => 200, :body => File.read(File.dirname(__FILE__) + '/fixtures/api_responses/send_message_success.txt'))
      @response = @burst.send_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @response.result.should == 'queued'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_http_request(:post, BurstSms::API::API_URL).to_return(:status => 200, :body => File.read(File.dirname(__FILE__) + "/fixtures/api_responses/send_message_failure.txt"))
      @response = @burst.send_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @response.result.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
    
    it "Add sendtime and contact_list if present" do
    time = Time.now
    @request = @burst.build_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/", :sendtime => time, :contact_list => "123456")
    @nok_request = Nokogiri::XML(@request)
    @nok_request.should have_xml("//request/params/sendtime")
    @nok_request.should have_xml("//request/params/contact_list")
    end
  
    it "Populates the API credentials" do
      @nok_request.should have_xml('//request/key', '79798797897')
      @nok_request.should have_xml('//request/secret', 'x')
    end
  
    it "Processes Recipient Numbers: Sanitises format, deletes invalid and duplicates" do
      @nok_request.should have_xml('//params/mobile', "61490900900,61490900910,61414899766,61403855445,61487000777")
    end
    
    it "Handles single recipient number" do
      @single_num = @burst.build_message('6147779990', '0404 678 876', "sms" )
      Nokogiri::XML(@single_num).should have_xml('//params/mobile', '61404678876')
    end
  
    it "Encodes message body to URI format" do
      @nok_request.should have_xml('//params/message', 'sms%20txt%0A%20of%20words%20and%20such%3A%2F')
    end
  
    it "Checks sender ID Length" do
      expect {@burst.build_message('61477799900a', @numbers_cocktail, "sms" ) }.to raise_error("Sender ID is too Long")
      expect {@burst.build_message('6147779990012345', @numbers_cocktail, "sms" ) }.to raise_error("Sender Number is too Long")
      
    end
    
  end  

end