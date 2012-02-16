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


require 'burst_sms/messages_multiple'
require 'burst_sms/messages_get'
require 'burst_sms/messages_add'
require 'burst_sms/message_responses'
require 'burst_sms/lists_get'
require 'burst_sms/lists_add'
require 'burst_sms/api'


