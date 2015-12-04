#import "TweakInfoViewController.h"
#import "../Utilities.h"
#import "../MBProgressHud/MBProgressHUD.h"
#import "TweakInfo.h"
#import "InstalledFilesViewController.h"
#import "../Settings.h"

@implementation TweakInfoViewController
@synthesize package;
@synthesize name;
@synthesize info;
@synthesize infoTable;

- (void)viewDidLoad {
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  UIBarButtonItem *exportBtn = [[UIBarButtonItem alloc] initWithTitle:@"Export"
    style:UIBarButtonItemStylePlain 
    target:self
    action:@selector(showExport:)];
  self.navigationItem.rightBarButtonItem = exportBtn;

  self.infoTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.infoTable.dataSource = self;
  self.infoTable.delegate = self;

  self.delegate = self;

  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 7, self.view.bounds.size.width - 90 - 20, 30)];
  UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, self.view.bounds.size.width - 90 - 20, 50)];
  headerLabel.text = self.info.name;
  headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  descLabel.text = self.info.description;
  descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
  descLabel.lineBreakMode = NSLineBreakByWordWrapping;
  descLabel.numberOfLines = 2;
  [headerView addSubview:headerLabel];
  [headerView addSubview:descLabel];
  [imageView setImage:[self.info getIcon:60]];
  [headerView addSubview:imageView];
  self.infoTable.tableHeaderView = headerView;

  [self.view addSubview:self.infoTable];
}

-(NSString*)getBody:(int)mode {
  NSMutableString *body = [[NSMutableString alloc] init];

  NSArray *keys = [self.info.rawData allKeys];

  [body appendString:[NSString stringWithFormat:@"<b>%@</b><br><br>", self.name ? self.name : self.package]];

  [body appendString:[NSString stringWithFormat:@"<b>Package:</b> %@<br>", self.package]];

  for (id key in keys) {
    if ([key isEqualToString:@"Name"]) continue;

    [body appendString:[NSString stringWithFormat:@"<b>%@</b>: %@<br>", key, [self.info.rawData objectForKey:key]]];
  }

  return body;
}

-(NSString*)getSubject {
  return @"Cydia Tweak Export %@";
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (section == 0) {
    return 4;
  } else if (section == 1) {
    return 5;
  } else if (section == 2) {
    return 5;
  }
  return 0;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Tweak Info";
  } else if (section == 1) {
    return @"About";
  } else if (section == 2) {
    return @"Links";
  }
  return nil;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
  static NSString *InfoCellID = @"InfoCell";
  static NSString *SubCellID = @"SubCell";

  UITableViewCell *cell;

  if (indexPath.section <= 1) {
    cell = [tableView dequeueReusableCellWithIdentifier:InfoCellID];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:InfoCellID];
    }
  } else {
    cell = [tableView dequeueReusableCellWithIdentifier:SubCellID];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SubCellID];
    }
  }

  cell.imageView.image = nil;

  if (indexPath.section == 0) {
    cell.accessoryType = 0;
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Name";
      cell.detailTextLabel.text = self.info.name;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Package";
      cell.detailTextLabel.text = self.info.package;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = self.info.version;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Section";
      cell.detailTextLabel.text = self.info.section;
    }
  } else if (indexPath.section == 1) {
    cell.accessoryType = 0;
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Description";
      cell.detailTextLabel.text = self.info.description;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Author";
      cell.detailTextLabel.text = self.info.author;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Maintainer";
      cell.detailTextLabel.text = self.info.maintainer;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Install Size";
      cell.detailTextLabel.text = self.info.installSize;
    } else if (indexPath.row == 4) {
      cell.textLabel.text = @"Architecture";
      cell.detailTextLabel.text = self.info.architecture;
    }
  } else if (indexPath.section == 2) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Installed Files";
      cell.imageView.image = [UIImage imageNamed:@"Folder.png"];
    } else if (indexPath.row == 1) {
      if (!self.info.authorEmail) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
        cell.accessoryType = 0;
      }
      cell.textLabel.text = @"Email Author";
      cell.detailTextLabel.text = self.info.authorEmail;
      cell.imageView.image = [UIImage imageNamed:@"Mail.png"];
     } else if (indexPath.row == 2) {
      if (!self.info.maintainerEmail) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
        cell.accessoryType = 0;
      }
      cell.textLabel.text = @"Email Maintainer";
      cell.detailTextLabel.text = self.info.maintainerEmail;
      cell.imageView.image = [UIImage imageNamed:@"Mail.png"];
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"View Depiction";
      cell.detailTextLabel.text = self.depiction;
      cell.imageView.image = [UIImage imageNamed:@"Safari.png"];
    } else if (indexPath.row == 4) {
      cell.textLabel.text = @"Open in Cydia";
      cell.detailTextLabel.text = nil;
      cell.imageView.image = [UIImage imageNamed:@"CydiaLogo.png"];
    }
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      InstalledFilesViewController *fileList = [[InstalledFilesViewController alloc] init];
      fileList.package = self.info.package;

      [self.navigationController pushViewController:fileList animated:YES];
    } else if (indexPath.row == 1) {
      [self sendEmail:0];
    } else if (indexPath.row == 2) {
      [self sendEmail:1];
    } else if (indexPath.row == 3) {
      NSString *depic = self.depiction;
      if (!depic) {
        depic = [NSString stringWithFormat:@"http://cydia.saurik.com/package/%@/", self.package];
      }

      UIViewController *webViewController = [[UIViewController alloc] init];

      UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
      webView.delegate = self;
      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:depic]]];

      [webViewController.view addSubview: webView];

      [self.navigationController pushViewController:webViewController animated:YES];
    } else if (indexPath.row == 4) {
      NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"cydia://package/%@", self.package]];
      [[UIApplication sharedApplication] openURL:myURL];
    }
  } else {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell.detailTextLabel || !cell.detailTextLabel.text) return;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.detailTextLabel.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Copied!";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
  
    [hud hide:YES afterDelay:0.5];
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self.navigationController popViewControllerAnimated:YES];

  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Request Failed"
    message:@"Appster failed to load the depiction. The page may not exist."
    preferredStyle:UIAlertControllerStyleAlert];
 
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
    handler:nil];
   
  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

-(void)sendEmail:(int)user {
  if ([MFMailComposeViewController canSendMail]) {
    NSString *recip;
    if (user == 0) {
      recip = self.info.authorEmail;
    } else if (user == 1) {
      recip = self.info.maintainerEmail;
    }

    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

    [mailCont setSubject:[NSString stringWithFormat:@"Cydia: %@ (%@)", self.info.name, self.info.version]];

    [mailCont setToRecipients:[NSArray arrayWithObjects:recip, nil]];

    NSMutableString *body = [[NSMutableString alloc] init];

    [mailCont setMessageBody:body isHTML:NO];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end