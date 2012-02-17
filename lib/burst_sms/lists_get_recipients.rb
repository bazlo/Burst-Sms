require 'happymapper'

module BurstSms
  module ListsGetRecipients

    def get_list_recipients(id, offset=0, limit=50)
      response = post_to_api(get_list_recipients_body(id, offset, limit))
      Response.parse(response.body)
    end
    
    def get_list_recipients_body(id, offset, limit)
      build_request("contact-lists.recipients", :id => id,
                                                :offset => offset,
                                                :limit => limit )
    end

    class Recipients
      include HappyMapper
    
      element :mobile, String
      element :firstname, String
      element :lastname, String
      element :datetime_entry, String
      element :dest_country, String
      element :bounce_count, Integer
    
    end
  
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
    
      has_many :recipients, Recipients, :tag => 'data'
    
    end
  end
end