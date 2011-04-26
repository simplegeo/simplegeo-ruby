require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  before do
    SimpleGeo::Client.set_credentials 'token', 'secret'
  end

  context "getting a record" do
    context "with an id for an existing record" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/5373629.json',
          :fixture_file => 'get_record.json'
      end

      it "should return a single record with the correct attributes" do
        record = SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 5373629)
        record.class.should == SimpleGeo::Record
        record.id.should == '5373629'
        record.type.should == 'place'
        record.layer.should == 'com.simplegeo.global.geonames'
        record.lat.should == 37.759650000000001
        record.lon.should == -122.42608
        record.properties.should == {
          :layer => "com.simplegeo.global.geonames",
          :elevation => "22",
          :gtopo30 => "60",
          :feature_code => "PRK",
          :last_modified => "2006-01-15",
          :country_code => "US",
          :alternatenames => "",
          :timezone => "America/Los_Angeles",
          :population => "0",
          :name => "Mission Dolores Park",
          :feature_class => "L",
          :cc2 => "",
          :admin1 => "CA",
          :admin3 => "",
          :admin2 => "075",
          :admin4 => "",
          :asciiname => "Mission Dolores Park"
        }
      end
    end

    context "with an id for a nonexistant record" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/foo.json',
          :fixture_file => 'no_such_record.json', :status => 404
      end

      it "should raise a NotFound exception" do
        lambda {
          SimpleGeo::Client.get_record('com.simplegeo.global.geonames', 'foo')
        }.should raise_exception(SimpleGeo::NotFound)
      end
    end
  end

  #TODO: verify request data contains correct record data
  context "adding/updating a record" do
    before do
      stub_request :put,
        'http://api.simplegeo.com/1.0/records/io.path.testlayer/1234.json',
        :status => 202
    end

    it "should create or update the record" do
      lambda {
        record = SimpleGeo::Record.new({
          :id => '1234',
          :created => Time.at(1269832510),
          :lat => 37.759650000000001,
          :lon => -122.42608,
          :layer => 'io.path.testlayer',
          :properties => {
            :test_property => 'foobar'
          }
        })
        SimpleGeo::Client.add_record(record)
      }.should_not raise_exception
    end
  end

  context "deleting a record" do
    before do
      stub_request :delete,
        'http://api.simplegeo.com/1.0/records/io.path.testlayer/1234.json',
        :status => 202
    end

    it "should delete the record" do
      lambda {
        SimpleGeo::Client.delete_record('io.path.testlayer', '1234')
      }.should_not raise_exception
    end
  end

  context "getting multiple records" do
    context "with ids for two existing records" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.us.business/41531696,41530629.json',
          :fixture_file => 'get_records.json'
      end

      it "should return an array of records with the correct attributes" do
        records = SimpleGeo::Client.get_records('com.simplegeo.us.business', ['41531696', '41530629'])
        records.size.should == 2
        records[0].id.should == '41530629'
        records[0].type.should == 'place'
        records[0].layer.should == 'com.simplegeo.us.business'
        records[0].lat.should == 37.760350000000003
        records[0].lon.should == -122.419043
        records[0].properties.should == {
          :state => "CA",
          :census_block_group => "2",
          :street_type => "St",
          :city => "San Francisco",
          :census_block_id => "002",
          :plus4 => "1811",
          :cbsa => "41860",
          :time_zone => "4",
          :censustract => "020800",
          :pubdate => "2009-12-01",
          :std_name => "Beauty Bar",
          :phone_number => "0323",
          :state_fips => "06",
          :company_sics => [
            {
              :sic => "72310000",
              :industry_class => "7",
              :relevancy => "1",
              :naics_description => "BEAUTY SALONS",
              :naics => "812112",
              :sic_4 => "7231",
              :description => "BEAUTY SHOPS",
              :sic_4_description => "BEAUTY SHOPS"
            },
            {
              :sic => "58130101",
              :industry_class => "5",
              :relevancy => "2",
              :naics_description => "DRINKING PLACES (ALCOHOLIC BEVERAGES)",
              :naics => "72241",
              :sic_4 => "5813",
              :description => "BAR (DRINKING PLACES)",
              :sic_4_description => "DRINKING PLACES"
            },
            {
              :sic => "58120310",
              :industry_class => "5",
              :relevancy => "3",
              :naics_description => "LIMITED-SERVICE RESTAURANTS",
              :naics => "722211",
              :sic_4 => "5812",
              :description => "GRILLS, ( EATING PLACES)",
              :sic_4_description => "EATING PLACES"
            }
          ],
          :dpv_confirm => "Y",
          :zip => "94110",
          :dpc => "996",
          :street_name => "Mission",
          :carrier_route => "C036",
          :area_code => "415",
          :company_headings => [
            {
              :category_name => "Bars, Taverns & Cocktail Lounges",
              :condensed_name => "BARS GRILLS & PUBS",
              :normalized_id => "138001000",
              :category_id => "138000000",
              :normalized_name => "BARS GRILLS & PUBS",
              :condensed_id => "138001000"
            }
          ],
          :mlsc => "4",
          :val_date => "2010-03-22",
          :confidence_score => "100",
          :exppubcity => "San Francisco",
          :housenumber => "2299",
          :z4_type => "S",
          :exchange => "285",
          :business_name => "Beauty Bar",
          :county_fips => "075",
          :ll_match_level => "R",
          :dso => "1",
          :company_phones => [
            {
              :val_flag => "C",
              :val_date => "2010-03-22",
              :phone_type => "P",
              :dnc => "",
              :exchange => "285",
              :phone_number => "0323",
              :areacode => "415"
            }
          ],
          :msa => "7360",
          :val_flag => "C"
        }
        records[1].id.should == '41531696'
        records[1].type.should == 'place'
        records[1].layer.should == 'com.simplegeo.us.business'
        records[1].lat.should == 37.755470000000003
        records[1].lon.should == -122.420646
        records[1].properties.should == {
          :carrier_route => "C010",
          :pubdate => "2009-12-01",
          :ll_match_level => "R",
          :street_name => "22nd",
          :std_name => "Latin American Club",
          :val_flag => "C",
          :census_block_id => "004",
          :company_headings => [
            {
              :normalized_id => "138004000",
              :condensed_name => "NIGHT CLUBS",
              :condensed_id => "138004000",
              :normalized_name => "NIGHT CLUBS",
              :category_id => "138000000",
              :category_name => "Bars, Taverns & Cocktail Lounges"
            }
          ],
          :company_sics => [
            {
              :sic_4 => "5813",
              :relevancy => "1",
              :description => "NIGHT CLUBS",
              :naics => "72241",
              :sic => "58130200",
              :industry_class => "5",
              :sic_4_description => "DRINKING PLACES",
              :naics_description => "DRINKING PLACES (ALCOHOLIC BEVERAGES)"
            }
          ],
          :city => "San Francisco",
          :county_fips => "075",
          :zip => "94110",
          :mlsc => "4",
          :dso => "1",
          :state => "CA",
          :dpv_confirm => "Y",
          :housenumber => "3286",
          :msa => "7360",
          :phone_number => "2732",
          :exchange => "647",
          :area_code => "415",
          :censustract => "020800",
          :state_fips => "06",
          :street_type => "St",
          :business_name => "Latin American Club",
          :plus4 => "3033",
          :val_date => "2010-03-22",
          :dnc => "T",
          :confidence_score => "100",
          :time_zone => "4",
          :cbsa => "41860",
          :dpc => "862",
          :company_phones => [
            {
              :phone_number => "2732",
              :phone_type => "P",
              :val_date => "2010-03-22",
              :dnc => "T",
              :exchange => "647",
              :areacode => "415",
              :val_flag => "C"
            }
          ],
          :census_block_group => "4",
          :z4_type => "S"
        }
      end
    end

    context "with ids for nonexistant records" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/foo,bar.json',
          :fixture_file => 'nonetype_not_iterable.json', :status => 500
      end

      it "should raise a NotFound exception" do
        lambda {
          SimpleGeo::Client.get_records('com.simplegeo.global.geonames', ['foo', 'bar'])
        }.should raise_exception(SimpleGeo::ServerError)
      end
    end
  end

  context "adding multiple records" do
    before do
      stub_request :post,
        'http://api.simplegeo.com/1.0/records/io.path.testlayer.json',
        :status => 202
    end

    it "should create or update the record" do
      layer = 'io.path.testlayer'
      lambda {
        records = [
          SimpleGeo::Record.new({
            :id => '1234',
            :created => Time.at(1269832510),
            :lat => 37.759650000000001,
            :lon => -122.42608,
            :layer => layer,
            :properties => {
              :test_property => 'foobar'
            }
          }),
          SimpleGeo::Record.new({
            :id => '5678',
            :created => Time.at(1269832510),
            :lat => 37.755470000000003,
            :lon => -122.420646,
            :layer => layer,
            :properties => {
              :mad_prop => 'baz'
            }
          })
        ]
        SimpleGeo::Client.add_records(layer, records)
      }.should_not raise_exception
    end
  end

  context "getting a record's history" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/5373629/history.json',
        :fixture_file => 'get_history.json'
    end

    it "should create or update the record" do
      history = SimpleGeo::Client.get_history('com.simplegeo.global.geonames', '5373629')
      history.should == [
        {
          :created => Time.at(1269832510),
          :lat => 37.759650000000001,
          :lon => -122.42608
        }
      ]
    end
  end

  context "getting nearby records" do
    before do
      @expected_records = {
        :next_cursor => "QVSEifz7gri4J0w8FSQJ06Z5S5lOw6gZ75Co-fBbBQJEr7XMqN32bjMKNc9kwLKqKyqtVvxR_t5hgWW6XDgPnPTY",
        :records => [
          {
            :distance => 0,
            :record => SimpleGeo::Record.new(
              :id => "5373629",
              :lon => -122.42608,
              :lat => 37.75965,
              :type => "place",
              :layer => "com.simplegeo.global.geonames",
              :created => Time.at(1269832510),
              :properties => {
                :admin4 => "",
                :feature_code => "PRK",
                :feature_class => "L",
                :last_modified => "2006-01-15",
                :asciiname => "Mission Dolores Park",
                :cc2 => "",
                :country_code => "US",
                :admin1 => "CA",
                :alternatenames => "",
                :admin3 => "",
                :elevation => "22",
                :layer => "com.simplegeo.global.geonames",
                :timezone => "America/Los_Angeles",
                :name => "Mission Dolores Park",
                :gtopo30 => "60",
                :admin2 => "075",
                :population => "0"
              }
            )
          },
          {
            :distance => 57.557068918956581,
            :record => SimpleGeo::Record.new(
              :id => "5352852",
              :lon => -122.42553,
              :lat => 37.75937,
              :type => "place",
              :layer => "com.simplegeo.global.geonames",
              :created => Time.at(1269832039),
              :properties => {
                :admin4 => "",
                :feature_code => "CH",
                :feature_class => "S",
                :last_modified => "2006-01-15",
                :asciiname => "Golden Gate Lutheran Church",
                :cc2 => "",
                :country_code => "US",
                :admin1 => "CA",
                :alternatenames => "",
                :admin3 => "",
                :elevation => "23",
                :layer => "com.simplegeo.global.geonames",
                :timezone => "America/Los_Angeles",
                :name=> "Golden Gate Lutheran Church",
                :gtopo30 => "60",
                :admin2 => "075",
                :population => "0"
              }
            )
          }
        ]
      }
    end

    context "by lat and lon" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/nearby/37.75965,-122.42608.json',
          :fixture_file => 'get_nearby.json'
      end

      it "should return a hash of nearby records" do
        records = SimpleGeo::Client.get_nearby_records('com.simplegeo.global.geonames',
          :lat => 37.759650000000001,
          :lon => -122.42608)
        # records.should == @expected_records
      end
    end

    context "by geohash" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/nearby/9q8yy1ujcsfm.json',
          :fixture_file => 'get_nearby.json'
      end

      it "should return a hash of nearby records" do
        records = SimpleGeo::Client.get_nearby_records('com.simplegeo.global.geonames',
          :geohash => '9q8yy1ujcsfm')
        # records.should == @expected_records
      end
    end

    context "with no nearby records" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/records/com.simplegeo.global.geonames/nearby/37.75965,-122.42608.json',
          :fixture_file => 'empty_feature_collection.json'
      end

      it "should return a hash of nearby records" do
        records = SimpleGeo::Client.get_nearby_records('com.simplegeo.global.geonames',
          :lat => 37.759650000000001,
          :lon => -122.42608)
        records.should == { :next_cursor => nil, :records => [] }
      end
    end
  end
  
  context "getting a context" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/1.0/context/42.790311,-86.103725.json',
        :fixture_file => 'context.json'
    end

    it "should return a hash with the contextual information" do
      context_info = SimpleGeo::Client.get_context(42.790311,-86.103725)
      context_info.should == {:features=>[{:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_6uJ6wzViqnu1oYhZcDvC6W_42.834306_-85.959803", :subcategory=>"Provincial (Lower)", :bounds=>[-86.166987, 42.767498, -85.782106, 42.943294], :name=>"State House District 90", :category=>"Legislative District", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_6uJ6wzViqnu1oYhZcDvC6W_42.834306_-85.959803.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_4OIGBRyxTiWgCdg0Lyn07s_42.952959_-86.403728", :subcategory=>"Provincial (Upper)", :bounds=>[-87.107669, 42.765202, -85.670247, 43.205978], :name=>"State Senate District 30", :category=>"Legislative District", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_4OIGBRyxTiWgCdg0Lyn07s_42.952959_-86.403728.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_2CIOVMi7dzlPcX4McJ7R2f_42.948535_-86.421882", :subcategory=>"County", :bounds=>[-87.107669, 42.765202, -85.782067, 43.205978], :name=>"Ottawa", :category=>"Administrative", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_2CIOVMi7dzlPcX4McJ7R2f_42.948535_-86.421882.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_4c1GLzrQPs1lzMEwbXXDTG_44.209749_-85.174107", :subcategory=>"", :bounds=>[-89.876047, 41.695801, -82.407822, 48.23452], :name=>"America/Detroit", :category=>"Time Zone", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_4c1GLzrQPs1lzMEwbXXDTG_44.209749_-85.174107.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_4BTI2YCOHn2kKGheRPjEIA_42.740746_-86.087464", :subcategory=>"", :bounds=>[-86.211882, 42.681352, -85.901239, 42.803153], :name=>"49423", :category=>"Postal Code", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_4BTI2YCOHn2kKGheRPjEIA_42.740746_-86.087464.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_3uwSAEdXVBzK1ZER9Nqkdp_45.687160_-112.493107", :subcategory=>"", :bounds=>[-179.142471, 18.930138, 179.78115, 71.41218], :name=>"United States of America", :category=>"National", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_3uwSAEdXVBzK1ZER9Nqkdp_45.687160_-112.493107.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_7PF95202oeSi8UJfS8Du4L_44.874774_-85.730953", :subcategory=>"State", :bounds=>[-90.418392, 41.696118, -82.122971, 48.306063], :name=>"Michigan", :category=>"Subnational", :abbr=>"MI", :href=>"http://api.simplegeo.com/1.0/features/SG_7PF95202oeSi8UJfS8Du4L_44.874774_-85.730953.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_3ske3SdDp9Vzzr6M5GcNdz_42.772865_-86.121892", :subcategory=>"Unified", :bounds=>[-86.210248, 42.74334, -86.048046, 42.802685], :name=>"Holland City School District", :category=>"School District", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_3ske3SdDp9Vzzr6M5GcNdz_42.772865_-86.121892.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_4wefQyQRSx0qqC75Y4hoLl_42.767627_-86.098521", :subcategory=>"City", :bounds=>[-86.166987, 42.729342, -86.047025, 42.802532], :name=>"Holland", :category=>"Municipal", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_4wefQyQRSx0qqC75Y4hoLl_42.767627_-86.098521.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_0GfZAGyWb5a3aHQm1U7Nzw_42.792354_-86.110755", :subcategory=>"Municipal", :bounds=>[-86.125552, 42.783776, -86.09735, 42.803224], :name=>"1393864002002", :category=>"Legislative District", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_0GfZAGyWb5a3aHQm1U7Nzw_42.792354_-86.110755.json"}, {:type=>"Region", :license=>"http://creativecommons.org/publicdomain/mark/1.0/", :handle=>"SG_4Nw3IcoA88j0EvXHP6fneE_42.791087_-86.094830", :subcategory=>"Tract", :bounds=>[-86.111603, 42.783016, -86.080832, 42.80099], :name=>"26139022300", :category=>"US Census", :abbr=>"", :href=>"http://api.simplegeo.com/1.0/features/SG_4Nw3IcoA88j0EvXHP6fneE_42.791087_-86.094830.json"}], :timestamp=>1291928637.193, :query=>{:latitude=>42.790311, :longitude=>-86.103725}}
    end
  end
  
  context "search for nearby places" do
    context "without optional params" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/places/42.790311,-86.103725.json',
          :fixture_file => 'places.json'
      end

      it "should return a hash with the places nearby" do
        nearby_places = SimpleGeo::Client.get_places(42.790311, -86.103725)
        nearby_places.should == {:type=>"FeatureCollection", :total=>25, :features=>[{:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"84 E 8th St", :phone=>"+1 616 396 8484", :country=>"US", :name=>"84 East", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103744, 42.790269]}, :id=>"SG_57YZu0CVFGKQnIulntuuWr_42.790269_-86.103744@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Entertainment", :category=>"Cinema", :subcategory=>"Movie Theater"}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"86 E 8th St", :phone=>"+1 616 395 7403", :country=>"US", :name=>"Knickerbocker Theatre", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103679, 42.790269]}, :id=>"SG_5iwLxG6ALqH1IBgxCzWZIy_42.790269_-86.103679@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Real Estate", :subcategory=>"Architect"}], :website=>"www.gmb.com", :tags=>["engineering", "architectural"], :postcode=>"49423", :city=>"Holland", :address=>"85 E 8th St", :phone=>"+1 616 392 7034", :country=>"US", :name=>"Gmb Architects-Engineers", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103679, 42.790419]}, :id=>"SG_1iwoQtrrKg632jyzQxCnWh_42.790419_-86.103679@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Investment Brokerage"}], :tags=>["stock", "bond"], :postcode=>"49423", :city=>"Holland", :address=>"85 E 8th St", :phone=>"+1 616 394 9199", :country=>"US", :name=>"Hilliard Lyons Inc", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103679, 42.790419]}, :id=>"SG_1XxsjEwzAzO1iVklXUfWSX_42.790419_-86.103679@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Professional", :subcategory=>"Lawyer & Legal Services"}], :website=>"www.wnj.com", :tags=>["attorney"], :postcode=>"49423", :city=>"Holland", :address=>"85 E 8th St", :phone=>"+1 616 396 9800", :country=>"US", :name=>"Warner Norcross & Judd", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103679, 42.790419]}, :id=>"SG_0gq8wAnbF1wtS1ISMf28qZ_42.790419_-86.103679@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Bank"}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"81 E 8th St", :phone=>"+1 616 355 2884", :country=>"US", :name=>"West Michigan Community Bank", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.10381, 42.790419]}, :id=>"SG_4rDWezFhTCBLMiWSHOCZPb_42.790419_-86.103810@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Retail Goods", :category=>"Shopping", :subcategory=>"Florist"}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"78 E 8th St", :phone=>"+1 616 396 6369", :country=>"US", :name=>"Indigo Floral", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103942, 42.790268]}, :id=>"SG_58jgJxBtYRhv9jx0osBZZ0_42.790268_-86.103942@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Professional", :subcategory=>"Business Services"}], :tags=>["information", "bureau", "convention"], :postcode=>"49423", :city=>"Holland", :address=>"76 E 8th St", :phone=>"+1 616 394 0000", :country=>"US", :name=>"Holland Area Convention", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104007, 42.790268]}, :id=>"SG_6B9SX7leIDD6L7VBNkSxU7_42.790268_-86.104007@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Professional", :subcategory=>"Computer Services"}], :website=>"www.fastcadworks.com", :tags=>["design", "system", "graphics"], :postcode=>"49423", :city=>"Holland", :address=>"76 E 8th St", :phone=>"+1 616 392 8088", :country=>"US", :name=>"Fast Cad Works Inc", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104007, 42.790268]}, :id=>"SG_6PImENDBqa4bKCUecEhx71_42.790268_-86.104007@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Professional", :subcategory=>"Business Services"}], :tags=>["operation"], :postcode=>"49423", :city=>"Holland", :address=>"76 E 8th St", :phone=>"+1 616 394 0000", :country=>"US", :name=>"Holland Area Cnvntn/Vstrs Brea", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104007, 42.790268]}, :id=>"SG_7bdzq0CZtU46XOkK0rAnb2_42.790268_-86.104007@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Utilities", :subcategory=>"Mobile Phone"}], :tags=>["telephone", "cellular"], :postcode=>"49423", :city=>"Holland", :address=>"74 E 8th St", :phone=>"+1 616 396 9000", :country=>"US", :name=>"Citywide Cellular", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104073, 42.790268]}, :id=>"SG_0MeFGadhDgjUvxctRv1jI0_42.790268_-86.104073@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Manufacturing & Wholesale Goods", :category=>"Wholesale", :subcategory=>"Stationery"}], :tags=>["product", "paper"], :postcode=>"49423", :city=>"Holland", :address=>"74 E 8th St", :phone=>"+1 616 928 0069", :country=>"US", :name=>"Paper Projects", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104073, 42.790268]}, :id=>"SG_1pWaseKLVyM6s4AUy8uk1g_42.790268_-86.104073@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"73 E 8th St", :phone=>"+1 616 393 6340", :country=>"US", :name=>"Curra Irish Pub", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104073, 42.790418]}, :id=>"SG_7EHfB3sWifm1cuJEFsIPHM_42.790418_-86.104073@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Retail Goods", :category=>"Shopping", :subcategory=>"Musical Instruments"}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"72 E 8th St", :phone=>"+1 616 494 9433", :country=>"US", :name=>"Holland Rit Music", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104139, 42.790268]}, :id=>"SG_76E6200B4vVKwohCB9kn7d_42.790268_-86.104139@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Public Place", :category=>"Education", :subcategory=>"Special Training"}], :tags=>["instruction", "music"], :postcode=>"49423", :city=>"Holland", :address=>"72 E 8th St", :phone=>"+1 616 392 5455", :country=>"US", :name=>"RIT Music", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104139, 42.790268]}, :id=>"SG_4o6BJ7oVuFFQd1xaC3Iwu9_42.790268_-86.104139@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Professional", :subcategory=>"Research"}], :tags=>[""], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 395 7678", :country=>"US", :name=>"A C Van Raalte Institute", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_5HRY8FXZc3mZJk3qhzqhMP_42.790269_-86.103218@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Investment Brokerage"}], :tags=>["security"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 269 983 2587", :country=>"US", :name=>"First of Michigan Corporation", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_6CD4NhpaIUhUXjrIpt989B_42.790269_-86.103218@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Investment Brokerage"}, {:type=>"Services", :category=>"Professional", :subcategory=>"Management & Consulting"}], :tags=>["consultant", "planning", "financial"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 355 9890", :country=>"US", :name=>"Morgan Stanley", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_6bcMqwMhOCYl98xqOvTHai_42.790269_-86.103218@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Investment Brokerage"}], :tags=>["security", "management", "consulting"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 392 5333", :country=>"US", :name=>"Merrill Lynch", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_1k69enLHB2I9GSIAwYKHZs_42.790269_-86.103218@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Investment Brokerage"}], :tags=>["stock", "bond"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 546 3557", :country=>"US", :name=>"Oppenheimer & Co Inc", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_4wOwAHiiQNDLSwKRYjoYvU_42.790269_-86.103218@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Manufacturing & Wholesale Goods", :category=>"Wholesale", :subcategory=>"Furniture"}], :tags=>["household", "wood", "mfg"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 392 8761", :country=>"US", :name=>"Baker Furniture Museum", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_3koZp5aq0uEvV3EgZ5dBCW_42.790269_-86.103218@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Public Place", :category=>"Education", :subcategory=>"College"}], :tags=>["academic", "school"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 395 7919", :country=>"US", :name=>"Hope Academy Of Senior Prf", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_4Ne2H3wEbDjnNXNcgOTTrd_42.790269_-86.103218@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Bank"}], :tags=>["commercial"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 395 2585", :country=>"US", :name=>"Republic Bank", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_4TgInjExuHo9gtBelHyAeF_42.790269_-86.103218@1291674002"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Services", :category=>"Real Estate", :subcategory=>"Real Estate Agent"}], :tags=>["cooperative"], :postcode=>"49423", :city=>"Holland", :address=>"100 E 8th St", :phone=>"+1 616 399 5125", :country=>"US", :name=>"Beverage Associates Co-Op Inc", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.103218, 42.790269]}, :id=>"SG_2kJmYRSi2D4vye77KO9FvS_42.790269_-86.103218@1291805576"}, {:type=>"Feature", :properties=>{:owner=>"simplegeo", :classifiers=>[{:type=>"Manufacturing & Wholesale Goods", :category=>"Manufacturing", :subcategory=>"Food"}], :website=>"www.newhollandbrew.com", :tags=>["brewer"], :postcode=>"49423", :city=>"Holland", :address=>"66 E 8th St", :phone=>"+1 616 355 6422", :country=>"US", :name=>"New Holland Brewing Co", :province=>"MI"}, :geometry=>{:type=>"Point", :coordinates=>[-86.104336, 42.790268]}, :id=>"SG_7WiYaNPjducHg5gbpH1ukN_42.790268_-86.104336@1291674002"}]}
      end
    end
    
    context "with a search term" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/places/42.790311,-86.103725.json?q=Dutch',
          :fixture_file => 'places_q.json'
      end
      
      it "should return a hash with the places nearby matching the name" do
        dutch_places = SimpleGeo::Client.get_places(42.790311, -86.103725, :q => 'Dutch')
        dutch_places.should == {:type=>"FeatureCollection", :features=>[{:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.112928, 42.801396]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Services", :category=>"Building & Trades", :subcategory=>"Construction"}], :tags=>["tile", "dealer"], :postcode=>"49424", :city=>"Holland", :address=>"129 Howard Ave", :country=>"US", :name=>"Duca The Dutch Carpenter", :phone=>"+1 616 494 0404"}, :id=>"SG_6I3KqAqKIqpRLaduUcUBRr_42.801396_-86.112928@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.107095, 42.776685]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Entertainment", :category=>"Travel", :subcategory=>"Hotels & Motels"}], :tags=>["house", "operation", "construction"], :postcode=>"49423", :city=>"Holland", :address=>"560 Central Ave", :country=>"US", :name=>"Dutch Colonial Inn", :phone=>"+1 616 396 3664"}, :id=>"SG_6ucOjwWPjOCcbHeyMJnoY9_42.776685_-86.107095@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.098187, 42.775013]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Services", :category=>"Banks & Credit Unions", :subcategory=>"Bank"}], :tags=>["state"], :postcode=>"49423", :city=>"Holland", :address=>"215 E 25th St", :country=>"US", :name=>"Big Dutch Fleet Credit Union", :phone=>"+1 616 396 5000"}, :id=>"SG_6mO5cCEdHU8AFO0OxvLQgP_42.775013_-86.098187@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.126474, 42.781931]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Home & Garden", :subcategory=>"Furniture"}], :tags=>["equipment", "kitchen", "cabinet"], :postcode=>"49423", :city=>"Holland", :address=>"420 W 17th St", :country=>"US", :name=>"Dutch Made Custom Cabinetry", :phone=>"+1 616 392 4480"}, :id=>"SG_1SO3yvCM1dWdnSlo3vywBI_42.781931_-86.126474@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.13011, 42.779354]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Manufacturing & Wholesale Goods", :category=>"Manufacturing", :subcategory=>"Food"}], :tags=>["product", "salad"], :postcode=>"49423", :city=>"Holland", :address=>"507 W 20th St", :country=>"US", :name=>"Dutch Treat Salads", :phone=>"+1 616 396 3392"}, :id=>"SG_6jFqymBz2f0fL6isDiizHO_42.779354_-86.130110@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.089768, 42.810865]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>[], :postcode=>"49424", :city=>"Holland", :address=>"2229 N Park Dr", :country=>"US", :name=>"Dutch Subway LLC", :phone=>"+1 616 393 7991"}, :id=>"SG_1Y0brcGA5S8IF0Phta2BwM_42.810865_-86.089768@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.087692, 42.811998]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Shopping", :subcategory=>"Gifts & Souvenirs"}], :tags=>["shop"], :postcode=>"49424", :city=>"Holland", :website=>"www.dutchvillage.com", :address=>"12350 James St", :country=>"US", :name=>"Dutch Village", :phone=>"+1 616 396 1475"}, :id=>"SG_20goKPd6BzmzAl787Hmi5h_42.811998_-86.087692@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.122281, 42.812614]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Food & Beverages", :subcategory=>"Bakery"}], :tags=>["baker"], :postcode=>"49424", :city=>"Holland", :address=>"501 Butternut Dr", :country=>"US", :name=>"Dutch Delite Bakery", :phone=>"+1 616 399 6050"}, :id=>"SG_7BxMkAcMduxYrtRlSP7JJ5_42.812614_-86.122281@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.038383, 42.805126]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Entertainment", :category=>"Travel", :subcategory=>"Campground"}], :tags=>["trailer"], :postcode=>"49464", :city=>"Zeeland", :address=>"10300 Gordon St", :country=>"US", :name=>"Dutch St Camping & Recreation", :phone=>"+1 616 772 4303"}, :id=>"SG_5BE2NtLKOzhR4GEJHqP70I_42.805126_-86.038383@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.038383, 42.805126]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Entertainment", :category=>"Travel", :subcategory=>"Campground"}], :tags=>[], :postcode=>"49464", :city=>"Zeeland", :address=>"10300 Gordon St", :country=>"US", :name=>"Dutch Treat Camping & Rec", :phone=>"+1 616 772 4303"}, :id=>"SG_6EqRqswuhnjdXJpzV4tImf_42.805126_-86.038383@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.094211, 42.841058]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Shopping", :subcategory=>"Gifts & Souvenirs"}], :tags=>[], :postcode=>"49424", :city=>"Holland", :address=>"12755 Quincy St", :country=>"US", :name=>"Dutch Delft Blue", :phone=>"+1 616 399 1803"}, :id=>"SG_3lJVWKDOt3xnYwgq26dGr8_42.841058_-86.094211@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.067609, 42.739675]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Services", :category=>"Retail", :subcategory=>"Car Wash"}], :tags=>["truck", "cleaning"], :postcode=>"49423", :city=>"Holland", :address=>"4356 Lincoln Rd", :country=>"US", :name=>"Dutch Touch Truck Wash", :phone=>"+1 616 396 0679"}, :id=>"SG_6ei1IIEtJ8jLWel1t3QsZv_42.739675_-86.067609@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-85.979829, 42.843688]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Manufacturing & Wholesale Goods", :category=>"Wholesale", :subcategory=>"Plants"}], :tags=>["nursery", "tree"], :postcode=>"49464", :city=>"Zeeland", :address=>"4135 80th Ave", :country=>"US", :name=>"Dutch Touch Growers Inc", :phone=>"+1 616 875 7416"}, :id=>"SG_5Sbj5KbLNCSIfh3P0zuyD0_42.843688_-85.979829@1291674002"}], :total=>13}
      end
    end

    context "with a category" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/places/42.790311,-86.103725.json?category=coffee',
          :fixture_file => 'places_category.json'
      end

      it "should return a hash with the places nearby matching the classifiers" do
        coffee_places = SimpleGeo::Client.get_places(42.790311, -86.103725, :category => 'coffee')
        coffee_places.should == {:type=>"FeatureCollection", :features=>[{:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.106339, 42.790389]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49423", :city=>"Holland", :website=>"www.jpscoffee.com", :address=>"57 E 8th St", :country=>"US", :name=>"J P's Coffee & Espresso Bar", :phone=>"+1 616 396 5465"}, :id=>"SG_5mG4NZzFGavcAh7OAKIQH5_42.790389_-86.106339@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.100164, 42.780542]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49423", :city=>"Holland", :address=>"451 Columbia Ave", :country=>"US", :name=>"Leaf & Bean Too", :phone=>"+1 616 355 2251"}, :id=>"SG_0QKaDcYrJbX6OtfwCZcrMt_42.780542_-86.100164@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.101407, 42.805658]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49424", :city=>"Holland", :address=>"166 E Lakewood Blvd", :country=>"US", :name=>"Joe 2 Go", :phone=>"+1 616 395 5950"}, :id=>"SG_7eWRRtNkDrWZfQQtMo3PAl_42.805658_-86.101407@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.123647, 42.797738]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49424", :city=>"Holland", :address=>"321 Douglas Ave", :country=>"US", :name=>"Perfect Cup Cafe", :phone=>"+1 616 395 2593"}, :id=>"SG_5jMWhnI7je8uIxRFoIA88u_42.797738_-86.123647@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.059282, 42.804026]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49424", :city=>"Holland", :address=>"11260 Chicago Dr", :country=>"US", :name=>"Carpe Latte", :phone=>"+1 616 396 6005"}, :id=>"SG_74Ue55SNQhHEfPbZSSHI5a_42.804026_-86.059282@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.016332, 42.812393]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49464", :city=>"Zeeland", :address=>"111 E Main Ave", :country=>"US", :name=>"Sweet Bean Coffee & Espresso", :phone=>"+1 616 772 6450"}, :id=>"SG_1gQsUcVZpEh6omTmvGFXU6_42.812393_-86.016332@1291805576"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.004882, 42.826855]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Food & Beverages", :subcategory=>"Specialty"}], :tags=>["tea", "coffee"], :postcode=>"49464", :city=>"Zeeland", :address=>"790 Case Karsten Dr", :country=>"US", :name=>"CVC Coffee Svc", :phone=>"+1 616 896 8882"}, :id=>"SG_5OHDBISAiQj2jpjCBAbMTO_42.826855_-86.004882@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.204341, 42.656513]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Retail Goods", :category=>"Food & Beverages", :subcategory=>"Specialty"}], :tags=>["tea", "coffee"], :postcode=>"49453", :city=>"Saugatuck", :website=>"www.uncommongroundscafe.com", :address=>"127 Hoffman St", :country=>"US", :name=>"Uncommon Grounds", :phone=>"+1 269 857 3333"}, :id=>"SG_4hMBeWsWfPMa03AIZFy9cQ_42.656513_-86.204341@1291674002"}, {:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.200469, 42.643744]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>["shop", "coffee"], :postcode=>"49406", :city=>"Douglas", :address=>"48 E Center St", :country=>"US", :name=>"Respite", :phone=>"+1 269 857 5411"}, :id=>"SG_0IzakqfFENxLpL1nSgIoSw_42.643744_-86.200469@1291805576"}], :total=>9}
      end
    end

    context "with a category and a query" do
      before do
        stub_request :get,
          'http://api.simplegeo.com/1.0/places/42.790311,-86.103725.json?category=Restaurant&q=Dutch',
          :fixture_file => 'places_category_and_q.json'
      end

      it "should return a hash with the places nearby matching the name and classifiers" do
        dutch_restaurant_places = SimpleGeo::Client.get_places(42.790311, -86.103725, :category => 'Restaurant', :q => 'Dutch')
        dutch_restaurant_places.should == {:type=>"FeatureCollection", :features=>[{:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.089768, 42.810865]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>[], :postcode=>"49424", :city=>"Holland", :address=>"2229 N Park Dr", :country=>"US", :name=>"Dutch Subway LLC", :phone=>"+1 616 393 7991"}, :id=>"SG_1Y0brcGA5S8IF0Phta2BwM_42.810865_-86.089768@1291805576"}], :total=>1}
      end
    end
  end
  
  
  context "with a category and a query that contains multiple words" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/1.0/places/42.790311,-86.103725.json?category=Restaurant&q=Dutch+Subway',
        :fixture_file => 'places_category_and_multiple_q.json'
    end

    it "should return a hash with the places nearby matching the name and classifiers" do
      dutch_restaurant_places = SimpleGeo::Client.get_places(42.790311, -86.103725, :category => 'Restaurant', :q => 'Dutch+Subway')
      dutch_restaurant_places.should == {:type=>"FeatureCollection", :features=>[{:type=>"Feature", :geometry=>{:type=>"Point", :coordinates=>[-86.089768, 42.810865]}, :properties=>{:owner=>"simplegeo", :province=>"MI", :classifiers=>[{:type=>"Food & Drink", :category=>"Restaurant", :subcategory=>""}], :tags=>[], :postcode=>"49424", :city=>"Holland", :address=>"2229 N Park Dr", :country=>"US", :name=>"Dutch Subway LLC", :phone=>"+1 616 393 7991"}, :id=>"SG_1Y0brcGA5S8IF0Phta2BwM_42.810865_-86.089768@1291805576"}], :total=>1}
    end
  end



  context "getting contains info for a set of coordinates" do
    before do
      stub_request :get,
        'http://api.simplegeo.com/1.0/context/37.7587890625,-122.4267578125.json',
        :fixture_file => 'contains.json'
    end

    it "should return a hash with the correct info" do
      info = SimpleGeo::Client.get_context(37.7587890625, -122.4267578125)
      info.should == [
        {
          :bounds =>
          [
            -122.435188,
             37.756093,
             -122.42555,
             37.763030999999998
          ],
           :type => "Census Tract",
           :id => "Census_Tract:06075020600:9q8yy1",
           :abbr => "",
           :name => "06075020600"
        },
        {
          :bounds =>
          [
            -123.17382499999999,
             37.639829999999996,
             -122.28178,
             37.929823999999996
          ],
           :type => "County",
           :id => "County:San_Francisco:9q8yvv",
           :abbr => "",
           :name => "San Francisco"
        },
        {
          :bounds =>
          [
            -123.17382499999999,
             37.639829999999996,
             -122.28178,
             37.929823999999996
          ],
           :type => "City",
           :id => "City:San_Francisco:9q8yvv",
           :abbr => "",
           :name => "San Francisco"
        },
        {
          :bounds =>
          [
            -122.612285,
             37.708131000000002,
             -122.28178,
             37.929823999999996
          ],
           :type => "Congressional District",
           :id => "Congressional_District:Congressional_Di:9q8yyn",
           :abbr => "",
           :name => "Congressional District 8"
        },
        {
          :bounds =>
          [
            -179.14247147726383,
             18.930137634111077,
             179.78114994357418,
             71.412179667308919
          ],
           :type => "Country",
           :id => "Country:United_States_of:9z12zg",
           :abbr => "",
           :name => "United States of America"
        },
        {
          :bounds =>
          [
            -122.428882,
             37.758029999999998,
             -122.42138199999999,
             37.772263000000002
          ],
           :type => "Neighborhood",
           :id => "Neighborhood:Mission_Dolores:9q8yy4",
           :abbr => "",
           :name => "Mission Dolores"
        },
        {
          :bounds =>
          [
            -122.51666666668193,
             37.191666666628507,
             -121.73333333334497,
             38.041666666640907
          ],
           :type => "Urban Area",
           :id => "Urban_Area:San_Francisco1:9q9jsg",
           :abbr => "",
           :name => "San Francisco1"
        },
        {
          :bounds =>
          [
            -122.451553,
             37.746687000000001,
             -122.424773,
             37.770451999999999
          ],
           :type => "Postal",
           :id => "Postal:94114:9q8yvc",
           :abbr => "",
           :name => "94114"
        },
        {
          :bounds =>
          [
            -124.48200299999999,
             32.528832000000001,
             -114.13121099999999,
             42.009516999999995
          ],
           :type => "Province",
           :id => "Province:CA:9qdguu",
           :abbr => "CA",
           :name => "California"
        }
      ]
    end
  end

end
