//
//  AppDelegate_iPhone.m
//  Party
//
//  Created by ∞ on 20/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "AppDelegate_iPhone.h"

#import "ILPartyTrackSource.h"

@implementation AppDelegate_iPhone

@synthesize mix;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    UIView* v = navigationController.view;
	[navigationController viewWillAppear:NO];
	v.frame = navigationControllerHostView.bounds;
	[navigationControllerHostView addSubview:v];
	[navigationController viewDidAppear:NO];
	
	self.mix = [ILPartyMix mix];
	mixListController.mix = self.mix;

	// <TEST>
	ILPartyTrackMediaQuerySource* source = [ILPartyTrackMediaQuerySource new];
	source.query = [MPMediaQuery songsQuery];
	
	NSMutableArray* a = [NSMutableArray array];
	NSInteger i; for (i = 0; i < 10; i++) {
		id track = [source nextTrack];
		if (track)
			[a addObject:track];
	}
	
	[self.mix.mutableTracks setArray:a];
	// </TEST>
	
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
