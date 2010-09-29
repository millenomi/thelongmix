//
//  ILPartyPlayer.h
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILPartyMix.h"
#import "ILPartyTrack.h"

#if TARGET_OS_IPHONE

@interface ILPartyPlayer : NSObject {
	id <ILPartyMediaItemTrack> nowPlayingTrack;
	BOOL playing;
}

- (void) play;
- (void) pause;

@property(nonatomic, retain) ILPartyMix* mix;

@end

#endif
