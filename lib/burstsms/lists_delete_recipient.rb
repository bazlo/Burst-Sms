require 'happymapper'

module BurstSms
  module ListsDeleteRecipient
    
    def delete_list_recipient(list_id, mobile)
      @response = post_to_api(delete_list_recipient_body(list_id, mobile))
      Response.parse(@response.body)
    end
    
    def delete_list_recipient_body(list_id, mobile)
      build_request("contact-lists.delete-recipient", :mobile => mobile,
                                                      :list_id => list_id)
    end

    class Response
      include HappyMapper
      tag 'xml'
      
      element :error, String
      element :total, String
      element :time, String
      element :timestamp, String
      element :result, String
      
    
    end
  end
end