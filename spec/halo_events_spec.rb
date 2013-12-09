require 'spec_helper'

describe HaloEvents do
  before(:all) do
    event_path = File.expand_path("../events.json", __FILE__)
    @events = JSON.parse(IO.read(event_path))
  end

  describe "events" do
    it "creates a hash with individual message counts" do
      he = HaloEvents.new(@events)
      ct = he.get_count("fim_signature_changed")

      ct.should be 1
    end

    it "returns 0 for the count of an unknown event type" do
      he = HaloEvents.new(@events)
      ct = he.get_count("something/random")

      ct.should be 0
    end
  end
end


