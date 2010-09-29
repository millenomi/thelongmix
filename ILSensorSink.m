//
//  ILSensorSink.m
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILSensorSink.h"

@interface ILSensorSink ()

@end


@implementation ILSensorSink

- (void) logMessageWithContent:(id) plist forChannels:(NSSet*) channels;
{
	plist = [[self class] transferableObjectForObject:plist];
	
	NSLog(@" -> from %@\n\t%@", [[channels allObjects] sortedArrayUsingSelector:@selector(compare:)], plist);
}

+ (id) transferableObjectForObject:(id)object;
{
	if ([object isKindOfClass:[NSArray class]]) {
		NSMutableArray* a = [[object mutableCopy] autorelease];
		
		NSInteger len = [a count];
		for (NSInteger i = 0; i < len; i++) {
			id subObject = [a objectAtIndex:i];
			id newObject = [self transferableObjectForObject:subObject];
			if (newObject != subObject)
				[a replaceObjectAtIndex:i withObject:newObject];
		}
		
		return a;
	} else if ([object isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary* a = [[object mutableCopy] autorelease];
		NSArray* keys = [a allKeys];
		
		for (id subKey in keys) {
			id subObject = [a objectForKey:subKey];
			id newObject = [self transferableObjectForObject:subObject];
			
			id newKey = ([subKey isKindOfClass:[NSString class]]? subKey : [subKey description]);
		
			if (newObject != subObject || newKey != subKey) {
				if (newKey != subKey)
					[a removeObjectForKey:subKey];
				[a setObject:newObject forKey:subKey];
			}

		}
		
		return a;
	} else if (![object isKindOfClass:[NSString class]] && ![object isKindOfClass:[NSNumber class]] && object != [NSNull null]) {
		
		return [object respondsToSelector:@selector(descriptionForDebugging)]? [object descriptionForDebugging] : [object description];
		
	} else
		return object;
}

+ sharedSink;
{
	static id me = nil; if (!me)
		me = [self new];
	
	return me;
}

+ (void) log:(id) content atLine:(unsigned long long) line function:(const char*) functionName object:(id) object channel:(NSString*) channel;
{
	NSMutableSet* s = [NSMutableSet setWithCapacity:3];

	NSString* selfChannel = object? [NSString stringWithFormat:@"%@:%p", NSStringFromClass([object class]), object] : nil;
	NSString* classChannel = object? NSStringFromClass([object class]) : nil;
	
	if (object) {
		[s addObject:selfChannel];
		[s addObject:classChannel];
	}
	
	if (channel)
		[s addObject:channel];
	
	NSDictionary* actualContent =
		[NSDictionary dictionaryWithObjectsAndKeys:
		
		 [NSString stringWithFormat:@"%s", functionName], @"function",
		 [NSNumber numberWithUnsignedLongLong:line], @"line",
		 content ?: [NSNull null], @"content",
		 
		 nil];
	
	[[self sharedSink] logMessageWithContent:actualContent forChannels:s];
}

@end
