require 'happymapper'

module BurstSms
  module ListsGet

    def get_lists(offset=0, limit=50)
      response = post_to_api(get_lists_body(offset, limit))
      Response.parse(response.body)
    end
    
    def get_lists_body(offset, limit)
      build_request("contact-lists.get", :offset => offset,
                                         :limit => limit )
    end

    class Lists
      include HappyMapper
    
      element :id, String
      element :name, String
      element :recipient_count, Integer
    
    end
  
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
    
      has_many :lists, Lists, :tag => 'data'
    
    end
  end
end