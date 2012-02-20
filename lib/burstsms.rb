require 'uri'
require 'happymapper'
require 'httparty'


module BurstSms
  
  class ParamBuilder
    include HappyMapper
    tag 'params'
    def initialize(parameters={})
      parameters.each do |property,value|
        self.class.element property, String unless respond_to?("#{property}=")
        send("#{property}=",value) if respond_to?("#{property}=")   
      end
    end
  end
    
end


require 'burstsms/messages_multiple'
require 'burstsms/messages_get'
require 'burstsms/messages_add'
require 'burstsms/message_responses'
require 'burstsms/lists_get'
require 'burstsms/lists_add'
require 'burstsms/lists_delete'
require 'burstsms/lists_get_recipients'
require 'burstsms/lists_get_unsubscribed'
require 'burstsms/lists_add_recipient'
require 'burstsms/lists_delete_recipient'


require 'burstsms/api'


