#!/usr/bin/env ruby

require File.join File.dirname(__FILE__), 'ilparty/bundle'
require File.join File.dirname(__FILE__), 'ilparty/fake_track'

describe ILPartyMix do
	before :each do
		@mix = ILPartyMix.alloc.init
	end
	
	it "should move to next track when makeNextCurrent is invoked" do
		
		@mix.mutable(:pastTracks).setArray []
		@mix.mutable(:desiredTracks).setArray FakeTrack.tracks([1])
		@mix.mutable(:tracks).setArray FakeTrack.tracks([2, 3, 4])
		
		@mix.pastTracks.decocoaified.should eql([])
		@mix.currentTrack.should be_nil
		@mix.desiredTracks.decocoaified.should eql(FakeTrack.tracks([1]))
		@mix.tracks.decocoaified.should eql(FakeTrack.tracks([2, 3, 4]))
		
		@mix.makeNextCurrent
		
		@mix.pastTracks.decocoaified.should eql([])
		@mix.currentTrack.should eql(FakeTrack.track 1)
		@mix.desiredTracks.decocoaified.should eql([])
		@mix.tracks.decocoaified.should eql(FakeTrack.tracks([2, 3, 4]))
		
		@mix.makeNextCurrent
		
		@mix.pastTracks.decocoaified.should eql(FakeTrack.tracks([1]))
		@mix.currentTrack.should eql(FakeTrack.track 2)
		@mix.desiredTracks.decocoaified.should eql([])
		@mix.tracks.decocoaified.should eql(FakeTrack.tracks([3, 4]))
		
	end
end