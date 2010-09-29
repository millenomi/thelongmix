//
//  ILPartyMix.m
//  Party
//
//  Created by ∞ on 20/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyMix.h"
#import "ILPartyKVCTools.h"

@implementation ILPartyMix

+ mix;
{
	return [[self new] autorelease];
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		mutableTracksArray = [NSMutableArray new];
		mutablePastTracksArray = [NSMutableArray new];
		mutableDesiredTracksArray = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc
{
	self.trackSource = nil;
	[mutableTracksArray release];
	[mutablePastTracksArray release];
	[mutableDesiredTracksArray release];
	self.currentTrack = nil;
	[super dealloc];
}


- (NSArray *) tracks;
{
	return mutableTracksArray;
}

- (NSArray *) desiredTracks;
{
	return mutableDesiredTracksArray;
}

- (NSArray *) pastTracks;
{
	return mutablePastTracksArray;
}

@synthesize currentTrack;

@synthesize trackSource, minimumNumberOfTracks;

ILMutableAccessorsForApparentlyImmutableKey(Tracks, mutableTracksArray)
ILMutableAccessorsForApparentlyImmutableKey(PastTracks, mutablePastTracksArray)
ILMutableAccessorsForApparentlyImmutableKey(DesiredTracks, mutableDesiredTracksArray)

ILAccessorForKVCMutableArray(mutableTracks, tracks)
ILAccessorForKVCMutableArray(mutablePastTracks, pastTracks)
ILAccessorForKVCMutableArray(mutableDesiredTracks, desiredTracks)

- (void) makeNextCurrent;
{
	// TODO limits to past tracks.
	// TODO fetch tracks from track source.
	
	id <ILPartyTrack> track = self.currentTrack;
	
	id <ILPartyTrack> nextTrack = nil;
	NSMutableArray* nextTrackSource = nil;
	
	if ([self.desiredTracks count] > 0)
		nextTrackSource = self.mutableDesiredTracks;
	else if ([self.tracks count] > 0)
		nextTrackSource = self.mutableTracks;
	
	nextTrack = [nextTrackSource objectAtIndex:0];

	[[track retain] autorelease];
	[[nextTrack retain] autorelease];
	
	if (track) {
		self.currentTrack = nil;
		[self.mutablePastTracks addObject:track];
	}
	
	if (nextTrack) {
		[nextTrackSource removeObjectAtIndex:0];
		self.currentTrack = nextTrack;
	}
}

@end
