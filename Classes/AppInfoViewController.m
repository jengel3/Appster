#import "AppInfoViewController.h"
#import <AppList/AppList.h>
#import "MBProgressHUD.h"

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

  UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Apps" 
    style:UIBarButtonItemStylePlain
    target:nil 
    action:nil];
  self.navigationItem.backBarButtonItem = newBackButton;

  self.appList = [ALApplicationList sharedApplicationList];
  self.title = self.appInfo.name;
  [self.view addSubview:self.infoTable];

  [self.appInfo loadExtraInfo];

  [self.infoTable reloadData];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.infoTable) return 0;

  if (section == 0) {
    return 2;
  } else if (section == 1) {
    return 4;
  } else if (section == 2) {
    return 4;
  }
  return 0;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"App Info";
  } else if (section == 1) {
    return @"Bundle";
  } else if (section == 2) {
    return @"iTunes";
  }
  return nil;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }

  if (indexPath.section == 0) {

    if (indexPath.row == 0) {
      cell.textLabel.text = @"Name";
      cell.detailTextLabel.text = self.appInfo.name;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Identifier";
      cell.detailTextLabel.text = self.appInfo.identifier;
    } else if (indexPath.row == 2) {

      cell.textLabel.text = @"Path";
      cell.detailTextLabel.text = self.appInfo.rawPath;
    }

  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Bundle";
      cell.detailTextLabel.text = self.appInfo.bundle;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = self.appInfo.version;
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Folder";
      cell.detailTextLabel.text = self.appInfo.folder;
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Type";
      cell.detailTextLabel.text = self.appInfo.type;
    }
  } else if (indexPath.section == 2) {
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
  }

  cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
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