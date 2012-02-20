# Burst Sms   [![Build Status](https://secure.travis-ci.org/madeindata/Burst-Sms.png?branch=master)](http://travis-ci.org/madeindata/Burst-Sms)

Rubygem for the Burst SMS API. Sends SMS to Australian mobiles  
For use with a [burstsms.com.au](http://burstsms.com.au) account.

Installation
------------

    gem install 'burstsms'

or add the following line to Gemfile:  

    gem 'burstsms'
 
and run `bundle` from your shell.

Usage
-----
**Create an authenticated instance**

    @burstsms = BurstSms::API.new('api_key', 'secret')
    
**Responses**    
Responses from the API are converted into ruby objects with attributes you can access. 
 
Available attributes for each method are listed in their description below.  

Every method will return a `error` attribute if something goes wrong


**Send a SMS** - [messages.multiple](http://burstsms.com/api-documentation/messages.multiple)

    @burstsms.send_message('caller_id', 'recipients', 'message')
    
    Response attributes :result :total_recipients :total_recipients_queued :message_id :contact_list_addition

  `caller_id` Can be a Number upto 15 digits or a alpha-numeric string upto 11 characters.  
  `recipient/s` A single mobile number or an array of mobile numbers for multiple recipients.  
  `message` String containing sms message to send.  
  optional:  
  `sendtime` Set specific time to send message.  
  `contact_list` Add recipients to an existing contact list in your account.
  
  *__NOTE:__The gem handles conversion of mobile numbers to the format required by the API. Also duplicate and invalid numbers will be deleted from the array.*  
  __example__: you can pass in an array of numbers like `['+61 414 899 766', '0403 855 555', '0403-855-445']` and it will be converted to `['61414899766', '61403855555', '61403855445']`
  
------

Additional Methods  
------------------
  
**Send a SMS to an existing list** - [messages.add](http://burstsms.com/api-documentation/messages.add)

    @burstsms.add_message('caller_id', 'list_id', 'message')
    
    #returns :total :time :result :message_id :list_id :message :cost :balance :charge_error

**Retrieve history of sent messages** - [messages.get](http://burstsms.com/api-documentation/messages.get)

    @burstsms.get_messages()  #takes optional arguments offset and limit(default is 50)
    
    #returns :total :time :messages
    #messages return :id :list_id :mobile_from :message :datetime_send :datetime_actioned :recipient_count :status :schedule
    
**Retrieve responses from a message** - [messages.responses](http://burstsms.com/api-documentation/messages.responses)

    @burstsms.message_responses('message_id')   #takes optional arguments offset and limit(default is 50)  
    
    #returns :total :time :replies
    #replies return :firstname :lastname :mobile :message :datetime_entry_orig

**Retrieve Contact Lists** - [contact-lists.get](http://burstsms.com/api-documentation/contact-lists.get)

    @burstsms.get_lists()  #takes optional arguments offset and limit(default is 50) 
    
    #returns :total :time :lists
    #lists return :id :name :recipient_count

**Add Contact List** - [contact-lists.add](http://burstsms.com/api-documentation/contact-lists.add)

    @burstsms.add_list('name of new list')    
    
    #returns :total :time :name :list_id :recipient_count
    
**Delete Contact List** - [contact-lists.delete](http://burstsms.com/api-documentation/contact-lists.delete)

    @burstsms.delete_list('list_id')  
    
    #returns :total :time :response  
    
**Retrieve Contact List Recipients** - [contact-lists.get-recipients](http://burstsms.com/api-documentation/contact-lists.get-recipients)

    @burstsms.get_list_recipients('list_id')   #takes optional arguments offset and limit(default is 50)  

    #returns :total :time :recipients 
    #recipients return :firstname :lastname :mobile :datetime_entry :dest_country :bounce_count
    
**Retrieve Contact List Unsubscribed** - [contact-lists.get-unsubscribed](http://burstsms.com/api-documentation/contact-lists.get-unsubscribed)

    @burstsms.get_list_unsubscribed('list_id')   #takes optional arguments offset and limit(default is 50)  

    #returns :total :time :recipients 
    #recipients return :firstname :lastname :mobile :datetime_entry :dest_country :bounce_count    
    
**Add Contact List Recipient** - [contact-lists.add-recipient](http://burstsms.com/api-documentation/contact-lists.add-recipient)

    @burstsms.add_list_recipient("list_id", "mobile_number", :firstname => 'Bob', :lastname => 'Smith') #name fields optional    

    #returns :total :time :result :list_id
    #refer to Burst Sms docs for possible result values  
    
**Delete Contact List Recipient** - [contact-lists.delete-recipient](http://burstsms.com/api-documentation/contact-lists.delete-recipient)

    @burstsms.delete_list_recipient("list_id", "mobile_number")    

    #returns :total :time :result
    #refer to Burst Sms docs for possible result values  

------

Under the Hood
--------------

The `burstms` gem uses:

- [UnhappyMapper](https://github.com/burtlo/happymapper) and [Nokogiri](http://nokogiri.org/) to handle the XML ugliness.
- [HTTParty](https://github.com/jnunemaker/httparty) for the HTTP interaction with the API.

**TODO**

- Complete 'contact-lists.add-multiple-recipients'
- Add reseller API functions.

Licence
-------

Copyright &copy; 2012 *Made in Data Pty Ltd* and *David Barlow* [@madeindata](http://twitter.com/madeindata). Refer to terms in LICENCE file.