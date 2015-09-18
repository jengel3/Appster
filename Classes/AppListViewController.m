#import "AppListViewController.h"
#import <AppList/AppList.h>
#import "AppInfo.h"
#import "AppInfoViewController.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

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
			nil];
		self.hiddenDisplayIdentifiers = result;
	}
	return result;
}

- (void) viewDidLoad {
	self.title = @"Applications";
	self.tabBarItem.image = [UIImage imageNamed:@"iTunes.png"];
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];

	UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" 
		style:UIBarButtonItemStylePlain 
		target:self
		action:@selector(showActionSheet:)];          
  self.navigationItem.rightBarButtonItem = anotherButton;

	self.appTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.appTable.dataSource = self;
	self.appTable.delegate = self;

	[self.view addSubview:self.appTable];

	[self loadApps];
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

    [mailCont setSubject:[NSString stringWithFormat:@"iTunes Application Export - %@", timestamp]];

    style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
	  [formatter setDateStyle:style];

  	timestamp = [formatter stringFromDate:now];

    [mailCont setToRecipients:nil];

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"iTunes Application Export - %@ \n\n\n", timestamp]];

    if (mode == 0) {
    	for (id key in self.appList) {
    		AppInfo *info = [[AppInfo alloc] initWithDisplay:key withApplications:self.applications];
    		[body appendString:[NSString stringWithFormat:@"%@\n", key]];
    		[body appendString:[NSString stringWithFormat:@"  Version: %@", info.version]];
    		[body appendString:@"\n\n"];
    	}
    } else if (mode == 1) {
    	for (id key in self.appList) {
    		AppInfo *info = [[AppInfo alloc] initWithDisplay:key withApplications:self.applications];
    		[body appendString:[NSString stringWithFormat:@"%@ - %@\n", key, info.version]];
    	}
    }

    [mailCont setMessageBody:body isHTML:NO];

    [self presentViewController:mailCont animated:YES completion:nil];
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) showActionSheet:(id)sender {
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

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView == self.appTable) {
		return ([self.appList count]);
	}
	return 0;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
	return 1;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	NSString *name = [self.appList objectAtIndex:indexPath.row];
	NSArray *t = [self.applications.applications allKeysForObject:name];
	NSString *identifier = [t lastObject];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.textLabel.text = name;

	cell.imageView.image = [self.applications iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:identifier];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *name = [self.appList objectAtIndex:indexPath.row];
	NSArray *t = [self.applications.applications allKeysForObject:name];
	NSString *identifier = [t lastObject];
	
	AppInfoViewController *appView = [[AppInfoViewController alloc] init];
	appView.identifier = identifier;

	UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;

	[(UINavigationController*)tabBarController.selectedViewController pushViewController:appView animated:YES];

}

- (void) loadApps {
	self.applications = nil;
	self.applications = [ALApplicationList sharedApplicationList];

	self.appList = nil;
	self.appList = [[NSMutableArray alloc] init];

	NSDictionary *raw = [self.applications applicationsFilteredUsingPredicate:nil];
	NSMutableDictionary *copy = [raw mutableCopy];

	[copy removeObjectsForKeys:[self _hiddenDisplayIdentifiers]];

	for (id key in copy) {
		NSString *val = [copy objectForKey:key];
		[self.appList addObject:val];
	}

	[self.appTable reloadData];
}


@end