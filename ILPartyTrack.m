//
//  ILPartyTrack.m
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyTrack.h"

#if TARGET_OS_IPHONE

@interface ILPartyMediaItemTrack () <ILPartyArtwork>

@property(nonatomic, retain) MPMediaItem* mediaItem;
@property(nonatomic, assign) unsigned long long mediaItemIdentifier;

@end


@implementation ILPartyMediaItemTrack

- (id) initWithMediaItem:(MPMediaItem *)item;
{
	if ((self = [super init])) {
		self.mediaItem = item;
		self.mediaItemIdentifier = [[item valueForProperty:MPMediaItemPropertyPersistentID] unsignedLongLongValue];
	}
	
	return self;
}

- (void) dealloc
{
	[mediaItem release];
	[super dealloc];
}

@synthesize mediaItem, mediaItemIdentifier;

- (NSString *) title;
{
	return [mediaItem valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *) album;
{
	return [mediaItem valueForProperty:MPMediaItemPropertyAlbumTitle];
}

- (id <ILPartyArtwork>) artwork;
{
	return self;
}

- (CGRect) appropriateBounds;
{
	MPMediaItemArtwork* artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
	if (!artwork)
		return CGRectNull;
	else
		return artwork.imageCropRect;
}

- (UIImage*) imageOfSize:(CGSize) size;
{
	return [[mediaItem valueForProperty:MPMediaItemPropertyArtwork] imageOfSize:size];
}

- (NSString *) descriptionForDebugging;
{
	return [NSString stringWithFormat:@"<%@ (%p - '%@' [%llu])>", NSStringFromClass([self class]), self, self.title, self.mediaItemIdentifier];
}

@end

#endif // TARGET_OS_IPHONE
