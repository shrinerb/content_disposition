# ContentDisposition

[![Gem Version](https://badge.fury.io/rb/content_disposition.svg)](https://badge.fury.io/rb/content_disposition)

Creating a properly encoded and escaped standards-compliant HTTP
`Content-Disposition` header for potential filenames with special characters is
surprisingly confusing.

This ruby gem does that and only that, in a single 50-line file with no dependencies.
It's code is shamelessly extracted and adapted from Rails'
`ActionDispatch::HTTP::ContentDisposition` class.

## Content-Disposition header

Before we proceed with the usage guide, first a bit of explanation what is the
`Content-Disposition` header. The `Content-Disposition` response header
specifies the behaviour of the web browser when opening a URL.

The `inline` disposition will display the content "inline", which means that
known MIME types from the `Content-Type` response header are displayed inside
the browser, while unknown MIME types will be immediately downloaded.

```http
Content-Disposition: inline
```

The `attachment` disposition will tell the browser to always download the
content, regardless of the MIME type.

```http
Content-Disposition: attachment
```

When the content is downloaded, by default the filename will be last URL
segment. This can be changed via the `filename` parameter:

```http
Content-Disposition: attachment; filename="image.jpg"
```

To support old browsers, the `filename` should be the ASCII version of the
filename, while the `filename*` parameter can be used for the full filename
with any potential UTF-8 characters. Special characters from the filename need
to be URL-encoded in both parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "content_disposition", "~> 1.0"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install content_disposition
```

## Usage

```ruby
require "content_disposition"

ContentDisposition.format(disposition: "inline", filename: "racecar.jpg")
# => "inline; filename=\"racecar.jpg\"; filename*=UTF-8''racecar.jpg"
```

A proper content-disposition value for non-ascii filenames has a pure-ascii
as well as an ascii component. By default the filename will be turned into ascii
by replacing any non-ascii chars with `'?'` (which is then properly
percent-escaped to `%3F` in output).

```ruby
ContentDisposition.format(disposition: "attachment", filename: "råcëçâr.jpg")
# => "attachment; filename=\"r%3Fc%3F%3F%3Fr.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

But you can pass in your own proc to do it however you want. If you have a
dependency on the i18n gem, and want to do it just like Rails:

```ruby
ContentDisposition.format(
  disposition: "attachment",
  filename: "råcëçâr.jpg",
  to_ascii: ->(filename) { I18n.transliterate(filename) }
)
# => "attachment; filename=\"racecar.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

You can also configure `.to_ascii` globally for any invocation:

```ruby
ContentDisposition.to_ascii = ->(filename) { I18n.transliterate(filename) }
```

The `.format` method is aliased to `.call`, so you can do:

```ruby
ContentDisposition.(disposition: "inline", filename: "råcëçâr.jpg")
# => "inline; filename=\"r%3Fc%3F%3F%3Fr.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

There are also `.attachment` and `.inline` shorthands:

```ruby
ContentDisposition.attachment("racecar.jpg")
# => "attachment; filename=\"racecar.jpg\"; filename*=UTF-8''racecar.jpg"
ContentDisposition.inline("racecar.jpg")
# => "inline; filename=\"racecar.jpg\"; filename*=UTF-8''racecar.jpg"
```

You can also create a `ContentDisposition` instance to build your own
`Content-Disposition` header.

```ruby
content_disposition = ContentDisposition.new(
  disposition: "attachment",
  filename:    "råcëçâr.jpg",
)

content_disposition.disposition
# => "attachment"
content_disposition.filename
# => "råcëçâr.jpg"

content_disposition.ascii_filename
# => "filename=\"r%3Fc%3F%3F%3Fr.jpg\""
content_disposition.utf8_filename
# => "filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"

content_disposition.to_s
# => "attachment; filename=\"r%3Fc%3F%3F%3Fr.jpg\"; filename*=UTF-8''r%C3%A5c%C3%AB%C3%A7%C3%A2r.jpg"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/shrinerb/content_disposition.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
