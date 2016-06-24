# Logs.tf interface [![Build Status](https://secure.travis-ci.org/Arie/logs_tf.png)](http://travis-ci.org/Arie/logs_tf) [![Dependencies](https://gemnasium.com/Arie/logs_tf.png)](https://gemnasium.com/Arie/logs_tf.png) [![Code Climate](https://codeclimate.com/github/Arie/logs_tf.png)](https://codeclimate.com/github/Arie/logs_tf) [![Coverage Status](https://coveralls.io/repos/github/Arie/logs_tf/badge.svg?branch=master)](https://coveralls.io/r/Arie/logs_tf) 

A gem for the logs.tf API

## Usage

- Get an account and API key on [logs.tf](http://logs.tf)
- Set a constant called LogsTF:API_KEY or use it as an argument in the next step
- Create a log object.

```ruby
log = LogsTF::Log.new(File.open('logfile.log'), 'map_name', 'title', 'api_key')
```

- Create the upload object: 

```ruby
upload = LogsTF::Upload.new(log)
```

- If there something wrong an error will be raised which you can rescue and inspect the message of:

```ruby
begin
  upload.send
rescue Exception => e
  puts "The error is #{e.message}"
end
```

- If everthing's alright, you can get the URL to the uploaded log:

```ruby
  upload.send
  upload.url
```
