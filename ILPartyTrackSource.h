//
//  ILPartyTrackSource.h
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILPartyTrack.h"

@protocol ILPartyTrackSource <NSObject>

- (id <ILPartyTrack>) nextTrack;

@end



#if TARGET_OS_IPHONE

#import <MediaPlayer/MediaPlayer.h>

@interface ILPartyTrackMediaQuerySource : NSObject <ILPartyTrackSource>

@property(retain) MPMediaQuery* query;

@end

#endif // TARGET_OS_IPHONE