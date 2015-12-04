#import "MessagesListViewController.h"
#import "UIMessageTableViewCell.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "../MBProgressHud/MBProgressHUD.h"
#import "SMSMessage.h"
#import <sqlite3.h> 
#import "../Settings.h"

static NSString *CellIdentifier = @"Cell";

@implementation MessagesListViewController

- (void)viewDidLoad {
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.messagesTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.messagesTable.dataSource = self;
  self.messagesTable.delegate = self;

  self.delegate = self;
  
  [self.messagesTable registerClass:[UIMessageTableViewCell class] forCellReuseIdentifier:CellIdentifier];

  self.messagesTable.estimatedRowHeight = 50;
  self.messagesTable.rowHeight = UITableViewAutomaticDimension;

  self.title = [NSString stringWithFormat:@"Chat: %@", self.chatId];

  UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    target:self
    action:@selector(showExport:)];
  self.navigationItem.rightBarButtonItem = exportButton;

  [self.view addSubview:self.messagesTable];

  self.messages = [self findMessages];
  self.messages = [[self.messages reverseObjectEnumerator] allObjects];

  [self.messagesTable reloadData];  
}

- (NSString*)getBody:(int)mode {
  NSMutableString *body = [[NSMutableString alloc] init];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSDateFormatterStyle style = NSDateFormatterShortStyle;
  [formatter setTimeStyle:style];
  [formatter setDateStyle:style];

  for (SMSMessage *msg in self.messages) {
    [body appendString:[NSString stringWithFormat:@"<div style='color: %@;'>%@<br><div style='size: 50%%; color: black;'>&nbsp;-%@</div></div><br>", (msg.isFromMe ? @"blue" : @"gray"), msg.text, [formatter stringFromDate:msg.date]]];
  }
  return body;
}

- (NSString*)getSubject {
  return @"Appster Messages Export %@";
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  return 1;
}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
  return [self.messages count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
  UIMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  SMSMessage *msg = (SMSMessage*)[self.messages objectAtIndex:indexPath.row];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

  NSDateFormatterStyle style = NSDateFormatterShortStyle;
  [formatter setTimeStyle:style];
  [formatter setDateStyle:style];

  NSString *timestamp = [formatter stringFromDate:msg.date];

  cell.msgLabel.text = msg.text;
  cell.timestampLabel.text = timestamp;

  if (msg.isFromMe) {
    [cell.msgLabel setTextAlignment:NSTextAlignmentRight];
    [cell.timestampLabel setTextAlignment:NSTextAlignmentRight];
  } else {
    [cell.msgLabel setTextAlignment:NSTextAlignmentLeft];
    [cell.timestampLabel setTextAlignment:NSTextAlignmentLeft];
  }

  cell.timestampLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];

  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  UIMessageTableViewCell *cell = (UIMessageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
  if (!cell.msgLabel || !cell.msgLabel.text) return;
  
  UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
  pasteboard.string = cell.msgLabel.text;
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.labelText = @"Copied!";
  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
  hud.mode = MBProgressHUDModeCustomView;

  [hud hide:YES afterDelay:0.5];
}

- (NSMutableArray*)findMessages {
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
          msg.text = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
          NSString *date = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 1)];
          msg.date = [NSDate dateWithTimeIntervalSinceReferenceDate:[date doubleValue]];
          msg.isFromMe = [[NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)] boolValue];
          [resultArray addObject:msg];
        }
        sqlite3_reset(statement);
    }
    return [resultArray copy];
}

@end