# Burst Sms 

Ruby Gem for the Burst SMS api. Send SMS to Australian mobiles  
For use with a [burstsms.com.au](http://burstsms.com.au) account.

Installation
------------

    gem install 'burstsms'

or add the following line to Gemfile:  

    gem 'burstsms'
 
and run `bundle` from your shell.

Usage
-----
Create a authenticated instance

    @burstsms = BurstSms::API.new('api_key', 'secret')

**Send a SMS** - [messages.multiple](http://burstsms.com/api-documentation/messages.multiple)

    @burstsms.send_message('caller_id', 'recipients', 'message')

  `caller_id` Can be a Number upto 15 digits or a alpha-numeric string upto 11 characters.  
  `recipient/s` A single mobile number or an array of mobile numbers for multiple recipients.  
  `message` String containing the the sms message to send.  

**Send a SMS to an existing list** - [messages.add](http://burstsms.com/api-documentation/messages.add)

    @burstsms.add_message('caller_id', 'list_id', 'message')

**Retrieve history of sent messages** - [messages.get](http://burstsms.com/api-documentation/messages.get)

    @burstsms.get_messages()  
    #takes optional offset and/or limit(default is 50) params  
    @burstsms.get_messages(2,10)

TODO
----

- Complete all user API functions.
- Add reseller API functions.

LICENCE
-------

Copyright (c) 2012 Made in Data Pty Ltd and David Barlow  
Refer to terms in LICENCE file