#!/usr/bin/env ruby

class FakeTrack # Conforms to the ILPartyTrack protocol -- see ILPartyTrack.h
	def initialize(name)
		@name = name
	end
	
	def track_name
		@name
	end
	
	def title
		track_name
	end
	
	def album
		"The #{track_name} Tracks Album"
	end
	
	def artwork
		nil
	end
	
	def ==(x)
		x.track_name == track_name
	end
	
	def eql?(x)
		x.kind_of? FakeTrack and self == x
	end
	
	def self.track(n)
		return n.map {|x| track(x)} if n.kind_of? Array
		
		FakeTrack.new n.to_s
	end
	
	def self.tracks(n)
		n.map {|x| track(x)}
	end
	
end
