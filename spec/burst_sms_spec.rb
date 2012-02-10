require 'spec_helper'


describe BurstSms do
  
  before(:all) do
    @burst = BurstSms::API.new("79798797897", "x")
  end
  
  context "Burst API credentials" do
  
    it "Populates the API credentials in XML requests" do
      @request_body = @burst.get_messages_body(0,50)
      @nok_parsed = Nokogiri::XML(@request_body)
      @nok_parsed.should have_xml('//request/key', '79798797897')
      @nok_parsed.should have_xml('//request/secret', 'x')
    end
     
  end
  
  context "'messages.multiple' - http://burstsms.com/api-documentation/messages.multiple" do 
    
    before(:all) do
      #numbers cocktail has numbers which are valid(5 out of 10 in array) + too short, too long, landlines, duplicates, non-numerical. tests gsub formula
      @numbers_cocktail = ['61490900900', '61490900910', '+61 414 899 766', '0403 855 445', '0403-855-445', '0487-000-777', '0987 788 665', '0455 777 3334', '0455 678 87', '09AB 009 456']
      @request_body = @burst.send_message_body('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @nok_parsed = Nokogiri::XML(@request_body)
    end
  
    it "Builds correct XML structure" do
      nodes = ['//request/method', '//request/params/mobile', '//request/params/message', '//request/params/caller_id']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Add sendtime and contact_list if present" do
    time = Time.now
    @request_body = @burst.send_message_body('6147779990', @numbers_cocktail, "sms txt\n of words and such:/", :sendtime => time, :contact_list => "123456")
    nok_request = Nokogiri::XML(@request_body)
    nok_request.should have_xml("//request/params/sendtime")
    nok_request.should have_xml("//request/params/contact_list")
    end
  
    it "Processes Recipient Numbers: Sanitises format, deletes invalid and duplicates" do
      @nok_parsed.should have_xml('//params/mobile', "61490900900,61490900910,61414899766,61403855445,61487000777")
    end
    
    it "Handles single recipient number" do
      @single_num = @burst.send_message_body('6147779990', '0404 678 876', "sms" )
      Nokogiri::XML(@single_num).should have_xml('//params/mobile', '61404678876')
    end
  
    it "Encodes message body to URI format" do
      @nok_parsed.should have_xml('//params/message', 'sms%20txt%0A%20of%20words%20and%20such%3A%2F')
    end
  
    it "Checks sender ID Length" do
      expect {@burst.send_message_body('61477799900a', @numbers_cocktail, "sms" ) }.to raise_error("Sender ID is too Long")
      expect {@burst.send_message_body('6147779990012345', @numbers_cocktail, "sms" ) }.to raise_error("Sender Number is too Long")
      
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/messages_multiple.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/send_message_success.txt'))
      @response = @burst.send_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @response.result.should == 'queued'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/send_message_failure.txt"))
      @response = @burst.send_message('6147779990', @numbers_cocktail, "sms txt\n of words and such:/" )
      @response.result.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'messages.get' - http://burstsms.com/api-documentation/messages.get" do
  
    it "Builds correct XML structure" do
      @request_body = @burst.get_messages_body(0,50)
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/offset', '//request/params/limit']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/messages_get.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/messages_get_success.txt'))
      @response = @burst.get_messages()
      @response.total.should == '67'
      @response.messages.size.should == 4
      @response.messages.first.id.should == "28153"
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/messages_get_failure.txt"))
      @response = @burst.get_messages()
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'messages.add' - http://burstsms.com/api-documentation/messages.add" do
    
    it "Builds correct XML structure" do
      @request_body = @burst.add_message_body('6147779990', 123 , "sms txt\n of words and such:/")
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/method', '//request/params/list_id', '//request/params/caller_id', '//request/params/message']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/messages_add.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/messages_add_success.txt'))
      @response = @burst.add_message('6147779990', 1075 , "sms txt\n of words and such:/")
      @response.total.should == '1'
      @response.result.should == 'queued'
      @response.list_id.should == "1075"
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/messages_add_failure.txt"))
      @response = @burst.add_message('6147779990', 1075 , "sms txt\n of words and such:/")
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
    
    it "Encodes message body to URI format" do
      @request_body = @burst.add_message_body('6147779990', 123 , "sms txt\n of words and such:/")
      @nok_parsed = Nokogiri::XML(@request_body)
      @nok_parsed.should have_xml('//params/message', 'sms%20txt%0A%20of%20words%20and%20such%3A%2F')
    end
  
    it "Checks sender ID Length" do
      expect {@burst.add_message_body('61477799900a', 1075, "sms" ) }.to raise_error("Sender ID is too Long")
      expect {@burst.add_message_body('6147779990012345', 1075, "sms" ) }.to raise_error("Sender Number is too Long")
      
    end
  end

end