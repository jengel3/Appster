#import "SMSListViewController.h"
#import "SMSMessage.h"

@implementation SMSListViewController

- (void)viewDidLoad {
    self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];

    self.msgsTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.msgsTable.dataSource = self;
    self.msgsTable.delegate = self;

    // self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    // self.activityIndicator.center=self.view.center;
    // [self.activityIndicator startAnimating];

    // [self.view addSubview:self.activityIndicator];
    // 
    [self.view addSubview:msgsTable];

    self.messages = [self findMessages];

    [self.msgsTable reloadData];  
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 1;
}


- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.msgsTable) return 0;
  return [self.messages count];
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
  NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  SMSMessage *msg = (SMSMessage*)[self.messages objectAtIndex:indexPath.row];
  cell.textLabel.text = msg.text;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray*) findMessages {
    NSString *path = @"/var/mobile/Library/SMS/sms.db";
    sqlite3_stmt *statement;

    sqlite3 *smsDb = nil;

    if (!smsDb && sqlite3_open([path UTF8String], &smsDb) != SQLITE_OK) {
        NSLog(@"Failed to open database");
        return nil;
    }

    NSString *querySQL = @"SELECT text,date,is_from_me FROM chat ORDER BY date";
    NSMutableArray *resultArray = [NSMutableArray new];
    if (sqlite3_prepare_v2(smsDb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
          SMSMessage *msg = [[SMSMessage alloc] initWithResult:statement];
          [resultArray addObject:msg];
        }
        sqlite3_reset(statement);
    }
    return [resultArray copy];
}

@end