require 'url_regex/version'

# Provides the best known regex for validating and extracting URLs.
# It uses amazing job done by [Diego Perini](https://gist.github.com/dperini/729294)
# and [Mathias Bynens](https://mathiasbynens.be/demo/url-regex).
module UrlRegex
  # Returns the regex for URLs parsing or validating.
  #
  # @param scheme_required [Boolean] will the regex require scheme presence, defaults to true
  # @param mode [Symbol] purpose of the regex, `:validation` or `parsing`, defaults to `:validation`
  # @return [Regex] regex for parsing or validating
  def self.get(scheme_required: true, mode: :validation)
    raise ArgumentError, "wrong mode: #{mode}" if MODES.index(mode).nil?

    scheme = scheme_required ? PROTOCOL_IDENTIFIER : PROTOCOL_IDENTIFIER_OPTIONAL

    case mode
    when :validation
      /\A#{scheme} #{BASE}\z/xi
    when :parsing
      /#{scheme} #{BASE}/xi
    when :javascript
      /^#{scheme}#{JAVASCRIPT_BASE}$/
    end
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
    (?:\.(?:[0-9]\d?|1\d\d|2[0-4]\d|25[0-5]))
    |

    # Taken from https://gist.github.com/syzdek/6086792
    ([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|
    ([0-9a-fA-F]{1,4}:){1,7}:|
    ([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|
    ([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|
    ([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|
    ([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|
    ([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|
    [0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|
    :((:[0-9a-fA-F]{1,4}){1,7}|:)|
    fe08:(:[0-9a-fA-F]{1,4}){2,2}%[0-9a-zA-Z]{1,}|
    ::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|
    ([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])

    |
    # host name
    (?:(?:[a-z\u00a1-\uffff0-9][-_]*)*[a-z\u00a1-\uffff0-9]+)
    # domain name
    (?:\.(?:[a-z\u00a1-\uffff0-9][-_]*)*[a-z\u00a1-\uffff0-9]+)*
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

  JAVASCRIPT_BASE = '
    (?:\S+(?::\S*)?@)?
    (?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})
    (?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])
    (?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|
    (?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*
    (?:\.(?:[a-z\u00a1-\uffff]{2,}))\.?)(?::\d{2,5})?(?:[/?#]\S*)?'.gsub(/\s+/, '').freeze

  PROTOCOL_IDENTIFIER = '(?:(?:https?|ftp)://)'.freeze
  PROTOCOL_IDENTIFIER_OPTIONAL = '(?:(?:https?|ftp)://)?'.freeze
  MODES = [:validation, :parsing, :javascript].freeze

  private_constant :BASE, :PROTOCOL_IDENTIFIER, :PROTOCOL_IDENTIFIER_OPTIONAL, :MODES
end
