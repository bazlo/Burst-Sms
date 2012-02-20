require 'happymapper'

module BurstSms
  module ListsAdd

    def add_list(name)
      response = post_to_api(add_list_body(name))
      Response.parse(response.body)
    end
    
    def add_list_body(name)
      build_request("contact-lists.add", :name => name)
    end
    
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
      
      element :name, String, :xpath => "data/name"
      element :recipient_count, String, :xpath => "data/recipient_count"
      element :list_id, String, :xpath => "data/id"
    
    end
  end
end