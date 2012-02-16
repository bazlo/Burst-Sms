# Burst Sms 

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
    
## Responses  
Responses from the API are converted into a ruby objects with attributes you can access.

Every method will return a `error` attribute if something goes wrong:

__example__: 

    response = @burstsms.get_messages()

    response.messages.each { |msg| puts msg.id }

Available attributes for each method are listed in their description below.

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
  
  
  

**Send a SMS to an existing list** - [messages.add](http://burstsms.com/api-documentation/messages.add)

    @burstsms.add_message('caller_id', 'list_id', 'message')
    
    Response attributes :total :time :result :message_id :list_id :message :cost :balance :charge_error
    
    
    

**Retrieve history of sent messages** - [messages.get](http://burstsms.com/api-documentation/messages.get)

    @burstsms.get_messages()  #takes optional arguments offset and limit(default is 50)
    
    Response attributes :total :time :messages
    messages attributes :id :list_id :mobile_from :message :datetime_send :datetime_actioned :recipient_count :status :schedule
    
**Retrieve responses from a message** - [messages.responses](http://burstsms.com/api-documentation/messages.responses)

    @burstsms.message_responses('message_id')   #takes optional arguments offset and limit(default is 50)  
    
    Response attributes :total :time :replies
    replies attributes :firstname :lastname :mobile :message :datetime_entry_orig

**Retrieve Contact Lists** - [contact-lists.get](http://burstsms.com/api-documentation/contact-lists.get)

    @burstsms.get_lists()  #takes optional arguments offset and limit(default is 50) 
    
    Response attributes :total :time :lists
    lists attributes :id :name :recipient_count

**Add Contact List** - [contact-lists.add](http://burstsms.com/api-documentation/contact-lists.add)

    @burstsms.add_list('name of new list')    
    
    Response attributes :total :time :name :list_id :recipient_count
    
**Delete Contact List** - [contact-lists.delete](http://burstsms.com/api-documentation/contact-lists.delete)

    @burstsms.delete_list('list_id')  
    
    Response attributes :total :time :response  

TODO
----

- Complete all user API functions.
- Add reseller API functions.

Licence
-------

Copyright © 2012 *Made in Data Pty Ltd* and *David Barlow* [@madeindata](http://twitter.com/madeindata). Refer to terms in LICENCE file.