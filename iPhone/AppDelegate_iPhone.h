//
//  AppDelegate_iPhone.h
//  Party
//
//  Created by ∞ on 20/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>

#import "ILPartyMix.h"
#import "ILPartyMixTable.h"
#import "ILPartyPlayer.h"

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UINavigationController* navigationController;
	IBOutlet ILPartyMixTable* mixListController; // TODO
	
	IBOutlet UIView* navigationControllerHostView;
}

@property(nonatomic, retain) ILPartyMix* mix;
@property(nonatomic, retain) ILPartyPlayer* player;

- (IBAction) next;

@end

