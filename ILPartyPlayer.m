//
//  ILPartyPlayer.m
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "ILSensorSession.h"

@interface ILPartyPlayer ()

@property(nonatomic, assign, getter=isPlaying) BOOL playing;
@property(nonatomic, retain) id <ILPartyMediaItemTrack> nowPlayingTrack;
@property(nonatomic, retain) AVPlayer* player;

- (void) beginObservingMix;
- (void) stopObservingMix;
- (void) updateCurrentTrack;

@property(nonatomic, retain) ILSensorSession* playSession;

@end


@implementation ILPartyPlayer

- (void) dealloc
{
	[self pause];
	self.mix = nil;
	[super dealloc];
}


@synthesize mix;
- (void) setMix:(ILPartyMix *) m;
{
	if (m != mix) {
		self.nowPlayingTrack = nil;
		
		if (mix)
			[self stopObservingMix];
		[mix release];
		
		mix = [m retain];
		
		if (mix) {
			[self updateCurrentTrack];
			[self beginObservingMix];
		}
	}
}

- (void) beginObservingMix;
{
	[self.mix addObserver:self forKeyPath:@"currentTrack" options:0 context:NULL];
}

- (void) stopObservingMix;
{
	[self.mix removeObserver:self forKeyPath:@"currentTrack"];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	if (!self.playing)
		return;
	
	[self updateCurrentTrack];
}
	
- (void) updateCurrentTrack;
{
	if ([self.mix.currentTrack conformsToProtocol:@protocol(ILPartyMediaItemTrack)])
		self.nowPlayingTrack = (id <ILPartyMediaItemTrack>) self.mix.currentTrack;
}

@synthesize nowPlayingTrack;
- (void) setNowPlayingTrack:(id <ILPartyMediaItemTrack>) t;
{
	BOOL isSameTrackAsCurrent = t && nowPlayingTrack && [t mediaItemIdentifier] == [nowPlayingTrack mediaItemIdentifier];
	BOOL wasPlaying = self.playing;
	
	if (t != nowPlayingTrack) {
		if (wasPlaying && !isSameTrackAsCurrent) {
			self.playing = NO;
			self.player = nil;
			[self.playSession end];
			self.playSession = nil;
		}
		
		[nowPlayingTrack release];
		nowPlayingTrack = [t retain];
		
		if (!self.playSession)
			self.playSession = ILSessionEmpty();
		
		[self.playSession setObject:t forPropertyKey:@"nowPlayingTrack"];
		[self.playSession update];
		
		if (wasPlaying && !isSameTrackAsCurrent)
			self.playing = YES;
	}
}

@synthesize playing;
- (void) setPlaying:(BOOL) p;
{
	if (p != playing) {
		if (!p) {
			[self.playSession setObject:@"paused" forPropertyKey:@"state"];
			[self.playSession update];
			
			[self.player pause];
		} else if (self.nowPlayingTrack && !self.player) {
			NSURL* u = [[self.nowPlayingTrack mediaItem] valueForProperty:MPMediaItemPropertyAssetURL];
			if (u) {
				if (!self.playSession)
					self.playSession = ILSessionEmpty();
				
				[self.player pause];
				self.player = [AVPlayer playerWithURL:u];
				[self.player play];

				[self.playSession setObject:@"playing" forPropertyKey:@"state"];
				[self.playSession setObject:self.player forPropertyKey:@"player"];
				[self.playSession update];
			}
		}
		
		playing = p;
	}
}

- (void) play;
{
	self.playing = YES;
}

- (void) pause;
{
	self.playing = NO;
}

@synthesize player;

@synthesize playSession;

@end
