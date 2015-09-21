#import "TweakListViewController.h"
#import "TweakInfoViewController.h"
#import "Utilities.h"
#import "TweakInfo.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

float bestFit;

@implementation TweakListViewController
@synthesize tweakList;
@synthesize tweakTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Cydia Tweaks";
  }
  return self;
}

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.title = @"Cydia Tweaks";
	self.view.backgroundColor = [UIColor whiteColor];

	self.tweakTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tweakTable.dataSource = self;
	self.tweakTable.delegate = self;

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.scopeButtonTitles = @[@"Name", @"Package", @"Author"];
  self.searchController.searchBar.delegate = self;

  self.tweakTable.tableHeaderView = self.searchController.searchBar;

  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];

	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" 
		style:UIBarButtonItemStylePlain 
		target:self
		action:@selector(showActionSheet:)];          
  self.navigationItem.rightBarButtonItem = anotherButton;

	[self.view addSubview:self.tweakTable];

  self.searchResults = [[NSArray alloc] init];
	[self generateTweakInfoList];

	[self reload];
}

-(void) showActionSheet:(id) sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tweak Actions"
	  message:nil
	  preferredStyle:UIAlertControllerStyleActionSheet];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	  handler:^(UIAlertAction * action) {
	   	[self dismissViewControllerAnimated:YES completion:nil];
	  }];

	UIAlertAction* exportDetailed = [UIAlertAction actionWithTitle:@"Export (Detailed)" style:UIAlertActionStyleDefault
	  handler:^(UIAlertAction * action) {
	  	[self exportList:0];
	  }];

	UIAlertAction* exportSimple = [UIAlertAction actionWithTitle:@"Export (Simple)" style:UIAlertActionStyleDefault
	  handler:^(UIAlertAction * action) {
	  	[self exportList:1];
	  }];

	[alert addAction:cancelAction];
	[alert addAction:exportDetailed];
	[alert addAction:exportSimple];
	[self presentViewController:alert animated:YES completion:nil];
}

