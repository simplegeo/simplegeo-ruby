require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Client" do
  it "should return a feature when requesting it using the correct handle" do
    VCR.use_cassette("feature_valid",
                    :record => :new_episodes) do
      @feature = SimpleGeo::Client.get_feature("SG_4ahRExz3iKlEjoeSZk7b9G_40.728714_-73.992082")
      @feature.properties[:name].should == 'The Public Theater'
    end
  end
  
  it "should throw an errorwhen requesting a feature with an invalid handle" do
    VCR.use_cassette("feature_valid",
                    :record => :new_episodes) do
      expect{SimpleGeo::Client.get_feature("badly-formed-handle")}.to raise_error(SimpleGeo::SimpleGeoError)
    end
  end

end