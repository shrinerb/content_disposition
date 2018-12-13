# ContentDisposition

[![Gem Version](https://badge.fury.io/rb/content_disposition.svg)](https://badge.fury.io/rb/content_disposition)

Creating a properly encoded and escaped standards-complaint HTTP
Content-Disposition header for potential non-ascii filenames is surprisingly
confusing.

This gem does that and only that, in a single 50-line file with no dependencies.
It's code is shamelessly extracted and adapted from Rails'
`ActionDispatch::HTTP::ContentDisposition` class.

```ruby
require 'content_disposition'

headers["Content-Disposition"] = ContentDisposition.format(disposition: :attachment, filename: "racecar.jpg").to_s
ContentDisposition.format(disposition: "attachment", filename: "råcëçâr.jpg").to_s
ContentDisposition.new(disposition: :inline, filename: "автомобиль.jpg").to_s
```

A proper content-disposition value for non-ascii filenames has a pure-ascii
as well as an ascii component. By default the filename will be turned into ascii,
for the ascii component by replacing any non-ascii chars with `'?'` (which is
then properly percent-escaped in output).

```ruby
ContentDisposition.format(disposition: "attachment", filename: "råcëçâr.jpg").to_s
# => "attachment; filename=\"r%3Fc%3F%3F%3Fr.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

But you can pass in your own proc to do it however you want. If you have a
dependency on the i18n gem, and want to do it just like Rails:

```ruby
ContentDisposition.format(disposition: "attachment",
  filename: "råcëçâr.jpg",
  to_ascii: ->(str) { I18n.transliterate(str) }
).to_s
# => "attachment; filename=\"racecar.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

That's it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'content_disposition'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install content_disposition


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shrinerb/content_disposition.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
