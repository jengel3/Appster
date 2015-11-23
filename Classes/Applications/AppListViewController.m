#import "AppListViewController.h"
#import <AppList/AppList.h>
#import "AppInfo.h"
#import "AppInfoViewController.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "../Settings.h"

@implementation AppListViewController
@synthesize appList;
@synthesize appTable;
@synthesize applications;

- (NSArray *)_hiddenDisplayIdentifiers {
	NSArray *result = self.hiddenDisplayIdentifiers;
	if (!result) {
		result = [[NSArray alloc] initWithObjects:
			@"com.apple.AdSheet",
			@"com.apple.AdSheetPhone",
			@"com.apple.AdSheetPad",
			@"com.apple.CloudKit.ShareBear",
			@"com.apple.DataActivation",
			@"com.apple.DemoApp",
			@"com.apple.Diagnostics",
			@"com.apple.fieldtest",
			@"com.apple.iosdiagnostics",
			@"com.apple.iphoneos.iPodOut",
			@"com.apple.TrustMe",
			@"com.apple.WebSheet",
			@"com.apple.springboard",
			@"com.apple.purplebuddy",
			@"com.apple.datadetectors.DDActionsService",
			@"com.apple.FacebookAccountMigrationDialog",
			@"com.apple.iad.iAdOptOut",
			@"com.apple.ios.StoreKitUIService",
			@"com.apple.TextInput.kbd",
			@"com.apple.MailCompositionService",
			@"com.apple.mobilesms.compose",
			@"com.apple.quicklook.quicklookd",
			@"com.apple.ShoeboxUIService",
			@"com.apple.social.SLGoogleAuth",
			@"com.apple.social.remoteui.SocialUIService",
			@"com.apple.WebViewService",
			@"com.apple.gamecenter.GameCenterUIService",
			@"com.apple.appleaccount.AACredentialRecoveryDialog",
			@"com.apple.CompassCalibrationViewService",
			@"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
			@"com.apple.PassbookUIService",
			@"com.apple.uikit.PrintStatus",
			@"com.apple.Copilot",
			@"com.apple.MusicUIService",
			@"com.apple.AccountAuthenticationDialog",
			@"com.apple.MobileReplayer",
			@"com.apple.SiriViewService",
			@"com.apple.TencentWeiboAccountMigrationDialog",
			@"com.apple.AskPermissionUI",
			@"com.apple.CoreAuthUI",
			@"com.apple.family",
			@"com.apple.mobileme.fmip1",
			@"com.apple.GameController",
			@"com.apple.HealthPrivacyService",
			@"com.apple.InCallService",
			@"com.apple.mobilesms.notification",
			@"com.apple.PhotosViewService",
			@"com.apple.PreBoard",
			@"com.apple.PrintKit.Print-Center",
			@"com.apple.share",
			@"com.apple.SharedWebCredentialViewService",
			@"com.apple.webapp",
			@"com.apple.webapp1",
      @"com.apple.ServerDocuments",
      @"com.apple.social.SLYahooAuth",
      @"com.apple.Diagnostics.Mitosis",
      @"com.apple.SafariViewService",
      @"com.apple.StoreDemoViewService",
			nil];
		self.hiddenDisplayIdentifiers = result;
	}
	return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Applications";
  }
  return self;
}

