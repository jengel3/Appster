#import "TweakInfoViewController.h"

@implementation TweakInfoViewController
@synthesize package;
@synthesize name;
@synthesize tweakInfo;
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
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.infoTable) return 0;
  if (section == 0) {
    return 4;
  } else if (section == 1) {
    return 5;
  }
  return 0;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 0) {
    return @"Tweak Info";
  } else if (section == 1) {
    return @"About";
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
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Name"];
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Package";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Package"];
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Version";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Version"];
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Section";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Section"];
    }
  } else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Description";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Description"];
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Author";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Author"];
    } else if (indexPath.row == 2) {
      cell.textLabel.text = @"Maintainer";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Maintainer"];
    } else if (indexPath.row == 3) {
      cell.textLabel.text = @"Install Size";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Installed-Size"];
    } else if (indexPath.row == 4) {
      cell.textLabel.text = @"Architecture";
      cell.detailTextLabel.text = [self.tweakInfo objectForKey:@"Architecture"];
    }
  }

  return cell;
}

@end