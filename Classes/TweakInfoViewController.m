#import "TweakInfoViewController.h"
#import "Utilities.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "MBProgressHUD.h"
#import "TweakInfo.h"

@implementation TweakInfoViewController
@synthesize package;
@synthesize name;
@synthesize info;
@synthesize infoTable;

- (void) viewDidLoad {
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

  [self.view addSubview:self.infoTable];

}

- (void) showExport:(id)sender {
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

    [mailCont setSubject:[NSString stringWithFormat:@"Cydia Tweak Export - %@", timestamp]];

    style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
    [formatter setDateStyle:style];

    timestamp = [formatter stringFromDate:now];

    [mailCont setToRecipients:nil];

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"Cydia Tweak Export - %@ <br><br>", timestamp]];

    NSArray *keys = [self.info.rawData allKeys];

    [body appendString:[NSString stringWithFormat:@"<b>%@</b><br><br>", self.name ? self.name : self.package]];

    [body appendString:[NSString stringWithFormat:@"<b>Package:</b> %@<br>", self.package]];

    for (id key in keys) {
      if ([key isEqualToString:@"Name"]) continue;

      [body appendString:[NSString stringWithFormat:@"<b>%@</b>: %@<br>", key, [self.info.rawData objectForKey:key]]];
    }

    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.infoTable) return 0;
  if (section == 0) {
    return 4;
  } else if (section == 1) {
    return 5;
  } else if (section == 2) {
    if (self.depiction) return 3;
    return 2;
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
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if ((indexPath.section == 0 || indexPath.section == 1) && cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }

  cell.imageView.image = nil;

  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Name";
      cell.detailTextLabel.text = self.name;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Package";
      cell.detailTextLabel.text = self.package;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = self.version;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Section";
      cell.detailTextLabel.text = self.info.section;
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Description";
      cell.detailTextLabel.text = self.info.description;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Author";
      cell.detailTextLabel.text = self.author;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Maintainer";
      cell.detailTextLabel.text = self.maintainer;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Install Size";
      cell.detailTextLabel.text = self.info.installSize;
    } else if (indexPath.row == 4) {
      cell.textLabel.text = @"Architecture";
      cell.detailTextLabel.text = self.info.architecture;
    }
  } else if (indexPath.section == 2) {
    if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
      if (!self.authorEmail) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
      }
      cell.textLabel.text = @"Email Author";
      cell.detailTextLabel.text = self.authorEmail;
      cell.imageView.image = [UIImage imageNamed:@"TwitterIcon.png"];
     } else if (indexPath.row == 1) {
      if (!self.maintainerEmail) {
        cell.userInteractionEnabled = NO;
        cell.textLabel.enabled = NO;
        cell.detailTextLabel.enabled = NO;
      }
      cell.textLabel.text = @"Email Maintainer";
      cell.detailTextLabel.text = self.maintainerEmail;
      cell.imageView.image = [UIImage imageNamed:@"TwitterIcon.png"];
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Open Depiction";
      cell.detailTextLabel.text = self.depiction;
      cell.imageView.image = [UIImage imageNamed:@"TwitterIcon.png"];
    }
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.section == 2) {
    if (indexPath.row == 0) {
      [self sendEmail:0];
    } else if (indexPath.row == 1) {
      [self sendEmail:1];
    } else if (indexPath.row == 2) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.depiction]];
    }
  } else {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = cell.detailTextLabel.text;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Copied!";
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
  
    [hud hide:YES afterDelay:0.5];
  }
}

-(void)sendEmail:(int)user {
  if ([MFMailComposeViewController canSendMail]) {
    NSString *recipName;
    NSString *recip;
    if (user == 0) {
      recipName = self.author;
      recip = self.authorEmail;
    } else if (user == 1) {
      recipName = self.maintainer;
      recip = self.maintainerEmail;
    }

    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];

    NSDateFormatterStyle style = NSDateFormatterShortStyle;

    [formatter setTimeStyle:style];
    [formatter setDateStyle:style];

    NSString *timestamp = [formatter stringFromDate:now];

    [mailCont setSubject:[NSString stringWithFormat:@"%@ Contact %@ - %@", (user == 0 ? @"Author" : @"Maintainer"), recipName, timestamp]];

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