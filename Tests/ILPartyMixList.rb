#!/usr/bin/env ruby

require File.join File.dirname(__FILE__), 'ilparty/bundle'
require File.join File.dirname(__FILE__), 'ilparty/fake_track'

describe ILPartyMixList do
	before :each do
		@mix = ILPartyMix.alloc.init
		@list = ILPartyMixList.alloc.init
	end
	
	def track(n)
		return n.map {|x| track(x)} if n.kind_of? Array
		
		FakeTrack.new n
	end
	
	def tracks(n)
		n.map {|x| track(x)}
	end
	
	def decocoaify(plist)
		if plist.kind_of? NSArray
			a = []
			plist.each do |x|
				a << decocoaify(x)
			end
			a
		elsif plist.kind_of? NSDictionary
			h = {}
			plist.each do |key, value|
				h[decocoaify(key)] = decocoaify(value)
			end
			h
		elsif plist.kind_of? NSString
			plist.to_s
		elsif plist.kind_of? NSNumber
			plist.doubleValue
		# TODO NSDate, NSData
		else
			plist
		end
	end
	
	# TODO stop using strings and use some kind of real ILPartyTrack object.

	it "should have ordered tracks in the order set in the mix" do
		@list.mix.should be_nil
		@list.orderedTracks.to_a.should eql([])
	
		@mix.mutablePastTracks.addObject track('-2')
		@mix.mutablePastTracks.addObject track('-1')
		
		@mix.currentTrack = track('0')
		
		@mix.mutableDesiredTracks.addObject track('0.5')
		@mix.mutableDesiredTracks.addObject track('0.7')
	
		@mix.mutableTracks.addObject track('1')
		@mix.mutableTracks.addObject track('2')
		@mix.mutableTracks.addObject track('3')

		@list.mix = @mix
		
		decocoaify(@list.orderedTracks).should eql(tracks([
			'-2', '-1',
			'0',
			'0.5', '0.7',
			'1', '2', '3'
		]))
		
		@list.mix = nil
		
		decocoaify(@list.orderedTracks).should eql([])
	end
	
	it "should follow changes done to the mix" do
		@mix.mutablePastTracks.setArray track(['-1'])
		@mix.currentTrack = track('0')
		@mix.mutableDesiredTracks.setArray track(['1', '2'])
		@mix.mutableTracks.setArray track(['3'])
		
		@list.mix = @mix
		
		decocoaify(@list.orderedTracks).should eql(tracks(['-1', '0', '1', '2', '3']))
		
		w = @mix.desiredTracks.dup
		@mix.mutableArrayValueForKey_("desiredTracks").removeAllObjects
		@mix.mutableArrayValueForKey_("tracks").addObjectsFromArray w
		
		decocoaify(@list.orderedTracks).should eql(tracks(['-1', '0', '3', '1', '2']))
		
		w = @mix.currentTrack
		next_one = @mix.tracks[0]
		@mix.mutableArrayValueForKey_("tracks").removeObjectAtIndex(0)
		@mix.currentTrack = next_one
		
		decocoaify(@list.orderedTracks).should eql(tracks(['-1', '3', '1', '2']))
		
		@mix.mutableArrayValueForKey_("pastTracks").addObject w
		
		decocoaify(@list.orderedTracks).should eql(tracks(['-1', '0', '3', '1', '2']))
	end
	
	it "should follow changes done to the current track" do
		@mix.currentTrack = track('0')
		@list.mix = @mix
		
		decocoaify(@list.orderedTracks).should eql(tracks(['0']))
		
		@mix.currentTrack = track('1')
		decocoaify(@list.orderedTracks).should eql(tracks(['1']))
		
		@mix.currentTrack = nil
		decocoaify(@list.orderedTracks).should eql(tracks([]))
	end
end
