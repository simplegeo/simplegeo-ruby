require 'uri'
require 'json'
require 'oauth'
require 'cgi'


require 'core_ext/object'

module SimpleGeo
  REALM   = "http://api.simplegeo.com"
  VERSION = File.read(File.join(File.dirname(__FILE__), '..', 'VERSION'))

  class SimpleGeoError          < StandardError;  end
  class Unauthorized            < SimpleGeoError; end
  class NotFound                < SimpleGeoError; end
  class ServerError             < SimpleGeoError; end
  class Unavailable             < SimpleGeoError; end
  class DecodeError             < SimpleGeoError; end
  class NoConnectionEstablished < SimpleGeoError; end
  
  
  # LazyLoaded
  autoload  :HashUtils,   'simple_geo/hash_utils'
  autoload  :Connection,  'simple_geo/connection'
  autoload  :Endpoint,    'simple_geo/endpoint'
  autoload  :Client,      'simple_geo/client'
  autoload  :Record,      'simple_geo/record'
  
end
