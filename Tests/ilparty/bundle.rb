#!/usr/bin/env ruby

require 'osx/cocoa'
include OSX
NSBundle.bundleWithPath('TheLongMix-UnitTests.bundle').load

class NSObject
	def mutable(key)
		self.mutableArrayValueForKey_(key.to_s)
	end
	
	def decocoaified
		decocoaify(self)
	end
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