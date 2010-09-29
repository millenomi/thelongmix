//
//  ILPartyMixList.m
//  Party
//
//  Created by ∞ on 21/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyMixList.h"
#import "ILPartyMix.h"

#import "ILSensorSink.h"

@interface ILPartyMixList ()

- (void) stopObservingMix;
- (void) beginObservingMix;

// @property(readonly) NSRange rangeOfPastTracks, rangeOfCurrentTrack, rangeOfDesiredTracks, rangeOfTracks;

- (void) handleChangeToCurrentTrack:(NSDictionary *)change;
- (void) handleChange:(NSDictionary *)change toCollectionKey:(NSString *)key;

- (void) rebuildOrderedTracks;

@property(readonly) NSMutableArray* mutableOrderedTracks;

- (NSRange) rangeForCollectionKey:(NSString *)key;
- (NSRange) setLength:(NSInteger)len forCollectionKey:(NSString *)key;
- (NSRange) setLengthByDelta:(NSInteger)delta forCollectionKey:(NSString *)key;
- (NSIndexSet *) indexesByShiftingIndexSet:(NSIndexSet *)indexes forCollectionKey:(NSString *)key;

@end


@implementation ILPartyMixList

#if DEBUG
+ (NSArray*) orderedTracksForMix:(ILPartyMix*) m;
{
	ILPartyMixList* ml = [[self new] autorelease];
	ml.mix = m;
	return ml.orderedTracks;
}
#endif

- (id) init
{
	self = [super init];
	if (self != nil) {
		mutableOrderedTracks = [NSMutableArray new];
	}
	return self;
}

- (void) dealloc
{
	[self stopObservingMix];
	[mix release];
	[mutableOrderedTracks release];
	[super dealloc];
}



- (void) beginObservingMix;
{
	ILPartyMix* m = self.mix;
	[m addObserver:self forKeyPath:@"pastTracks" options:NSKeyValueObservingOptionNew context:NULL];
	[m addObserver:self forKeyPath:@"currentTrack" options:NSKeyValueObservingOptionNew context:NULL];
	[m addObserver:self forKeyPath:@"desiredTracks" options:NSKeyValueObservingOptionNew context:NULL];
	[m addObserver:self forKeyPath:@"tracks" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) stopObservingMix;
{
	ILPartyMix* m = self.mix;
	[m removeObserver:self forKeyPath:@"pastTracks"];
	[m removeObserver:self forKeyPath:@"currentTrack"];
	[m removeObserver:self forKeyPath:@"desiredTracks"];
	[m removeObserver:self forKeyPath:@"tracks"];
}

@synthesize mix;
- (void) setMix:(ILPartyMix *) m;
{
	if (m != mix) {
		if (mix)
			[self stopObservingMix];
		[mix release];
		
		mix = [m retain];
		
		[self rebuildOrderedTracks];
		
		if (mix)
			[self beginObservingMix];
	}
}

- (void) rebuildOrderedTracks;
{
	[self willChangeValueForKey:@"orderedTracks"];
	
	NSMutableArray* a = [NSMutableArray array];
	if (self.mix) {
		[a addObjectsFromArray:self.mix.pastTracks];
		pastTracksRange = NSMakeRange(0, [self.mix.pastTracks count]);
		
		if (self.mix.currentTrack) {
			[a addObject:self.mix.currentTrack];
			currentTrackIndex = [a count] - 1;
		} else
			currentTrackIndex = NSNotFound;
		
		[a addObjectsFromArray:self.mix.desiredTracks];
		desiredTracksRange = NSMakeRange(NSMaxRange(pastTracksRange) + (self.mix.currentTrack? 1 : 0), [self.mix.desiredTracks count]);
		
		[a addObjectsFromArray:self.mix.tracks];
		tracksRange = NSMakeRange(NSMaxRange(desiredTracksRange), [self.mix.tracks count]);
	} else {
		pastTracksRange = NSMakeRange(0, 0);
		desiredTracksRange = NSMakeRange(0, 0);
		tracksRange = NSMakeRange(0, 0);
		currentTrackIndex = NSNotFound;
	}
	
	[mutableOrderedTracks setArray:a];
	
	[self didChangeValueForKey:@"orderedTracks"];
}

- (NSArray *) orderedTracks;
{
	return mutableOrderedTracks;
}

ILMutableAccessorsForApparentlyImmutableKey(OrderedTracks, mutableOrderedTracks)
ILAccessorForKVCMutableArray(mutableOrderedTracks, orderedTracks)

- (void) observeValueForKeyPath:(NSString *)key ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	// The easy way out: [self rebuildOrderedTracks];
	
	ILLogDict(self.orderedTracks, @"orderedTracksBeforeRearranging", change, @"change", key, @"changedPath");
	
	if ([key isEqual:@"currentTrack"])
		[self handleChangeToCurrentTrack:change];
	else
		[self handleChange:change toCollectionKey:key];
	
	ILLogDict(self.orderedTracks, @"orderedTracksAfterRearranging", change, @"change", key, @"changedPath");
}

