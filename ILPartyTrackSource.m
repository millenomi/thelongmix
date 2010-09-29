//
//  ILPartyTrackSource.m
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyTrackSource.h"

#if TARGET_OS_IPHONE

@implementation ILPartyTrackMediaQuerySource

- (void) dealloc
{
	self.query = nil;
	[super dealloc];
}


@synthesize query;

- (id <ILPartyTrack>) nextTrack;
{
	if (!self.query || [self.query.items count] == 0)
		return nil;
	
	MPMediaItem* item = [self.query.items objectAtIndex:(arc4random() % [self.query.items count])];
	return [[[ILPartyMediaItemTrack alloc] initWithMediaItem:item] autorelease];
}

@end

#endif // TARGET_OS_IPHONE