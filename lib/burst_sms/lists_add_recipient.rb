require 'happymapper'

module BurstSms
  module ListsAddRecipient

    def add_list_recipient(list_id, mobile, options={})
      response = post_to_api(add_list_recipient_body(list_id, mobile, options))
      Response.parse(response.body)
    end
    
    def add_list_recipient_body(list_id, mobile, options={})
      build_request("contact-lists.add-recipient",  :list_id => list_id,
                                                    :mobile => mobile,
                                                    :firstname => (options.has_key?(:firstname) ? options[:firstname] : nil),
                                                    :lastname => (options.has_key?(:lastname) ? options[:lastname] : nil),
                                                    :mobile_dest_country => (options.has_key?(:mobile_dest_country) ? options[:mobile_dest_country] : nil)
                                                    )
    end
    
    class Response
      include HappyMapper
      tag 'xml'
  
      element :total, String
      element :time, Time
      element :timestamp, String
      element :error, String
      
      element :result, String, :xpath => "data/result"
      element :list_id, String, :xpath => "data/list_id"
    
    end
  end
end