require 'happymapper'

module BurstSms
  module ListsDelete
    
    def delete_list(id)
      @response = post_to_api(delete_list_body(id))
      Response.parse(@response.body)
    end
    
    def delete_list_body(id)
      build_request("contact-lists.delete", :id => id)
    end

    class Response
      include HappyMapper
      tag 'xml'
      
      element :error, String
      element :total, String
      element :time, String
      element :timestamp, String
      element :response, String
      
    
    end
  end
end