require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Context" do
  before do
    VCR.use_cassette("context", :record => :new_episodes) do
      ip = '213.24.76.23' # www.fsb.ru
      context_hash = SimpleGeo::Client.get_context_ip(ip)
      @context = SimpleGeo::Context.new(context_hash)
    end
  end
  
  context "#country" do
    it "should work" do
      @context.country.should == "Russia"
    end
  end
end