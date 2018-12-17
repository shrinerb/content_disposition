# frozen_string_literal: true

require "content_disposition/version"

class ContentDisposition
  ATTACHMENT = "attachment"
  INLINE     = "inline"

  DEFAULT_TO_ASCII = -> (string) do
    string.encode("US-ASCII", undef: :replace, replace: "?")
  end

  def self.format(disposition:, filename:, to_ascii: DEFAULT_TO_ASCII)
    new(disposition: disposition, filename: filename, to_ascii: to_ascii).to_s
  end

  def self.call(*args)
    format(*args)
  end

  def self.attachment(filename = nil)
    format(disposition: ATTACHMENT, filename: filename)
  end

  def self.inline(filename = nil)
    format(disposition: INLINE, filename: filename)
  end

  attr_reader :disposition, :filename, :to_ascii

  def initialize(disposition:, filename:, to_ascii: DEFAULT_TO_ASCII)
    unless [ATTACHMENT, INLINE].include?(disposition.to_s)
      fail ArgumentError, "unknown disposition: #{disposition.inspect}"
    end

    @disposition = disposition
    @filename = filename
    @to_ascii = to_ascii
  end

  def to_s
    if filename
      "#{disposition}; #{ascii_filename}; #{utf8_filename}"
    else
      "#{disposition}"
    end
  end

  TRADITIONAL_ESCAPED_CHAR = /[^ A-Za-z0-9!#$+.^_`|~-]/

  def ascii_filename
    'filename="' + percent_escape(to_ascii.call(filename), TRADITIONAL_ESCAPED_CHAR) + '"'
  end

  RFC_5987_ESCAPED_CHAR = /[^A-Za-z0-9!#$&+.^_`|~-]/

  def utf8_filename
    "filename*=UTF-8''" + percent_escape(filename, RFC_5987_ESCAPED_CHAR)
  end

  private

  def percent_escape(string, pattern)
    string.gsub(pattern) do |char|
      char.bytes.map { |byte| "%%%02X" % byte }.join
    end
  end
end
