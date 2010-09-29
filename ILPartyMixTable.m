//
//  ILPartyMixTable.m
//  Party
//
//  Created by ∞ on 24/09/10.
//  Copyright 2010 Emanuele Vulcano (Infinite Labs). All rights reserved.
//

#import "ILPartyMixTable.h"

#import "ILPartyMixList.h"

@interface ILPartyMixTable ()

- (NSArray *) indexPathsForRowsAtIndexes:(NSIndexSet *)indexes inSection:(NSInteger)section;

@end


@implementation ILPartyMixTable

- (void) dealloc
{
	[list removeObserver:self forKeyPath:@"orderedTracks"];
	[list release];
	[mix release];
	[super dealloc];
}

@synthesize mix;
- (void) setMix:(ILPartyMix *) m;
{
	if (m != mix) {
		[mix release];
		mix = [m retain];
		
		if (mix) {
			if (!list) {
				list = [[ILPartyMixList alloc] init];
				[list addObserver:self forKeyPath:@"orderedTracks" options:NSKeyValueObservingOptionPrior context:NULL];
			}
			
			list.mix = mix;
		}
		
		if ([self isViewLoaded])
			[self.tableView reloadData];
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
	return list? [list.orderedTracks count] : 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	// TODO <#until we have an actual UITableViewCell subclass that does it right.#>
#define kILPartyMixTableCellReuseID @"Cell"
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kILPartyMixTableCellReuseID];
	if (!cell)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kILPartyMixTableCellReuseID] autorelease];
	
	id <ILPartyTrack> track = [list.orderedTracks objectAtIndex:[indexPath row]];
	
	cell.textLabel.text = track.title;
	cell.detailTextLabel.text = track.album;
	
	switch ([list kindOfTrackAtIndex:[indexPath row]]) {
		case kILPartyMixPastTrack:
			cell.textLabel.textColor = [UIColor grayColor];
			break;
		case kILPartyMixDesiredTrack:
			cell.textLabel.textColor = [UIColor redColor];
			break;
		case kILPartyMixCurrentTrack:
			cell.textLabel.textColor = [UIColor blueColor];
			break;
		default:
			cell.textLabel.textColor = [UIColor blackColor];
			break;
	}
	
	return cell;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	if (![self isViewLoaded])
		return;
		
	NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] unsignedIntegerValue];
	
	BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];

	if (changeKind == NSKeyValueChangeSetting) {
		if (!isPrior)
			[self.tableView reloadData];
		return;
	}

	if (isPrior) {
		[self.tableView beginUpdates];
		hasSentBeginUpdates = YES;
		return;
	}
	
	NSIndexSet* indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
	
	switch (changeKind) {
		case NSKeyValueChangeRemoval:
			[self.tableView deleteRowsAtIndexPaths:[self indexPathsForRowsAtIndexes:indexes inSection:0] withRowAnimation:UITableViewRowAnimationTop];
			break;
			
		case NSKeyValueChangeInsertion:
			[self.tableView insertRowsAtIndexPaths:[self indexPathsForRowsAtIndexes:indexes inSection:0] withRowAnimation:UITableViewRowAnimationTop];
			break;
			
		case NSKeyValueChangeReplacement:
			[self.tableView reloadRowsAtIndexPaths:[self indexPathsForRowsAtIndexes:indexes inSection:0] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
	
	if (hasSentBeginUpdates) {
		[self.tableView endUpdates];
		hasSentBeginUpdates = NO;
	}
}

- (NSArray*) indexPathsForRowsAtIndexes:(NSIndexSet*) indexes inSection:(NSInteger) section;
{
	NSMutableArray* a = [NSMutableArray arrayWithCapacity:[indexes count]];
	NSInteger i = [indexes firstIndex];
	while (i != NSNotFound) {
		[a addObject:[NSIndexPath indexPathForRow:i inSection:section]];
		i = [indexes indexGreaterThanIndex:i];
	}
	
	return a;
}

@end

