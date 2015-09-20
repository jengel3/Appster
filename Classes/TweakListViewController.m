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

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.title = @"Cydia Tweaks";
	self.view.backgroundColor = [UIColor whiteColor];

	self.tweakTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tweakTable.dataSource = self;
	self.tweakTable.delegate = self;

	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" 
		style:UIBarButtonItemStylePlain 
		target:self
		action:@selector(showActionSheet:)];          
  self.navigationItem.rightBarButtonItem = anotherButton;

	[self.view addSubview:self.tweakTable];

	[self generateTweakInfoList];

	[self.tweakTable reloadData];
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

	UIAlertAction* sortAction = [UIAlertAction actionWithTitle:@"Sort" style:UIAlertActionStyleDefault
	  handler:^(UIAlertAction * action) {
	  	
	  }];
 

	[alert addAction:cancelAction];
	[alert addAction:exportDetailed];
	[alert addAction:exportSimple];
	[alert addAction:sortAction];
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

	return [self.tweakList count];
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

	NSString *key = [self.tweakList objectAtIndex:indexPath.row];

	TweakInfo *tweak = [TweakInfo tweakForProperty:@"package" withValue:key andData:self.tweakData];
	NSString *name = tweak.name;

	if (!name) {
		cell.textLabel.text = key;
	} else {
		cell.textLabel.text = name;
		cell.detailTextLabel.text = key;
	}

	NSString *iconPath = [tweak.rawData objectForKey:@"Icon"];
	NSString *section = tweak.version;
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

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    self.searchResults = [self.tweakData filteredArrayUsingPredicate:filter];
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

		self.tweakList = [response allKeys];
	}

	return self.tweakData;
}


@end