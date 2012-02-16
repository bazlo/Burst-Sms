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

**Send a SMS** - [messages.multiple](http://burstsms.com/api-documentation/messages.multiple)

    @burstsms.send_message('caller_id', 'recipients', 'message')

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

**Retrieve history of sent messages** - [messages.get](http://burstsms.com/api-documentation/messages.get)

    @burstsms.get_messages()  
    
    #takes optional offset and/or limit(default is 50)
    @burstsms.get_messages(2,10)

TODO
----

- Complete all user API functions.
- Add reseller API functions.

Licence
-------

Copyright © 2012 Made in Data Pty Ltd and David Barlow [@madeindata](http://twitter.com/madeindata). Refer to terms in LICENCE file.