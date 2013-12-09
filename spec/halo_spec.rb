require 'spec_helper'

describe Halo do

	describe "configuration" do
		it "loads its configuration from the .yaml file on creation" do
			halo = Halo.new
      halo.client_id.should_not be nil
      halo.client_secret.should_not be nil
		end
  end

  describe "authentication" do
    it "is marked as authenticated on successful authentication" do
      halo = Halo.new
      halo.authenticate

      halo.token.should_not be nil
      halo.token_expires.should be > Time.now
    end

    it "authenticates if not already authenticated" do
      halo = Halo.new
      halo.token_expires.should be nil

      halo.request("events", {})

      halo.token_expires.should_not be nil
    end
  end

  describe "events" do
    it "pulls events for default parameters" do
      halo = Halo.new
      events = halo.events()

      events.should_not be nil
    end

    it "pulls some guaranteed events when passed a start time" do
      halo = Halo.new
      events = halo.events(Time.new("2013-12-01"))
      events.length().should be > 0
    end
  end
end