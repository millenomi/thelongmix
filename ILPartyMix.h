//
//  ILPartyMix.h
//  Party
//
//  Created by ∞ on 20/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILPartyTrack.h"
#import "ILPartyTrackSource.h"

#define kILPartyMixWillPerformBatchUpdateNotification @"ILPartyMixWillPerformBatchUpdate"
#define kILPartyMixDidEndPerformingBatchUpdateNotification @"ILPartyMixDidEndPerformingBatchUpdate"

enum {
	kILPartyMixTrackMinimumNone = -1,
};

@interface ILPartyMix : NSObject {
	NSMutableArray* mutableTracksArray, * mutablePastTracksArray, * mutableDesiredTracksArray;
	NSUInteger batchCount;
}

+ mix;

@property(readonly) NSArray* tracks;
@property(readonly) NSMutableArray* mutableTracks;

@property(retain) id <ILPartyTrack> currentTrack;

@property(readonly) NSArray* pastTracks;
@property(readonly) NSMutableArray* mutablePastTracks;

@property(readonly) NSArray* desiredTracks;
@property(readonly) NSMutableArray* mutableDesiredTracks;

- (void) makeNextCurrent;

// Set to kILPartyMixTrackMinimumNone to disable limits.
// @property(assign) NSInteger maximumPastTracks;

- (void) setDesired:(BOOL) desired forTrack:(id <ILPartyTrack>) track;

@property(assign) NSUInteger minimumNumberOfTracks;
@property(retain) id <ILPartyTrackSource> trackSource;

@property(readonly, getter=isPerformingUpdateBatch) BOOL performingUpdateMatch;

@end