-(void)exportList:(int) mode {
	if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];

	  NSDateFormatterStyle style = NSDateFormatterLongStyle;

	  [formatter setTimeStyle:style];
	  [formatter setDateStyle:style];

  	NSString *timestamp = [formatter stringFromDate:now];

    [mailCont setSubject:[NSString stringWithFormat:@"Cydia Tweaks Export - %@", timestamp]];

    style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
	  [formatter setDateStyle:style];

  	timestamp = [formatter stringFromDate:now];

    [mailCont setToRecipients:nil];

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"Cydia Tweaks Export - %@<br><br>", timestamp]];

    if (mode == 0) {
    	for (TweakInfo* tweak in self.tweakData) {
    		[body appendString:[NSString stringWithFormat:@"<b>Package:</b> %@<br>", tweak.package]];
    	
    		NSArray *keys = [tweak.rawData allKeys];
    		for (id item in keys) {
    			[body appendString:[NSString stringWithFormat:@"<b>%@:</b> %@<br>", item, [tweak.rawData objectForKey:item]]];
    		}
    	
    		[body appendString:@"<br>"];
    	}
    } else if (mode == 1) {
    	for (TweakInfo* tweak in self.tweakData) {
    		NSString *name = tweak.name;
    		NSString *version = tweak.version;
    		if (!version) version = @"N/A";

    		[body appendString:[NSString stringWithFormat:@"<b>%@:</b> %@<br>", name, version]];
    	}
    }

    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView != self.tweakTable)	return 0;

  if (self.searchController.active) {
    return [self.searchResults count];
  } else {
    return [self.tweakData count];
  }
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 1;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

  TweakInfo *tweak;

  if (self.searchController.active) {
    tweak = (TweakInfo*)[self.searchResults objectAtIndex:indexPath.row];
  } else {
    tweak = (TweakInfo*)[self.tweakData objectAtIndex:indexPath.row];
  }

	NSString *name = tweak.name;

	if (!name) {
		cell.textLabel.text = tweak.package;
	} else {
		cell.textLabel.text = name;
		cell.detailTextLabel.text = tweak.package;
	}

	NSString *iconPath = [tweak.rawData objectForKey:@"Icon"];
	NSString *section = tweak.section;
	bool existed = false;

	if (iconPath) {

		if ([iconPath hasPrefix:@"file://"]) {
			iconPath = [iconPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
		}
		existed = [[NSFileManager defaultManager] fileExistsAtPath:iconPath];
		if (existed) {
			UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
			if (bestFit && img.size.width > bestFit) {
				img = [Utilities imageWithImage:img scaledToWidth:bestFit];
			}
			cell.imageView.image = img;
			existed = true;
		}
	} 
	if (!existed) {
		if (!section) {
			section = @"Addons";
		}
		iconPath = [NSString stringWithFormat:@"/Applications/Cydia.app/Sections/%@.png", section];
		existed = [[NSFileManager defaultManager] fileExistsAtPath:iconPath];
		if (!existed) {
			section = @"Addons";
		}
		iconPath = [NSString stringWithFormat:@"/Applications/Cydia.app/Sections/%@", section];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
		
		img = [Utilities imageWithImage:img scaledToWidth:img.size.width/4];
		if (!bestFit) {
			bestFit = img.size.width;
		}

		cell.imageView.image = img;
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	NSString *name = cell.textLabel.text;
	NSString *pkg = cell.detailTextLabel.text;

	if (!pkg) {
		pkg = name;
	}

	TweakInfoViewController *tweakView = [[TweakInfoViewController alloc] init];
	tweakView.package = pkg;
	tweakView.name = name;
	tweakView.info = [TweakInfo tweakForProperty:@"package" withValue:pkg andData:self.tweakData];

	UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;

	[(UINavigationController*)tabBarController.selectedViewController pushViewController:tweakView animated:YES];

}

- (void)searchForText:(NSString*)searchText scope:(int)scope {
  NSString *key;
  if (scope == 0) {
    key = @"name";
  } else if (scope == 1) {
    key = @"package";
  } else if (scope == 2) {
    key = @"author";
  }
  NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K contains[c] %@", key, searchText];
  self.searchResults = [self.tweakData filteredArrayUsingPredicate:filter];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchString = searchController.searchBar.text;
  [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
  [self reload];
}

- (void)reload {
  [self.tweakTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self updateSearchResultsForSearchController:self.searchController];
}

-(NSArray*)generateTweakInfoList {
	if (!self.tweakData) {
		NSData* data = [NSData dataWithContentsOfFile:@"/var/lib/dpkg/status"];
		NSString* string = [[NSString alloc] 
			initWithBytes:[data bytes]
	   	length:[data length] 
	  	encoding:NSUTF8StringEncoding];

		self.tweakData = [[NSMutableArray alloc] init];

		NSArray* items = [string componentsSeparatedByString:@"\n"];

		NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
		NSMutableArray *keys = [[NSMutableArray alloc] init];

		for (id i in items) {
			NSString *test = [i stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([test isEqualToString:@""]) continue;
			NSRange match = [i rangeOfString:@":"];
			if (match.location == NSNotFound) continue;
			NSString *key = [i substringToIndex:match.location];
      NSString *value = [i substringFromIndex:match.location+match.length];

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

		for (id tweak in response) {
			NSDictionary *map = [response objectForKey:tweak];
			TweakInfo *info = [[TweakInfo alloc] initWithIdentifier:tweak andInfo:map];
			[self.tweakData addObject:info];
		}

    NSPredicate *filter = [NSPredicate predicateWithFormat:@"installed == 1"];
    NSArray *sorting = [self.tweakData filteredArrayUsingPredicate:filter];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.tweakData = [[sorting sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];

		self.tweakList = [response allKeys];
	}

	return self.tweakData;
}


@end