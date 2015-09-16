#import "TweakListViewController.h"

@implementation TweakListViewController
@synthesize tweakList;
@synthesize tweakTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Cydia Tweaks";
    }
    return self;
}

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];

	self.tweakTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tweakTable.dataSource = self;
	self.tweakTable.delegate = self;

	[self.view addSubview:self.tweakTable];

	[self generateTweakInfoList];

	[self loadApps];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView != self.tweakTable)	return 0;

	return [self.tweakMap count];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
	return 1;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}


	NSString *key = [self.tweakList objectAtIndex:indexPath.row];

	NSDictionary *tweak = (NSDictionary*)[self.tweakMap objectForKey:key];
	cell.textLabel.text = [tweak objectForKey:@"Name"];
	cell.detailTextLabel.text = key;

	return cell;
}

- (void) loadApps {
	[self generateTweakInfoList];

	[self.tweakTable reloadData];
}

-(NSDictionary*)generateTweakInfoList {
	if (!self.tweakMap) {
		NSData* data = [NSData dataWithContentsOfFile:@"/var/lib/dpkg/status"];
		NSString* string = [[NSString alloc] 
			initWithBytes:[data bytes]
	   	length:[data length] 
	  	encoding:NSUTF8StringEncoding];

		NSArray* items = [string componentsSeparatedByString:@"\n"];

		NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
		NSMutableArray *keys = [[NSMutableArray alloc] init];

		for (id i in items) {
			NSString *test = [i stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([test isEqualToString:@""]) continue;
			NSArray *pieces = [i componentsSeparatedByString:@":"];
			if ([pieces count] != 2) continue;
			NSString *key = pieces[0];
			NSString *value = pieces[1];

			value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

			if ([key isEqualToString:@"Package"]) {
				[keys addObject:value];
				[response setValue:[[NSMutableDictionary alloc] init] forKey:value];
			} else {
				NSString *lastKey = [keys lastObject];
				[[response objectForKey:lastKey] setObject:value forKey:key];
			}

		}

		NSMutableArray *removed = [[NSMutableArray alloc] init];
		for (id key in response) {
			if ([key hasPrefix:@"gsc."]) {
				[removed addObject:key];
			}
		}

		for (id r in removed) {
			[response removeObjectForKey:r];
		}
	
		self.tweakMap = response;
		self.tweakList = [response allKeys];
	}

	return self.tweakMap;
}


@end