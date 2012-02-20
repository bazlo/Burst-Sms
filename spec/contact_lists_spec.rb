require 'spec_helper'


describe BurstSms do
  
  before(:all) do
    @burst = BurstSms::API.new("79798797897", "x")
  end
  
  context "'contact-lists.get' - http://burstsms.com.au/api-documentation/contact-lists.get"  do
    it "Builds correct XML structure" do
      @request_body = @burst.get_lists_body(0,50)
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/offset', '//request/params/limit']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_get.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_get_success.txt'))
      @response = @burst.get_lists()
      @response.total.should == '2'
      @response.lists.size.should == 2
      @response.lists.first.id.should == "1"
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.get_lists()
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.add' - http://burstsms.com.au/api-documentation/contact-lists.add"  do
    it "Builds correct XML structure" do
      @request_body = @burst.add_list_body("some awesome list name")
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/name']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_add.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_add_success.txt'))
      @response = @burst.add_list("some awesome list name")
      @response.total.should == '1'
      @response.list_id.should == '1211'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.add_list("some awesome list name")
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.delete' - http://burstsms.com.au/api-documentation/contact-lists.delete"  do
    it "Builds correct XML structure" do
      @request_body = @burst.delete_list_body("123")
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/id']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_delete.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_delete_success.txt'))
      @response = @burst.delete_list("123")
      @response.total.should == '1'
      @response.response.should == 'DELETED'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.delete_list("123")
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.get-recipients' - http://burstsms.com.au/api-documentation/contact-lists.get-recipients"  do
    it "Builds correct XML structure" do
      @request_body = @burst.get_list_recipients_body("123", 0, 50)
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/id', '//request/params/offset', '//request/params/limit']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_get_recipients.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_get_recipients_success.txt'))
      @response = @burst.get_list_recipients("123")
      @response.total.should == '3'
      @response.recipients.size.should == 3
      @response.recipients.first.lastname.should == 'Doe'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.get_list_recipients("123")
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.get-unsubscribed' - http://burstsms.com.au/api-documentation/contact-lists.get-unsubscribed"  do
    it "Builds correct XML structure" do
      @request_body = @burst.get_list_unsubscribed_body("123", 0, 50)
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/id', '//request/params/offset', '//request/params/limit']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_get_unsubscribed.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_get_unsubscribed_success.txt'))
      @response = @burst.get_list_unsubscribed("123")
      @response.total.should == '3'
      @response.recipients.size.should == 3
      @response.recipients.first.lastname.should == 'Doe'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.get_list_unsubscribed("123")
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.add-recipient' - http://burstsms.com.au/api-documentation/contact-lists.add-recipient"  do
    it "Builds correct XML structure" do
      @request_body = @burst.add_list_recipient_body("123", '61412123123', :firstname => 'Bob', :lastname => 'Smith')
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/list_id', '//request/params/mobile', '//request/params/firstname', '//request/params/lastname']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_add_recipient.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_add_recipient_success.txt'))
      @response = @burst.add_list_recipient("123", '61412123123', :firstname => 'Bob', :lastname => 'Smith')
      @response.total.should == '1'
      @response.result.should == 'ADDED'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.add_list_recipient("123", '61412123123', :firstname => 'Bob', :lastname => 'Smith')
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
  context "'contact-lists.delete-recipient' - http://burstsms.com.au/api-documentation/contact-lists.delete-recipient"  do
    it "Builds correct XML structure" do
      @request_body = @burst.delete_list_recipient_body("123", '61412123123')
      @nok_parsed = Nokogiri::XML(@request_body)
      nodes = ['//request/key', '//request/secret', '//request/version', '//request/method', '//request/params/list_id', '//request/params/mobile']
      nodes.each { |n| @nok_parsed.should have_xml(n)}
    end
    
    it "Sends correct API request and parses XML response to ruby object" do
      # This has the potential to fail in ruby-1.8 due to Hash ordering... or lack of it.
      stub_request(:post, BurstSms::API_URL).with(:body => File.read('spec/fixtures/api_requests/lists_delete_recipient.txt')).to_return(:status => 200, :body => File.read('spec/fixtures/api_responses/lists_delete_recipient_success.txt'))
      @response = @burst.delete_list_recipient("123", '61412123123')
      @response.total.should == '1'
      @response.result.should == 'DELETED'
      @response.error.should == nil
    end
    
    it "Create error from failed response" do
      stub_request(:post, BurstSms::API_URL).to_return(:status => 200, :body => File.read("spec/fixtures/api_responses/generic_failure.txt"))
      @response = @burst.delete_list_recipient("123", '61412123123')
      @response.total.should == nil
      @response.error.should == 'Authentication failed - key: 797987, secret: x'
    end
  end
  
end