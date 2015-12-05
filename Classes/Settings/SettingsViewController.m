#import "SettingsViewController.h"
#import "../../appstersettings/AppsterSettings.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/SLComposeViewController.h>
#import <Social/SLServiceTypes.h>

@implementation SettingsViewController
@synthesize settingsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Settings";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.settingsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.settingsTable.dataSource = self;
  self.settingsTable.delegate = self;


  UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
    target:self
    action:@selector(writeTweet:)];
  self.navigationItem.rightBarButtonItem = shareButton;


  // setup table header
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, self.view.bounds.size.width - 90 - 20, 30)];
  UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, self.view.bounds.size.width - 90 - 20, 50)];
  headerLabel.text = @"Appster";
  headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  descLabel.text = @"by: Jake0oo0 & AOkhtenberg";
  descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
  descLabel.lineBreakMode = NSLineBreakByWordWrapping;
  descLabel.numberOfLines = 2;
  [headerView addSubview:headerLabel];
  [headerView addSubview:descLabel];
  [imageView setImage:[UIImage imageNamed:@"Icon.png"]];
  [headerView addSubview:imageView];
  self.settingsTable.tableHeaderView = headerView;

  [self.view addSubview:self.settingsTable];

  [self.settingsTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 1;
  } else if (section == 1) {
    return 4;
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Settings";
  } else if (section == 1) {
    return @"Support";
  }
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }

  int section = (int)indexPath.section;
  int row = (int)indexPath.row;

  if (section == 0) {
    if (row == 0) {
      cell.textLabel.text = @"Preferences";
      cell.imageView.image = [UIImage imageNamed:@"SettingsIcon.png"];
    }
  } else if (section == 1) {
    if (row == 0) {
      cell.textLabel.text = @"Send Email";
      cell.imageView.image = [UIImage imageNamed:@"Mail.png"];
    } else if (row == 1) {
      cell.textLabel.text = @"Jake0oo0";
      cell.detailTextLabel.text = @"Developer";
      cell.imageView.image = [UIImage imageNamed:@"TwitterIcon.png"];
    } else if (row == 2) {
      cell.textLabel.text = @"AOkhtenberg";
      cell.detailTextLabel.text = @"Designer";
      cell.imageView.image = [UIImage imageNamed:@"TwitterIcon.png"];
    } else if (row == 3) {
      cell.textLabel.text = @"Donate";
      cell.imageView.image = [UIImage imageNamed:@"PayPal.png"];
    }
  }

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  int section = (int)indexPath.section;
  int row = (int)indexPath.row;

  if (section == 0) {
    if (row == 0) {
      UIViewController *settings = (UIViewController *)[[AppsterSettingsListController alloc] init];

      [self.navigationController pushViewController:settings animated:YES];
    }
  } else if (section == 1) {
    if (row == 0) {
      [self contact];
    } else if (row == 1) {
      [self openTwitter:@"itsjake88"];
    } else if (row == 2) {
      [self openTwitter:@"AOkhtenberg"];
    } else if (row == 3) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/itsjake"]];
    }
  }
}

- (void)writeTweet:(id)sender {
  SLComposeViewController *composeController = [SLComposeViewController
    composeViewControllerForServiceType:SLServiceTypeTwitter];
  [composeController setInitialText:@"I'm using #Appster by @itsjake88 to export content from my iDevice. Check it out!"];
  [self presentViewController:composeController animated:YES completion:nil];
}

- (void)openTwitter:(NSString *)username {
  if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetbot:///user_profile/" stringByAppendingString:username]]];
  } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitterrific:///profile?screen_name=" stringByAppendingString:username]]];
  } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tweetings:///user?screen_name=" stringByAppendingString:username]]];
  } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"twitter://user?screen_name=" stringByAppendingString:username]]];
  } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"https://mobile.twitter.com/" stringByAppendingString:username]]];
  }
}

- (void)contact {
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];

    NSDateFormatterStyle style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
    [formatter setDateStyle:style];

    NSString *timestamp = [formatter stringFromDate:now];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];

    [mailCont setSubject:[NSString stringWithFormat:@"Appster Support: v%@", majorVersion]];

    [mailCont setToRecipients:@[@"jake0oo0dev@gmail.com"]];

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"<br><br><br>Sent from Appster at %@", timestamp]];
    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end