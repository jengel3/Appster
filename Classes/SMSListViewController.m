#import "SMSListViewController.h"
#import "SMSMessage.h"
#import <sqlite3.h> 

@implementation SMSListViewController

- (void)viewDidLoad {
    self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor whiteColor];

    self.msgTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.msgTable.dataSource = self;
    self.msgTable.delegate = self;


    self.title = [NSString stringWithFormat:@"Chat: %@", self.chatId];

    // self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    // self.activityIndicator.center=self.view.center;
    // [self.activityIndicator startAnimating];

    // [self.view addSubview:self.activityIndicator];
    // 
    [self.view addSubview:self.msgTable];

    self.messages = [self findMessages];

    [self.msgTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

    [self.msgTable reloadData];  
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 1;
}


- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.msgTable) return 0;
  return [self.messages count];
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
  NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }

  NSLog(@"CALLED");
  
  SMSMessage *msg = (SMSMessage*)[self.messages objectAtIndex:indexPath.row];
  NSLog(@"ME? %d", msg.isFromMe);
  if (msg.isFromMe) {
    cell.textLabel.textAlignment = NSTextAlignmentRight;
  } else {
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
  }
  cell.textLabel.numberOfLines = 0;
  cell.textLabel.text = msg.text;

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

    NSString *querySQL = @"SELECT text,date,is_from_me FROM `message` WHERE `ROWID` IN ( SELECT `message_id` FROM `chat_message_join` WHERE `chat_id` = %@ ) ORDER BY date";
    querySQL = [NSString stringWithFormat:querySQL, self.chatId];
    NSMutableArray *resultArray = [NSMutableArray new];
    if (sqlite3_prepare_v2(smsDb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
          SMSMessage *msg = [SMSMessage alloc];
          msg.text = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 0)];
          msg.date = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)];
          msg.isFromMe = [[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)] boolValue];
          [resultArray addObject:msg];
        }
        sqlite3_reset(statement);
    }
    return [resultArray copy];
}

@end