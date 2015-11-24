#import "TweakListViewController.h"
#import "TweakInfoViewController.h"
#import "../Utilities.h"
#import "TweakInfo.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "../MBProgressHud/MBProgressHUD.h"
#import "../Settings.h"

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

	self.tweakTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	self.tweakTable.dataSource = self;
	self.tweakTable.delegate = self;

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.scopeButtonTitles = @[@"Name", @"Package", @"Author"];
  self.searchController.searchBar.delegate = self;

  self.tweakTable.tableHeaderView = self.searchController.searchBar;

  self.tweakTable.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height);

  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];

  [self loadSourcesList];

	UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" 
		style:UIBarButtonItemStylePlain 
		target:self
		action:@selector(showActionSheet:)];          
  self.navigationItem.rightBarButtonItem = actionsButton;

  UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" 
    style:UIBarButtonItemStylePlain 
    target:self
    action:@selector(showSortMenu:)];          
  self.navigationItem.leftBarButtonItem = sortButton;


	[self.view addSubview:self.tweakTable];

  self.searchResults = [[NSArray alloc] init];
	[self generateTweakInfoList];

	[self reload];
}

-(void)showSortMenu:(id)sender {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tweak Actions"
    message:nil
    preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * action) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }];

  UIAlertAction* alphaAscending = [UIAlertAction actionWithTitle:@"Alpha (A-Z)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:1];
    }];

  UIAlertAction* alphaDescending = [UIAlertAction actionWithTitle:@"Alpha (Z-A)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:2];
    }];

  UIAlertAction* author = [UIAlertAction actionWithTitle:@"Developer (A-Z)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:3];
    }];

  UIAlertAction* package = [UIAlertAction actionWithTitle:@"Package (A-Z)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:4];
    }];

  [alert addAction:cancelAction];
  [alert addAction:alphaAscending];
  [alert addAction:alphaDescending];
  [alert addAction:author];
  [alert addAction:package];
  [self presentViewController:alert animated:YES completion:nil];
}

-(void)sortContent:(int)sort {
  NSString *key;
  BOOL asc = YES;
  if (sort == 1) {
    key = @"name";
  } else if (sort == 2) {
    key = @"name";
    asc = NO;
  } else if (sort == 3) {
    key = @"author";
  } else if (sort == 4) {
    key = @"package";
  }
  NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:asc];
  self.tweakData = [[self.tweakData sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];

  [self.tweakTable reloadData]; 
}

-(void)loadSourcesList {
  NSString *sourcesDir = @"/etc/apt/sources.list.d";
  NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcesDir error:NULL];
  NSMutableArray *rawSources = [[NSMutableArray alloc] init];
  [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *filename = (NSString *)obj;
    NSString *extension = [[filename pathExtension] lowercaseString];
    if ([extension isEqualToString:@"list"]) {
      NSString *path = [sourcesDir stringByAppendingPathComponent:filename];
      NSData* data = [NSData dataWithContentsOfFile:path];
      NSString* string = [[NSString alloc] 
        initWithBytes:[data bytes]
        length:[data length] 
        encoding:NSUTF8StringEncoding];

      NSArray* lines = [string componentsSeparatedByString:@"\n"];
      for (NSString *line in lines) {
        if (!line || [line isEqualToString:@""] || [line hasPrefix:@"#"]) continue;
        NSArray *pieces = [line componentsSeparatedByString:@" "];
        NSString *url = pieces[1];
        [rawSources addObject:url];
      }
    }
  }];
  self.sources = [rawSources copy];
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

	  NSDateFormatterStyle style = NSDateFormatterShortStyle;

	  [formatter setTimeStyle:style];
	  [formatter setDateStyle:style];

  	NSString *timestamp = [formatter stringFromDate:now];

    [mailCont setSubject:[NSString stringWithFormat:@"Cydia Tweaks Export - %@", timestamp]];

    style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
	  [formatter setDateStyle:style];

  	timestamp = [formatter stringFromDate:now];

    AppsterSettings *settings = [[AppsterSettings alloc] init];
    NSString *defaultEmail = [settings valueForKey:@"default_email"];
    if (defaultEmail) {
      [mailCont setToRecipients:@[defaultEmail]];
    } else {
      [mailCont setToRecipients:nil];
    }


    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"Cydia Tweaks Export - %@<br><br>", timestamp]];

    [body appendString:@"<b>Sources:</b><br>"];

    for (id source in self.sources) {
      [body appendString:[NSString stringWithFormat:@"%@<br>", source]];  
    }

    [body appendString:@"<br><b>Packages:</b><br><br>"];

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
    if (section == 0) {
      return [self.sources count];
    } else {
      return [self.tweakData count];
    }
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.searchController.active) return nil;
  if (section == 0) {
    return @"Sources";
  } else if (section == 1) {
    return @"Installed Tweaks";
  }
  return nil;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  if (self.searchController.active) {
    return 1;
  } else {
    return 2;
  }
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
    if (indexPath.section == 0) {
      NSString *source = [self.sources objectAtIndex:indexPath.row];
      cell.textLabel.text = source;
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"/Applications/Cydia.app/Sections/Repositories.png"];
    
      img = [Utilities imageWithImage:img scaledToWidth:img.size.width/4];
      cell.imageView.image = img;
      cell.detailTextLabel.text = nil;
      cell.accessoryType = 0;
      if (!bestFit) {
        bestFit = img.size.width;
      }

      cell.imageView.image = img;
      return cell;
    } else if (indexPath.section == 1) {
      tweak = (TweakInfo*)[self.tweakData objectAtIndex:indexPath.row];
    }
  }

	NSString *name = tweak.name;

	if (!name) {
		cell.textLabel.text = tweak.package;
	} else {
		cell.textLabel.text = name;
		cell.detailTextLabel.text = tweak.package;
	}

	UIImage *icon = [tweak getIcon:bestFit];

  if (!bestFit && icon) {
    bestFit = icon.size.width;
  }
  cell.imageView.image = icon;

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  if (!self.searchController.active && indexPath.section == 0) {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.textLabel.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Copied!";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hide:YES afterDelay:0.5];
    return;
  }

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
    self.tweakData = [[self.tweakData filteredArrayUsingPredicate:filter] mutableCopy];

    AppsterSettings *settings = [[AppsterSettings alloc] init];

    NSString *sortKey = [settings valueForKey:@"tweaks_default_sort" orDefault:@"alpha_asc"];
    int intKey = [Utilities sortForKey:sortKey];
    [self sortContent:intKey];

		self.tweakList = [response allKeys];
	}

	return self.tweakData;
}


@end