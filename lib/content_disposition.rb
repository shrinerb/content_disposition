# frozen_string_literal: true

require "content_disposition/version"

class ContentDisposition
  DEFAULT_TO_ASCII = ->(str) { str.encode("US-ASCII", undef: :replace, replace: "?") }

  def self.format(disposition:, filename:, to_ascii: DEFAULT_TO_ASCII)
    new(disposition: disposition, filename: filename, to_ascii: to_ascii).to_s
  end

  def self.attachment(filename = nil)
    format(disposition: "attachment", filename: filename)
  end

  def self.inline(filename = nil)
    format(disposition: "inline", filename: filename)
  end

  attr_reader :disposition, :filename, :to_ascii

  def initialize(disposition:, filename:, to_ascii: DEFAULT_TO_ASCII)
    @disposition = disposition
    @filename = filename
    @to_ascii = to_ascii
  end

  TRADITIONAL_ESCAPED_CHAR = /[^ A-Za-z0-9!#$+.^_`|~-]/

  def ascii_filename
    'filename="' + percent_escape(to_ascii.call(filename), TRADITIONAL_ESCAPED_CHAR) + '"'
  end

  RFC_5987_ESCAPED_CHAR = /[^A-Za-z0-9!#$&+.^_`|~-]/

  def utf8_filename
    "filename*=UTF-8''" + percent_escape(filename, RFC_5987_ESCAPED_CHAR)
  end

  def to_s
    if filename
      "#{disposition}; #{ascii_filename}; #{utf8_filename}"
    else
      "#{disposition}"
    end
  end

  private

    def percent_escape(string, pattern)
      string.gsub(pattern) do |char|
        char.bytes.map { |byte| "%%%02X" % byte }.join
      end
    end
end

