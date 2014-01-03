# Hwacha [![Build Status](https://travis-ci.org/sdball/hwacha.png?branch=master)](https://travis-ci.org/sdball/hwacha)

Hwacha! Harness the power of Typhoeus to quickly check webpage responses.

## Example

Check a single page.

```ruby
hwacha = Hwacha.new
hwacha.check('rakeroutes.com') do |url, response|
  if response.success?
    puts "Woo, #{url} looks good!"
  else
    puts "Aww, something that isn't success happened."
  end
end
```

Check a bunch of pages! Hwacha!

```ruby
# 20 is also the default
maximum_number_of_requests_to_work_on_in_parallel = 20

hwacha = Hwacha.new(maximum_number_of_requests_to_work_on_in_parallel)

hwacha.check(array_of_webpage_urls) do |url, response|
  # each url is enqueued in parallel using the powerful Typhoeus library!
  # this block is yielded the url and response object for every response!
end
```

The yielded response object is [straight from Typhoeus](https://github.com/typhoeus/typhoeus/blob/master/README.md#handling-http-errors).

```ruby
hwacha.check(array_of_webpage_urls) do |url, response|
  if response.success?
    # hwacha!
  elsif response.timed_out?
    # time makes fools of us all
  elsif response.code == 0
    # misfire!
  else
    # miss! :-(
    # something like 404 in response.code
  end
end
```

Sometimes you don't want to deal with the response object. Sometimes you just
want to fire a bunch of requests and find pages that successfully respond. Ok!

```ruby
hwacha = Hwacha.new

hwacha.find_existing(array_of_webpage_urls) do |url|
  # this block will be called for all urls that successfully respond!
  # hwacha!
end
```

## Alternative API

More fun, more hwacha.

```ruby
# fire is an alias for #check
hwacha.fire('rakeroutes.com') do |url, response|
  puts "Checking %s" % url
  if response.success?
    puts "success!"
  else
    puts "failed."
  end
end

# strike_true is an alias for #find_existing
successful = 0
hwacha.strike_true(unknown_pages) do |url|
  successful += 1
end
puts "Hwacha! #{successful} hits!"
```

## Installation

Add this line to your application's Gemfile:

    gem 'hwacha'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hwacha

