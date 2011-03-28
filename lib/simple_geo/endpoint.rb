module SimpleGeo

  class Endpoint

    class << self
      
      def feature(id)
        endpoint_url "features/#{id}.json"
      end
      
      def get_layers()
        endpoint_url "layers.json", '0.1'
      end
      
      def get_layer_info(layer)
        endpoint_url "layers/#{layer}.json", '0.1'
      end
      
      def record(layer, id)
        endpoint_url "records/#{layer}/#{id}.json"
      end

      def records(layer, ids)
         ids = ids.join(',')  if ids.is_a? Array
         endpoint_url "records/#{layer}/#{ids}.json"
      end

      def add_records(layer)
        endpoint_url "records/#{layer}.json"
      end

      def history(layer, id)
        endpoint_url "records/#{layer}/#{id}/history.json"
      end

      def nearby_geohash(layer, geohash)
        endpoint_url "records/#{layer}/nearby/#{geohash}.json"
      end

      def nearby_coordinates(layer, lat, lon)
        endpoint_url "records/#{layer}/nearby/#{lat},#{lon}.json"
      end

      def nearby_ip_address(layer, ip)
        endpoint_url "records/#{layer}/nearby/#{ip}.json"
      end

      def nearby_address(lat, lon)
        endpoint_url "nearby/address/#{lat},#{lon}.json"
      end
      
      def context(lat, lon)
        endpoint_url "context/#{lat},#{lon}.json", '1.0'
      end
      
      def context_by_address(address)
        endpoint_url "context/address.json?address=#{address}", '1.0'
      end
      
      def context_ip(ip)
        endpoint_url "context/#{ip}.json", '1.0'
      end
      
      def places(lat, lon, options)
        if options.empty?
          endpoint_url "places/#{lat},#{lon}.json", '1.0'
        else
          params = []
          options.each do |k,v|
            params << "#{k}=#{v}"
          end
          endpoint_url "places/#{lat},#{lon}.json?#{params.join("&")}", '1.0'
        end
      end

      def places_by_address(address, options)
        if options.empty?
          endpoint_url "places/address.json?address=#{address}", '1.0'
        else
          params = [] 
          params << "address=#{address}"
          options.each do |k,v|
            params << "#{k}=#{v}"
          end
          endpoint_url "places/address.json?#{params.join("&")}", '1.0'
        end
      end

      def places_by_ip(ip, options)
        if options.empty?
          endpoint_url "places/#{ip}.json", '1.0'
        else
          params = []
          options.each do |k,v|
            params << "#{k}=#{v}"
          end
          endpoint_url "places/#{ip}.json?#{params.join("&")}", '1.0'
        end
      end

      def density(lat, lon, day, hour=nil)
        if hour.nil?
          path = "density/#{day}/#{lat},#{lon}.json"
        else
          path = "density/#{day}/#{hour}/#{lat},#{lon}.json"
        end
        endpoint_url path
      end

      def contains(lat, lon)
        endpoint_url "contains/#{lat},#{lon}.json"
      end

      def contains_ip_address(ip)
        endpoint_url "contains/#{ip}.json"
      end

      def overlaps(south, west, north, east)
        endpoint_url "overlaps/#{south},#{west},#{north},#{east}.json"
      end

      def boundary(id)
        endpoint_url "boundary/#{id}.json"
      end

      def endpoint_url(path, version = API_VERSION)
        [REALM, version, path].join('/')
      end
    end

  end

end
