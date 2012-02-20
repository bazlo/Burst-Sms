require 'happymapper'

module BurstSms
  module MessageResponses

    def message_responses(message_id, offset=0, limit=50)
      response = post_to_api(message_responses_body(message_id, offset, limit))
      Response.parse(response.body)
    end
    
    def message_responses_body(message_id, offset, limit)
      build_request("messages.responses", :message_id => message_id,
                                          :offset => offset,
                                          :limit => limit )
    end

    class Replies
      include HappyMapper
    
      element :firstname, String
      element :lastname, String
      element :mobile, String
      element :datetime_entry_orig, String
      element :message, String
    
    end
  
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
    
      has_many :replies, Replies, :tag => 'data'
    
    end
  end
end