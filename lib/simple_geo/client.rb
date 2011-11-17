module SimpleGeo

  class Client

    @@connection = nil
    @@debug = false

    class << self

      def get_feature(id)
        record_hash = get Endpoint.feature(id)
        Record.parse_geojson_hash(record_hash)
      end

      # If you don't supply your credentials, we assume they're set in the environment.
      # Using the environment variables is how you would use the client on Heroku, for example.
      def set_credentials(token=nil, secret=nil)
        token, secret = check_credentials(token, secret)
        @@connection = Connection.new(token, secret)
        @@connection.debug = @@debug
      end

      def check_credentials(token, secret)
        if (token.nil? and secret.nil?)
          token  = ENV['SIMPLEGEO_KEY']
          secret = ENV['SIMPLEGEO_SECRET']
        end
        return token, secret
      end

      def debug=(debug_flag)
        @@debug = debug_flag
        @@connection.debug = @@debug  if @@connection
      end

      def debug
        @@debug
      end

      def get_layers()
          geojson_hash = get Endpoint.get_layers()
          HashUtils.recursively_symbolize_keys geojson_hash
      end

      def get_layer_info(layer)
          geojson_hash = get Endpoint.get_layer_info(layer)
          HashUtils.recursively_symbolize_keys geojson_hash
      end

      def add_record(record)
        raise SimpleGeoError, "Record has no layer"  if record.layer.nil?
        put Endpoint.record(record.layer, record.id), record
      end

      def delete_record(layer, id)
        delete Endpoint.record(layer, id)
      end

      def get_record(layer, id)
        record_hash = get Endpoint.record(layer, id)
        record = Record.parse_geojson_hash(record_hash)
        record.layer = layer
        record
      end

      def add_records(layer, records)
        features = {
          :type => 'FeatureCollection',
          :features => records.collect { |record| record.to_hash }
        }
        post Endpoint.add_records(layer), features
      end

      # This request currently generates a 500 error if an unknown id is passed in.
      def get_records(layer, ids)
        features_hash = get Endpoint.records(layer, ids)
        records = []
        features_hash['features'].each do |feature_hash|
          record = Record.parse_geojson_hash(feature_hash)
          record.layer = layer
          records << record
        end
        records
      end

      def get_history(layer, id)
        history_geojson = get Endpoint.history(layer, id)
        history = []
        history_geojson['geometries'].each do |point|
          history << {
            :created => Time.at(point['created']),
            :lat => point['coordinates'][1],
            :lon => point['coordinates'][0]
          }
        end
        history
      end

      def get_nearby_records(layer, options)
        if options[:geohash]
          endpoint = Endpoint.nearby_geohash(layer, options.delete(:geohash))
        elsif options[:ip]
          endpoint = Endpoint.nearby_ip_address(layer, options.delete(:ip))
        elsif options[:lat] && options[:lon]
          endpoint = Endpoint.nearby_coordinates(layer,
            options.delete(:lat), options.delete(:lon))
        else
          raise SimpleGeoError, "Either geohash or lat and lon is required"
        end

        options = nil  if options.empty?
        features_hash = get(endpoint, options)
        nearby_records = {
          :next_cursor => features_hash['next_cursor'],
          :records => []
        }
        features_hash['features'].each do |feature_hash|
          record = Record.parse_geojson_hash(feature_hash)
          record.layer = layer
          record_info = {
            :distance => feature_hash['distance'],
            :record => record
          }
          nearby_records[:records] << record_info
        end
        nearby_records
      end

      def get_context(lat, lon, filter=nil)
        geojson_hash = get Endpoint.context(lat, lon, filter)
        HashUtils.recursively_symbolize_keys geojson_hash
      end
      
      def get_context_by_address(address, filter=nil)
        address = URI.escape(address, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        geojson_hash = get Endpoint.context_by_address(address, filter)
        HashUtils.recursively_symbolize_keys geojson_hash
      end
      
      def get_context_ip(ip, filter=nil)
        geojson_hash = get Endpoint.context_ip(ip, filter)
        HashUtils.recursively_symbolize_keys geojson_hash
      end
      
      def geocode_from_ip(ip="ip")
        geojson_hash = get Endpoint.geocode_from_ip(ip)
        HashUtils.recursively_symbolize_keys geojson_hash
      end
      
      # Required
      #   lat - The latitude of the point
      #   lon - The longitude of the point
      # 
      # Optional
      #   q - A search term. For example, q=Starbucks would return all places matching the name Starbucks.
      #   category - Filter by an exact classifier (types, categories, subcategories, tags)
      #   radius - Search by radius in kilometers. Default radius is 25km.
      # 
      # If you provide only a q parameter it does a full-text search
      # of the name and classifiers of a place. If you provide only the category parameter 
      # it does a full-text search of all classifiers. If you provide q and category, 
      # q is a full-text search of place names and category is an exact match
      # to one or more of the classifiers. 
      def get_places(lat, lon, options={})
        options[:category] = category_query_string(options[:category]) unless options[:category].nil?
        geojson_hash = get Endpoint.places(lat, lon, options)
        HashUtils.recursively_symbolize_keys geojson_hash
      end

      def get_places_by_address(address, options={})
        address = URI.escape(address, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        options[:category] = category_query_string(options[:category]) unless options[:category].nil?
        geojson_hash = get Endpoint.places_by_address(address, options)
        HashUtils.recursively_symbolize_keys geojson_hash
      end

      def get_places_by_ip(ip='ip', options={})
        options[:category] = category_query_string(options[:category]) unless options[:category].nil?
        geojson_hash = get Endpoint.places_by_ip(ip, options)
        HashUtils.recursively_symbolize_keys geojson_hash
      end

      def get(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.get endpoint, data
      end

      def delete(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.delete endpoint, data
      end

      def post(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.post endpoint, data
      end

      def put(endpoint, data=nil)
        raise NoConnectionEstablished  if @@connection.nil?
        @@connection.put endpoint, data
      end
      
      def category_query_string(list)
        Array(list).map{|cat| URI.escape(cat, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) }.join('&category=')
      end
    end

  end

end