- (void)viewDidLoad {
	self.tabBarItem.image = [UIImage imageNamed:@"iTunes.png"];
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];

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

	self.appTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	self.appTable.dataSource = self;
	self.appTable.delegate = self;

  self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
  self.searchController.searchResultsUpdater = self;
  self.searchController.dimsBackgroundDuringPresentation = NO;
  self.searchController.searchBar.scopeButtonTitles = @[@"Name", @"Identifier"];
  self.searchController.searchBar.delegate = self;

  self.appTable.tableHeaderView = self.searchController.searchBar;

  self.appTable.contentOffset = CGPointMake(0, self.searchController.searchBar.frame.size.height);

  self.definesPresentationContext = YES;
  [self.searchController.searchBar sizeToFit];

  self.searchResults = [[NSArray alloc] init];

	[self.view addSubview:self.appTable];

	[self loadApps];

  if ([self.appList count] == 0) {
    // load again in case applist is being buggy
    [self loadApps];
  }
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

  UIAlertAction* developer = [UIAlertAction actionWithTitle:@"Developer (A-Z)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:3];
    }];

  UIAlertAction* identifier = [UIAlertAction actionWithTitle:@"Identifier (A-Z)" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self sortContent:4];
    }];

  [alert addAction:cancelAction];
  [alert addAction:alphaAscending];
  [alert addAction:alphaDescending];
  [alert addAction:developer];
  [alert addAction:identifier];
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
    key = @"artist";
  } else if (sort == 4) {
    key = @"identifier";
  }
  NSSortDescriptor *descriptor = [[NSSortDescriptor alloc]
    initWithKey:key
    ascending:asc
    selector:@selector(localizedCaseInsensitiveCompare:)];
  self.mobileApps = [[self.mobileApps sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
  self.systemApps = [[self.systemApps sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
  self.appList = [[self.appList sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];

  [self.appTable reloadData]; 
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

    [mailCont setSubject:[NSString stringWithFormat:@"iTunes Application Export - %@", timestamp]];

    AppsterSettings *settings = [[AppsterSettings alloc] init];
    NSString *defaultEmail = [settings valueForKey:@"default_email"];
    if (defaultEmail) {
      [mailCont setToRecipients:@[defaultEmail]];
    } else {
      [mailCont setToRecipients:nil];
    }

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"iTunes Application Export - %@ <br><br><br>", timestamp]];
    NSArray *apps;

    BOOL exportSystem = [[settings valueForKey:@"export_system" orDefault:false] boolValue];

    if (exportSystem) {
      apps = self.appList;
    } else {
      apps = self.mobileApps;
    }

    if (mode == 0) {
    	for (AppInfo* app in apps) {
    		[body appendString:[NSString stringWithFormat:@"<b>%@ - %@</b><br>", app.name, (app.version ? app.version : app.bundleVersion)]];
        [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;<i>Identifier:</i> %@<br>", app.identifier]];
        if (![app isSystem]) {
          [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;<i>App ID:</i> %@<br>", app.pk]];
          [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;<i>Developer:</i> %@<br>", app.artist]];
          [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;<i>Purchase Date:</i> %@<br>", app.purchaseDate]];
          [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;<i>Purchaser:</i> %@<br>", app.purchaserAccount]];
        }
    		[body appendString:@"<br><br>"];
    	}
    } else if (mode == 1) {
    	for (AppInfo* app in apps) {
    		[body appendString:[NSString stringWithFormat:@"<b>%@</b> - %@<br>", app.name, (app.version ? app.version : app.bundleVersion)]];
    	}
    }

    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showActionSheet:(id)sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"App Actions"
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

- (NSInteger)tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView != self.appTable) return 0;
  if (self.searchController.active) {
    return [self.searchResults count];
  }
  if (section == 0) {
    return [self.mobileApps count];
  } else if (section == 1) {
    return [self.systemApps count];
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView * ) tableView {
  if (self.searchController.active) {
    return 1;
  }
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (self.searchController.active) return nil;
  if (section == 0) {
    return @"Mobile Apps";
  } else if (section == 1) {
    return @"System Apps";
  }
  return nil;
}

- (UITableViewCell * )tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath * )indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

  AppInfo *app;
  if (self.searchController.active) {
    app = (AppInfo*)[self.searchResults objectAtIndex:indexPath.row];
  } else if (indexPath.section == 0) {
    app = (AppInfo*)[self.mobileApps objectAtIndex:indexPath.row];
  } else if (indexPath.section == 1) {
    app = (AppInfo*)[self.systemApps objectAtIndex:indexPath.row];
  }

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = app.name;

	cell.imageView.image = [self.applications iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:app.identifier];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
  AppInfo *app;
  if (self.searchController.active) {
    app = (AppInfo*)[self.searchResults objectAtIndex:indexPath.row];
  } else if (indexPath.section == 0) {
    app = (AppInfo*)[self.mobileApps objectAtIndex:indexPath.row];
  } else if (indexPath.section == 1) {
    app = (AppInfo*)[self.systemApps objectAtIndex:indexPath.row];
  }
	
	AppInfoViewController *appView = [[AppInfoViewController alloc] init];
  app.icon = [self.applications iconOfSize:ALApplicationIconSizeLarge forDisplayIdentifier:app.identifier];
	appView.appInfo = app;

	UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;

	[(UINavigationController*)tabBarController.selectedViewController pushViewController:appView animated:YES];

}

- (void)searchForText:(NSString*)searchText scope:(int)scope {
  NSString *key;
  if (scope == 0) {
    key = @"name";
  } else if (scope == 1) {
    key = @"identifier";
  }
  NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K contains[c] %@", key, searchText];
  self.searchResults = [self.appList filteredArrayUsingPredicate:filter];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
  NSString *searchString = searchController.searchBar.text;
  [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
  [self.appTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self updateSearchResultsForSearchController:self.searchController];
}

- (void)loadApps {
	self.applications = [ALApplicationList sharedApplicationList];

	NSMutableArray *apps = [[NSMutableArray alloc] init];

	NSDictionary *raw = [self.applications applicationsFilteredUsingPredicate:nil];
	NSMutableDictionary *copy = [raw mutableCopy];

	[copy removeObjectsForKeys:[self _hiddenDisplayIdentifiers]];

	for (id key in copy) {
    AppInfo *app = [[AppInfo alloc] initWithIndentifier:key withApplications:self.applications];
		[apps addObject:app];
	}

  NSArray *sorted = [apps sortedArrayUsingComparator: ^(AppInfo *a, AppInfo *b) {
    return [a.name compare:b.name];
  }];
  
  self.appList = [sorted mutableCopy];

  self.systemApps = [[NSMutableArray alloc] init];
  self.mobileApps = [[NSMutableArray alloc] init];

  for (AppInfo* app in self.appList) {
    if ([app.type isEqualToString:@"System"]) {
      [self.systemApps addObject:app];
    } else {
      [self.mobileApps addObject:app];
    }
  }

	[self.appTable reloadData];
}
@end