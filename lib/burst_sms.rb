require 'uri'
require 'happymapper'
require 'httparty'

module BurstSms
  
  class Param
    
    include HappyMapper
    tag 'params'
  
    element :mobile, String
    element :message, String
    element :sendtime, Time
    element :caller_id, String
    
    def initialize(parameters=[])
      parameters.each_pair do |property,value|
        send("#{property}=",value) if respond_to?("#{property}=")
      end
    end
  
  end
  
  class ResponseData
    
    include HappyMapper
    tag 'xml'
  
    element :result, String, :xpath => "data/result"
    element :total_recipients, String, :xpath => "data/total_recipients"
    element :total_recipients_queued, String, :xpath => "data/total_recipients_queued"
    element :message_id, String, :xpath => "data/message_id"
    element :error, String
    
  end
  
  class API
    API_URL = "http://burstsms.com/api"
    API_VERSION = 0.3
    
    include HappyMapper
    tag 'request'
    
    element :version, Float
    element :key, String
    element :secret, String
    element :api_method, String, :tag => 'method_'
    
    has_one :params, Param
    
    def initialize(api_key, api_secret)
      self.key = api_key
      self.secret = api_secret
      self.version = API_VERSION
    end
    
    def send_message(from, recipients, message)
      #XML request has to be wrapped as a 'request' param in body
      response = HTTParty.post( API_URL, :body => "request=#{self.build_message(from, recipients, message)}" )
      ResponseData.parse(response.body)
    end
    
    def build_message(from, recipients, message)
      self.params = Param.new(:mobile => sanitize_numbers(recipients), :caller_id => check_valid_sender(from), :message => encode_msg(message))
      self.api_method = "messages.multiple"
      self.to_xml()
    end
    
    private
    
    def sanitize_numbers(recipients)
      recipients.map{|n| n.gsub(/[^0-9]/i, '').gsub(/\A(04)|\A(4)/, '614')}.delete_if{|n| n.length != 11 || !n.start_with?('614')}.uniq.join(',')
    end
    
    def encode_msg(message)
      URI.escape( message, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    
    def check_valid_sender(from)
      sender = from.gsub(/[^0-9a-z_\s]/i, '')
      if sender =~ /\D/ 
        raise "Sender ID is too Long" if sender.length > 11
      else
        raise "Sender Number is too Long" if sender.length > 15
      end
      return sender
    end
    
  end


end
