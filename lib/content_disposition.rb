# frozen_string_literal: true

require "content_disposition/version"

class ContentDisposition
  ATTACHMENT = "attachment"
  INLINE     = "inline"

  DEFAULT_TO_ASCII = ->(filename) do
    filename.encode("US-ASCII", undef: :replace, replace: "?")
  end

  class << self
    def attachment(filename = nil)
      format(disposition: ATTACHMENT, filename: filename)
    end

    def inline(filename = nil)
      format(disposition: INLINE, filename: filename)
    end

    def format(**options)
      new(**options).to_s
    end
    alias call format

    attr_accessor :to_ascii
  end

  attr_reader :disposition, :filename, :to_ascii

  def initialize(disposition:, filename:, to_ascii: nil)
    unless [ATTACHMENT, INLINE].include?(disposition.to_s)
      fail ArgumentError, "unknown disposition: #{disposition.inspect}"
    end

    @disposition = disposition
    @filename    = filename
    @to_ascii    = to_ascii || self.class.to_ascii || DEFAULT_TO_ASCII
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
    'filename="' + percent_escape(to_ascii[filename], TRADITIONAL_ESCAPED_CHAR) + '"'
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
