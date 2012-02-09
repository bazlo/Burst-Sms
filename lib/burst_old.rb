
require File.expand_path("../burst_sms/version", __FILE__)
require "nokogiri"
require "uri"


module BurstSms
  
BURST_API_URL = "http://burstsms.com/api"

  
  class API
    def initialize(auth_options={})
      @auth_options = auth_options
    end

    def build_xml_request(sender, body, recipients)
      #sanitize inputs
      from = sender.gsub(/[^0-9a-z\s]/i, '')
      encoded_body = URI.escape( body, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
      raise "Sender ID is too Long" if from.length > 11
      numbers = recipients.map{|n| n.gsub(/[^0-9]/i, '').gsub(/\A(04)|\A(4)/, '614')}.delete_if{|n| n.length != 11 || !n.start_with?('614')}.uniq.join(',')
      
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.request {
          xml.version "0.3"
          xml.key @auth_options[:api_key]
          xml.secret @auth_options[:api_secret]
          xml.method_ "messages.multiple"

          xml.params {
              xml.mobile numbers
              xml.message encoded_body
              xml.caller_id from
              xml.sendtime
              xml.contact_list
          }
        }
      end
      builder.to_xml
    end
    
  end
  
  
    def self.hi
     "blah blah"
    end


end
