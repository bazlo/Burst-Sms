require 'happymapper'

module BurstSms
  module MessagesAdd
    
    def add_message(from, list_id, message, options={})
      @response = post_to_api(add_message_body(from, list_id, message, options))
      Response.parse(@response.body)
    end
    
    def add_message_body(from, list_id, message, options={})
      build_request("messages.add", :caller_id => check_valid_sender(from),
                                    :list_id => list_id,
                                    :message => encode_msg(message),
                                    :sendtime => (options.has_key?(:sendtime) ? options[:sendtime] : nil),
                                    :contact_list => (options.has_key?(:contact_list) ? options[:contact_list] : nil))
    end

    class Response
      include HappyMapper
      tag 'xml'
      
      element :error, String
      element :total, String
      element :time, String
      element :timestamp, String
      
      element :result, String, :xpath => "data/result"
      element :message_id, String, :xpath => "data/message_id"
      element :list_id, String, :xpath => "data/list_id"
      element :message, String, :xpath => "data/message"
      element :cost, String, :xpath => "data/cost"
      element :balance, String, :xpath => "data/balance"
      element :charge_error, String, :xpath => "data/charge_error"
      
    
    end
  end
end