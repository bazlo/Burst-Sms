require 'happymapper'

module BurstSms
  module MessagesGet

    def get_messages(offset=0, limit=50)
      response = post_to_api(get_messages_body(offset, limit))
      Response.parse(response.body)
    end
    
    def get_messages_body(offset, limit)
      build_request("messages.get", :offset => offset,
                                    :limit => limit )
    end

    class Messages
      include HappyMapper
    
      element :id, String
      element :list_id, String
      element :mobile_from, String
      element :message, String
      element :datetime_send, Time
      element :datetime_actioned, Time
      element :recipient_count, Integer
      element :status, String
      element :schedule, String
    
    end
  
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
    
      has_many :messages, Messages, :tag => 'data'
    
    end
  end
end