- (void) handleChangeToCurrentTrack:(NSDictionary*) change;
{
	id newOne = [change objectForKey:NSKeyValueChangeNewKey];
	
	if (newOne == [NSNull null])
		newOne = nil;
	
	if (!newOne && currentTrackIndex != NSNotFound) {
		
		[self.mutableOrderedTracks removeObjectAtIndex:currentTrackIndex];
		currentTrackIndex = NSNotFound;
		desiredTracksRange.location -= 1;
		tracksRange.location -= 1;
		
	} else if (newOne && currentTrackIndex == NSNotFound) {
		
		// the index to the current track is the one after the past tracks.
		currentTrackIndex = NSMaxRange(pastTracksRange);
		desiredTracksRange.location += 1;
		tracksRange.location += 1;
		[self.mutableOrderedTracks insertObject:newOne atIndex:currentTrackIndex];
		
	} else if (newOne && currentTrackIndex != NSNotFound)
		[self.mutableOrderedTracks replaceObjectAtIndex:currentTrackIndex withObject:newOne];
	
}

- (void) handleChange:(NSDictionary*) change toCollectionKey:(NSString*) key;
{
	NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue];
	
	switch (changeKind) {
		case NSKeyValueChangeSetting:
		{
			NSRange range = [self rangeForCollectionKey:key];
			if (range.length > 0)
				[self.mutableOrderedTracks removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
			
			id newOnes = [self.mix valueForKey:key];
			range = [self setLength:[newOnes count] forCollectionKey:key];
			[self.mutableOrderedTracks insertObjects:newOnes atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
		}
			
			break;
			
		case NSKeyValueChangeRemoval:
		{
			NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
			NSIndexSet* ourIndexes = [self indexesByShiftingIndexSet:indexes forCollectionKey:key];
			
			[self setLengthByDelta:-[indexes count] forCollectionKey:key];
			[self.mutableOrderedTracks removeObjectsAtIndexes:ourIndexes];
			
		}
			
			break;
			
		case NSKeyValueChangeInsertion:
		{

			NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
			NSIndexSet* ourIndexes = [self indexesByShiftingIndexSet:indexes forCollectionKey:key];
			
			id newOnes = [change objectForKey:NSKeyValueChangeNewKey];
			
			[self setLengthByDelta:[indexes count] forCollectionKey:key];
			[self.mutableOrderedTracks insertObjects:newOnes atIndexes:ourIndexes];
		}
			
			break;
		
		case NSKeyValueChangeReplacement:
		{
			NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
			NSIndexSet* ourIndexes = [self indexesByShiftingIndexSet:indexes forCollectionKey:key];
			
			id newOnes = [change objectForKey:NSKeyValueChangeNewKey];
			
			[self.mutableOrderedTracks replaceObjectsAtIndexes:ourIndexes withObjects:newOnes];
		}
			
			break;
	}
}

- (NSIndexSet*) indexesByShiftingIndexSet:(NSIndexSet*) indexes forCollectionKey:(NSString*) key;
{
	NSRange range = [self rangeForCollectionKey:key];
	NSMutableIndexSet* ourIndexes = [NSMutableIndexSet indexSet];
	
	NSInteger i = [indexes firstIndex];
	while (i != NSNotFound) {
		[ourIndexes addIndex:range.location + i];
		i = [indexes indexGreaterThanIndex:i];
	}

	return ourIndexes;
}

- (NSRange) rangeForCollectionKey:(NSString*) key;
{
	if ([key isEqual:@"pastTracks"])
		return pastTracksRange;
	else if ([key isEqual:@"desiredTracks"])
		return desiredTracksRange;
	else if ([key isEqual:@"tracks"])
		return tracksRange;
	else {
		NSAssert(NO, @"Unknown collection key.");
		return NSMakeRange(0, 0);
	}
}

- (NSRange) setLength:(NSInteger) len forCollectionKey:(NSString*) key;
{
	if ([key isEqual:@"pastTracks"]) {
		
		pastTracksRange.length = len;
		currentTrackIndex = (currentTrackIndex == NSNotFound ?: NSMaxRange(pastTracksRange));
		desiredTracksRange.location = NSMaxRange(pastTracksRange) + (currentTrackIndex != NSNotFound? 1 : 0);
		tracksRange.location = NSMaxRange(desiredTracksRange);
		return pastTracksRange;
		
	} else if ([key isEqual:@"desiredTracks"]) {
		
		desiredTracksRange.length = len;
		tracksRange.location = NSMaxRange(desiredTracksRange);
		return desiredTracksRange;
		
	} else if ([key isEqual:@"tracks"]) {
		
		tracksRange.length = len;
		return tracksRange;
		
	} else {
		NSAssert(NO, @"Unknown collection key.");
		return NSMakeRange(0, 0);
	}
}

- (NSRange) setLengthByDelta:(NSInteger) delta forCollectionKey:(NSString*) key;
{
	NSRange r = [self rangeForCollectionKey:key];
	return [self setLength:r.length + delta forCollectionKey:key];
}

- (ILPartyTrackKind) kindOfTrackAtIndex:(NSInteger) i;
{
	if (i == NSNotFound)
		return kILPartyMixNoTrackKind;
	
	if (i == currentTrackIndex)
		return kILPartyMixCurrentTrack;
	else if (NSLocationInRange(i, pastTracksRange))
		return kILPartyMixPastTrack;
	else if (NSLocationInRange(i, desiredTracksRange))
		return kILPartyMixDesiredTrack;
	else if (NSLocationInRange(i, tracksRange))
		return kILPartyMixTrack;
	else
		return kILPartyMixNoTrackKind;
}

@end