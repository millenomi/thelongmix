//
//  ILPartyMixChange.h
//  TheLongMix
//
//  Created by ∞ on 29/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILPartyMix;


@interface ILPartyMixChangeRecorder : NSObject {}

- (id) initWithMix:(ILPartyMix*) mix;

@property(readonly) NSArray* changes;

@end

@interface ILPartyMixChange : NSObject {}

@property(readonly, copy) NSString* key;
@property(readonly, copy) NSIndexSet* affectedIndexes;
@property(readonly, assign) NSKeyValueChange change;

@end
