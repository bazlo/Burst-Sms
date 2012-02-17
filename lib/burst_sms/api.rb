require 'happymapper'

module BurstSms
  API_URL = "https://burstsms.com/api"
  API_VERSION = 0.3
  
  class API
    include HappyMapper

    include MessagesMultiple
    include MessagesGet
    include MessagesAdd
    include MessageResponses
    
    include ListsGet
    include ListsAdd
    include ListsDelete
    include ListsGetRecipients
    include ListsGetUnsubscribed

    tag 'request'
    
    element :version, Float
    element :key, String
    element :secret, String
    element :api_method, String, :tag => 'method_'
    
    has_one :params, String
    
    
    
    def initialize(api_key, api_secret)
      self.key = api_key
      self.secret = api_secret
      self.version = BurstSms::API_VERSION
    end
    
    
    
    private
    
    def sanitize_numbers(recipients)
      Array(recipients).map{|n| n.gsub(/[^0-9]/i, '').gsub(/\A(04)|\A(4)/, '614')}.delete_if{|n| n.length != 11 || !n.start_with?('614')}.uniq.join(',')
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
    
    def build_request(api_call, parameters={})
      self.params = ParamBuilder.new(parameters)
      self.api_method = api_call
      self.to_xml()
    end
    
    def post_to_api(request_xml)
      #XML request has to be wrapped as a 'request' param in body
      response = HTTParty.post( BurstSms::API_URL, :body => "request=#{request_xml}" )
    end
    
  end
  
  


end