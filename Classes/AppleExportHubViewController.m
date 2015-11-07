#import "AppleExportHubViewController.h"
#import "Messages/MessagesListViewController.h"
#import "Notes/NotesListViewController.h"

@implementation AppleExportHubViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Apple";
  }
  return self;
}

- (void)viewDidLoad {
  self.tabBarItem.image = [UIImage imageNamed:@"Apple.png"];
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.hubTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.hubTable.dataSource = self;
  self.hubTable.delegate = self;

  [self.view addSubview:self.hubTable];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.hubTable) return 0;
  return 6;
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

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  if (indexPath.row == 0) {
    cell.textLabel.text = @"Messages";
    cell.imageView.image = [UIImage imageNamed:@"Messages.png"];
  } else if (indexPath.row == 1) {
    cell.textLabel.text = @"Calendar";
    cell.imageView.image = [UIImage imageNamed:@"Calendar.png"];
  } else if (indexPath.row == 2) {
    cell.textLabel.text = @"Contacts";
    cell.imageView.image = [UIImage imageNamed:@"Contacts.png"];
  } else if (indexPath.row == 3) {
    cell.textLabel.text = @"Reminders";
    cell.imageView.image = [UIImage imageNamed:@"Reminders.png"];
  } else if (indexPath.row == 4) {
    cell.textLabel.text = @"Music";
    cell.imageView.image = [UIImage imageNamed:@"Music.png"];
  } else if (indexPath.row == 5) {
    cell.textLabel.text = @"Notes";
    cell.imageView.image = [UIImage imageNamed:@"Notes.png"];
  }

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  UIViewController *controller;

  if (indexPath.row == 0) {
    controller = [[MessagesListViewController alloc] init];
  } else if (indexPath.row == 1) {
  } else if (indexPath.row == 2) {
  } else if (indexPath.row == 3) {
  } else if (indexPath.row == 4) {
  } else if (indexPath.row == 5) {
    controller = [[NotesListViewController alloc] init];
  }

  if (controller) {
    UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;

    [(UINavigationController*)tabBarController.selectedViewController pushViewController:controller animated:YES];
  }
}
@end