//
//  ILSensorSession.h
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ILSensorSession : NSObject {
	NSMutableDictionary* properties;
	NSSet* chans;
	BOOL didSendStarting;
	BOOL finished, didSendFinishing;
}

- (id) initWithSourceChannels:(NSSet*) chans properties:(NSDictionary*) props;

- (void) update;
- (void) setObject:(id) o forPropertyKey:(NSString*) k;
- (void) removeObjectForPropertyKey:(NSString*) k;
- (void) end;

@end

#define ILSessionEmpty() [[[ILSensorSession alloc] initWithSourceChannels:[NSSet setWithObjects:NSStringFromClass([self class]), [NSString stringWithFormat:@"%@:%p", NSStringFromClass([self class]), self], nil] properties:[NSDictionary dictionary]] autorelease]

#define ILSession(...) [[[ILSensorSession alloc] initWithSourceChannels:[NSSet setWithObjects:NSStringFromClass([self class]), [NSString stringWithFormat:@"%@:%p", NSStringFromClass([self class]), self], nil] properties:[NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]] autorelease]
