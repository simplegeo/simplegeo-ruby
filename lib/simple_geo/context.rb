module SimpleGeo
  class Context
    def initialize(context)
      @context = context
    end
    
    def country 
      national_category = lambda { |feature|
        false unless feature.has_key? :classifiers
        true if feature[:classifiers].find{ |classifier| classifier[:category] == 'National' }
      }
      @context[:features].find(&national_category)[:name]
    end
  end
end
