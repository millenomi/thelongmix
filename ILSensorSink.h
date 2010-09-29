//
//  ILSensorSink.h
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ILSensorSink : NSObject {}

+ sharedSink;

- (void) logMessageWithContent:(id) plistPart forChannels:(NSSet*) channels;

+ (void) log:(id) content atLine:(unsigned long long) line function:(const char*) functionName object:(id) object channel:(NSString*) channel;

+ (id) transferableObjectForObject:(id) object;

@end

#define ILLogDict(...) \
	[ILSensorSink log:([NSDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]) atLine:__LINE__ function:__PRETTY_FUNCTION__ object:(self) channel:(nil)]


@interface NSObject (ILSensorDebuggingDescription)

- (id) descriptionForDebugging;

@end
