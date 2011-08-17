require 'uri'
require 'json'
require 'oauth'

require 'simple_geo/hash_utils'
require 'simple_geo/connection'
require 'simple_geo/endpoint'
require 'simple_geo/client'
require 'simple_geo/record'
require 'simple_geo/version'

module SimpleGeo
  REALM = "http://api.simplegeo.com"

  class SimpleGeoError < StandardError; end
  class Unauthorized < SimpleGeoError; end
  class NotFound < SimpleGeoError; end
  class ServerError < SimpleGeoError; end
  class Unavailable < SimpleGeoError; end
  class DecodeError < SimpleGeoError; end
  class NoConnectionEstablished < SimpleGeoError; end
end
