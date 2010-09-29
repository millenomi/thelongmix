//
//  ILPartyMixList.h
//  Party
//
//  Created by ∞ on 21/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILPartyMix;

enum {
	kILPartyMixPastTrack,
	kILPartyMixDesiredTrack,
	kILPartyMixCurrentTrack,
	kILPartyMixTrack,
	kILPartyMixNoTrackKind,
};
typedef NSInteger ILPartyTrackKind;

@interface ILPartyMixList : NSObject {
	ILPartyMix* mix;
	NSMutableArray* mutableOrderedTracks;
	
	NSRange pastTracksRange, desiredTracksRange, tracksRange;
	NSInteger currentTrackIndex;
}

@property(nonatomic, retain) ILPartyMix* mix;

@property(readonly) NSArray* orderedTracks;

- (ILPartyTrackKind) kindOfTrackAtIndex:(NSInteger) i;

#if DEBUG
+ (NSArray*) orderedTracksForMix:(ILPartyMix*) m;
#endif

@end
