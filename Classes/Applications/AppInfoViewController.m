#import "AppInfoViewController.h"
#import <AppList/AppList.h>
#import "../MBProgressHud/MBProgressHUD.h"
#import "../Settings.h"

@implementation AppInfoViewController
@synthesize appInfo;
@synthesize infoTable;

-(void)viewDidLoad {
  self.title = self.appInfo.identifier;

  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.infoTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  self.infoTable.dataSource = self;
  self.infoTable.delegate = self;

  self.delegate = self;

  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
  UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, self.view.bounds.size.width - 90 - 20, 30)];
  headerLabel.text = self.appInfo.name;
  headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  [headerView addSubview:headerLabel];
  [imageView setImage:self.appInfo.icon];
  [headerView addSubview:imageView];
  self.infoTable.tableHeaderView = headerView;

  UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Apps" 
    style:UIBarButtonItemStylePlain
    target:nil 
    action:nil];
  self.navigationItem.backBarButtonItem = newBackButton;

  UIBarButtonItem *actionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Actions" 
    style:UIBarButtonItemStylePlain 
    target:self
    action:@selector(showActionSheet:)];          
  self.navigationItem.rightBarButtonItem = actionsButton;

  self.appList = [ALApplicationList sharedApplicationList];
  self.title = self.appInfo.name;
  [self.view addSubview:self.infoTable];

  [self.appInfo loadExtraInfo];

  [self.infoTable reloadData];
}

-(void)showActionSheet:(UIBarButtonItem*)sender {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"App Actions"
    message:nil
    preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * action) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }];

  UIAlertAction *hideUpdates;
  if (![self.appInfo isSystem]) {
    AppsterSettings *settings = [[AppsterSettings alloc] init];
    NSMutableArray *current = [settings valueForKey:@"hidden_updates"];
    if (!current) current = [[NSMutableArray alloc] init];

    if ([current containsObject:self.appInfo.identifier]) {
      hideUpdates = [UIAlertAction actionWithTitle:@"Show App Store Updates" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
          [current removeObject:self.appInfo.identifier];
          [settings setValue:current forKey:@"hidden_updates"];
        }];
    } else {
      hideUpdates = [UIAlertAction actionWithTitle:@"Hide App Store Updates" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action) {
          [current addObject:self.appInfo.identifier];
          [settings setValue:current forKey:@"hidden_updates"];
        }];
    }
  }

  UIAlertAction *exportApp = [UIAlertAction actionWithTitle:@"Export Application" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self exportContent:0];
    }];

  [alert addAction:cancelAction];
  if (hideUpdates) [alert addAction:hideUpdates];
  [alert addAction:exportApp];

  UIPopoverPresentationController *presenter = [alert popoverPresentationController];
  presenter.barButtonItem = sender;

  [self presentViewController:alert animated:YES completion:nil];
}

-(NSString *)getBody:(int)mode {
  NSMutableString *body = [[NSMutableString alloc] init];

  AppInfo *app = self.appInfo;
  if ([app isiTunes]) {
    [body appendString:[NSString stringWithFormat:@"<b>%@ - %@</b><br>", app.name, app.version]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Identifier: %@<br>", app.identifier]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;App ID: %@<br>", app.pk]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Developer: %@<br>", app.artist]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Purchase Date: %@<br>", app.purchaseDate]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Purchaser: %@<br>", app.purchaserAccount]];
  } else {
    [body appendString:[NSString stringWithFormat:@"<b>%@</b><br>", app.name]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Identifier: %@<br>", app.identifier]];
    [body appendString:[NSString stringWithFormat:@"&nbsp;&nbsp;Bundle Version: %@<br>", app.bundleVersion]];
  }
  [body appendString:@"<br><br>"];

  return body;
}

- (NSString *)getSubject {
  return @"Appster Application Export %@";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return 3;
  } else if (section == 1) {
    return 4;
  } else if (section == 2) {
    if ([self.appInfo isiTunes]) {
      return 4;
    }
    if ([self.appInfo isSystem]) {
      return 1;
    } else {
      return 2;
    }
  } else if (section == 3) {
    if ([self.appInfo isSystem]) {
      return 1;
    } else {
      return 2;
    }
  }
  return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if ([self.appInfo isSystem]) return 3;
  return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"App Info";
  } else if (section == 1) {
    return @"Bundle";
  } else if (section == 2) {
    if ([self.appInfo isiTunes]) {
      return @"iTunes";
    } else {
      return @"Actions";
    }
  } else if (section == 3) {
    return @"Actions";
  }
  return nil;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }

  cell.imageView.image = nil;

  if (indexPath.section == 0) {

    if (indexPath.row == 0) {
      cell.accessoryType = 0;
      cell.textLabel.text = @"Name";
      cell.detailTextLabel.text = self.appInfo.name;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Identifier";
      cell.detailTextLabel.text = self.appInfo.identifier;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = self.appInfo.version ? self.appInfo.version : @"n/a";
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Path";
      cell.detailTextLabel.text = self.appInfo.rawPath;
    }

  } else if (indexPath.section == 1) {
    cell.accessoryType = 0;
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Bundle";
      cell.detailTextLabel.text = self.appInfo.bundle;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = self.appInfo.bundleVersion;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Folder";
      cell.detailTextLabel.text = self.appInfo.folder;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Type";
      cell.detailTextLabel.text = self.appInfo.type;
    }
  } else if (indexPath.section == 2 && [self.appInfo isiTunes]) {
    cell.accessoryType = 0;
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Developer";
      cell.detailTextLabel.text = self.appInfo.artist;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Release Date";
      cell.detailTextLabel.text = self.appInfo.releaseDate;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Purchase Date";
      cell.detailTextLabel.text = self.appInfo.purchaseDate;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Purchaser";
      cell.detailTextLabel.text = self.appInfo.purchaserAccount;
    }
  } else if (indexPath.section == 2 || indexPath.section == 3) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
      AppsterSettings *settings = [[AppsterSettings alloc] init];
      int editor = [[settings valueForKey:@"file_explorer" orDefault:@1] intValue];
      if (editor == 1) {
        cell.textLabel.text = @"Open in iFile";
        cell.imageView.image = [UIImage imageNamed:@"iFileIcon.png"];
      } else if (editor == 2) {
        cell.textLabel.text = @"Open in Filza";
        cell.imageView.image = [UIImage imageNamed:@"FilzaIcon.png"];
      }
      cell.detailTextLabel.text = nil;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Open in iTunes";
      cell.detailTextLabel.text = nil;
      cell.imageView.image = [UIImage imageNamed:@"AppStore.png"];
    }
  }

  cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (([self.appInfo isiTunes] && indexPath.section == 3) || (indexPath.section == 2 && [self.appInfo isSystem])) {
    if (indexPath.row == 0) {
      UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
      NSString *fileURL = [self.appInfo.rawPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      NSString *appURL;
      if ([cell.textLabel.text isEqualToString:@"Open in iFile"]) {
        appURL = [NSString stringWithFormat:@"ifile://%@", fileURL];
      } else if ([cell.textLabel.text isEqualToString:@"Open in Filza"]) {
        appURL = [NSString stringWithFormat:@"filza://%@", fileURL];
      }
      if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appURL]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
      }
    } else if (indexPath.row == 1) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appInfo.pk]]];
    }
    return;
  }
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

- (id)valueForKey:(NSString*)key {
  return [self.appList valueForKey:key forDisplayIdentifier:self.appInfo.identifier];
}
@end