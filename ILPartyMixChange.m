//
//  ILPartyMixChange.m
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyMixChange.h"

@interface ILPartyMixChange ()

- initWithKey:(NSString*) key affectedIndexes:(NSIndexSet*) is change:(NSKeyValueChange) change;

@property(copy) NSString* key;
@property(copy) NSIndexSet* affectedIndexes;
@property(assign) NSKeyValueChange change;

@end


@interface ILPartyMixChangeRecorder ()

@property(retain) NSMutableDictionary* recordedValues;
@property(retain) ILPartyMix* mix;

@end


@implementation ILPartyMixChangeRecorder

+ (NSSet*) watchedKeys;
{
	return [NSSet setWithObjects:@"tracks", @"pastTracks", @"desiredTracks", @"currentTrack", nil];
}

- (id) initWithMix:(ILPartyMix*) mix;
{
	if ((self = [super init])) {
		self.recordedValues = [NSMutableDictionary dictionary];
		
		for (id key in [[self class] watchedKeys]) {
			
			id x = [mix valueForKey:key];
			if ([x isKindOfClass:[NSArray class]])
				x = [x copy];
			else
				x = [x retain];
			
			[self.recordedValues setObject:[x autorelease] forKey:key];
			
		}
	}
	
	return self;
}

- (void) dealloc
{
	self.recordedValues = nil;
	self.mix = nil;
	[super dealloc];
}


- (NSArray*) changes;
{
	NSMutableArray* changes = [NSMutableArray array];
	
	for (id key in [[self class] watchedKeys]) {
		
		id current = [self.mix valueForKey:key];
		id previous = [self.recordedValues objectForKey:key];
		
		if (![current isKindOfClass:[NSArray class]] && ![previous isKindOfClass:[NSArray class]]) {
			
			if (current != previous)
				[changes addObject:[[[ILPartyMixChange alloc] initWithKey:key affectedIndexes:nil change:NSKeyValueChangeSetting] autorelease]];
			continue;
			
		}
		
		NSMutableIndexSet* replaced = [NSMutableIndexSet indexSet];
		NSIndexSet
			* added = nil,
			* removed = nil;
		
		NSUInteger i = 0;
		for (id currentAtI in current) {
			
			if (i >= [previous count])
				break;

			id previousAtI = [previous objectAtIndex:i];
			
			if (currentAtI != previousAtI)
				[replaced addIndex:i];

		}
		
		if ([current count] > [previous count]) {
			added = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([previous count], [current count] - [previous count])];
		} else if ([previous count] > [current count]) {
			removed = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([current count], [previous count] - [current count])];
		}
		
		
		if (removed)
			[changes addObject:[[[ILPartyMixChange alloc] initWithKey:key affectedIndexes:removed change:NSKeyValueChangeRemoval] autorelease]];

		if ([replaced count] > 0)
			[changes addObject:[[[ILPartyMixChange alloc] initWithKey:key affectedIndexes:replaced change:NSKeyValueChangeReplacement] autorelease]];
		
		if (added)
			[changes addObject:[[[ILPartyMixChange alloc] initWithKey:key affectedIndexes:added change:NSKeyValueChangeInsertion] autorelease]];
	}
	
	return changes;
}

@synthesize recordedValues, mix;

@end


@implementation ILPartyMixChange

- (id) initWithKey:(NSString *)k affectedIndexes:(NSIndexSet *)is change:(NSKeyValueChange)c;
{
	if ((self = [super init])) {
		self.key = k;
		self.affectedIndexes = is;
		self.change = c;
	}
	
	return self;
}

- (void) dealloc
{
	self.key = nil;
	self.affectedIndexes = nil;
	[super dealloc];
}

@synthesize key, affectedIndexes, change;

@end
