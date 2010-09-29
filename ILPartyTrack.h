//
//  ILPartyTrack.h
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
	#import <UIKit/UIKit.h>
	#define ILPartyImage UIImage
#elif TARGET_OS_MAC
	#define ILPartyImage id
#endif

@protocol ILPartyArtwork <NSObject>

- (CGRect) appropriateBounds;
- (ILPartyImage*) imageOfSize:(CGSize) size; // type depends upon OS.

@end


@protocol ILPartyTrack <NSObject>

- (NSString*) title;
- (NSString*) album;

- (id <ILPartyArtwork>) artwork;

@end


#if TARGET_OS_IPHONE

#import <MediaPlayer/MediaPlayer.h>

@interface ILPartyMediaItemTrack : NSObject <ILPartyTrack> {
	MPMediaItem* mediaItem;
}

- (id) initWithMediaItem:(MPMediaItem*) item;

@property(nonatomic, readonly, assign) unsigned long long mediaItemIdentifier; // valid even if item is no longer.

@property(nonatomic, readonly, copy) NSString* title, * album;
@property(nonatomic, readonly, retain) id <ILPartyArtwork> artwork;

@end

#endif