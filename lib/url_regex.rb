require 'url_regex/version'

module UrlRegex
  def self.get(scheme_required: true, mode: :validation)
    raise ArgumentError, "wrong mode: #{mode}" if MODES.index(mode).nil?
    scheme = scheme_required ? PROTOCOL_IDENTIFIER : PROTOCOL_IDENTIFIER_OPTIONAL
    mode == :validation ? /\A#{scheme} #{BASE}\z/xi : /#{scheme} #{BASE}/xi
  end

  BASE = '
    # user:pass authentication
    (?:\S+(?::\S*)?@)?

    (?:
      # IP address exclusion
      # private & local networks
      (?!(?:10|127)(?:\.\d{1,3}){3})
      (?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})
      (?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})
      # IP address dotted notation octets
      # excludes loopback network 0.0.0.0
      # excludes reserved space >= 224.0.0.0
      # excludes network & broadcast addresses
      # (first & last IP address of each class)
      (?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])
      (?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}
      (?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))
      |
      # host name
      (?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)
      # domain name
      (?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*
      # TLD identifier
      (?:\.(?:[a-z\u00a1-\uffff]{2,}))
      # TLD may end with dot
      \.?
    )

    # port number
    (?::\d{2,5})?

    # resource path
    (?:[/?#]\S*)?
  '.freeze

  PROTOCOL_IDENTIFIER = '(?:(?:https?|ftp)://)'.freeze
  PROTOCOL_IDENTIFIER_OPTIONAL = '(?:(?:https?|ftp)://)?'.freeze
  MODES = [:validation, :parsing].freeze

  private_constant :BASE, :PROTOCOL_IDENTIFIER, :PROTOCOL_IDENTIFIER_OPTIONAL, :MODES
end
