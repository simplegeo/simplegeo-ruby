module SimpleGeo

  class Endpoint

    class << self
      
      def feature(id)
        endpoint_url "features/#{id}.json", '1.0'
      end
      
      def get_layers()
        endpoint_url "layers.json", '0.1'
      end
      
      def get_layer_info(layer)
        endpoint_url "layers/#{layer}.json", '0.1'
      end
      
      def record(layer, id)
        endpoint_url "records/#{layer}/#{id}.json", '0.1'
      end

      def records(layer, ids)
         ids = ids.join(',')  if ids.is_a? Array
         endpoint_url "records/#{layer}/#{ids}.json", '0.1'
      end

      def add_records(layer)
        endpoint_url "records/#{layer}.json", '0.1'
      end

      def history(layer, id)
        endpoint_url "records/#{layer}/#{id}/history.json", '0.1'
      end

      def nearby_geohash(layer, geohash)
        endpoint_url "records/#{layer}/nearby/#{geohash}.json", '0.1'
      end

      def nearby_address(layer, address)
        endpoint_url "records/#{layer}/nearby/address.json?address=#{address}", '0.1'
      end

      def nearby_coordinates(layer, lat, lon)
        endpoint_url "records/#{layer}/nearby/#{lat},#{lon}.json", '0.1'
      end

      def nearby_ip_address(layer, ip)
        endpoint_url "records/#{layer}/nearby/#{ip}.json", '0.1'
      end

      def context(lat, lon, filter)
        if filter
          endpoint_url "context/#{lat},#{lon}.json?filter=#{filter}", '1.0'
        else
          endpoint_url "context/#{lat},#{lon}.json", '1.0'
        end
      end
      
      def context_by_address(address, filter)
        if defined?(filter)
          endpoint_url "context/address.json?address=#{address}&filter=#{filter}", '1.0'
        else
          endpoint_url "context/address.json?address=#{address}", '1.0'
        end
      end
      
      def context_ip(ip, filter)
        if defined?(filter)
          endpoint_url "context/#{ip}.json?filter=#{filter}", '1.0'
        else
          endpoint_url "context/#{ip}.json", '1.0'
        end
      end

      def geocode_from_ip(ip)
        endpoint_url "context/#{ip}.json?filter=query", '1.0'
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

      def endpoint_url(path, version)
        [REALM, version, path].join('/')
      end
    end

  end

end
