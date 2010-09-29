//
//  ILPartyMixTable.h
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ILPartyMix.h"

@class ILPartyMixList;

@interface ILPartyMixTable : UITableViewController {
	ILPartyMixList* list;
	ILPartyMix* mix;
	
	BOOL hasSentBeginUpdates;
}

@property(nonatomic, retain) ILPartyMix* mix;

@end
