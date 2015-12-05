#import "ChatListViewController.h"
#import "UIMessageTableViewCell.h"
#import "MessagesListViewController.h"
#import <sqlite3.h> 
#import "SMSChat.h"
#import "../Settings.h"

@implementation ChatListViewController
@synthesize chatTable;
@synthesize chatList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"iMessage";
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.chatTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.chatTable.dataSource = self;
  self.chatTable.delegate = self;

  UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    target:self
    action:@selector(exportDatabase:)];
  self.navigationItem.rightBarButtonItem = shareButton;

  [self.view addSubview:self.chatTable];

  [self loadData];
}

- (void)exportDatabase:(id)sender {
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = self;
    mailCont.modalPresentationStyle = UIModalPresentationFullScreen;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *now = [NSDate date];

    NSDateFormatterStyle style = NSDateFormatterShortStyle;

    [formatter setTimeStyle:style];
    [formatter setDateStyle:style];

    NSString *timestamp = [formatter stringFromDate:now];

    [mailCont setSubject:[NSString stringWithFormat:@"Appster Messages Database Export - %@", timestamp]];

    style = NSDateFormatterMediumStyle;
    [formatter setTimeStyle:style];
    [formatter setDateStyle:style];

    timestamp = [formatter stringFromDate:now];

    AppsterSettings *settings = [[AppsterSettings alloc] init];
    NSString *defaultEmail = [settings valueForKey:@"default_email"];
    if (defaultEmail) {
      [mailCont setToRecipients:@[defaultEmail]];
    } else {
      [mailCont setToRecipients:nil];
    }

    NSMutableString *body = [[NSMutableString alloc] init];
    [body appendString:[NSString stringWithFormat:@"Appster Messages Database Export - %@ <br><br><br>", timestamp]];
    [body appendString:@"Message database is attached to email."];

    NSData *dbData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SMS/sms.db"];
    [mailCont addAttachmentData:dbData mimeType:@"application/x-sqlite3" fileName:@"sms.db"];

    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData {
  self.chatList = [self findChats];
  [self.chatTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.chatList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  SMSChat *chat = [self.chatList objectAtIndex:indexPath.row];
  cell.textLabel.text = chat.guid;
  cell.imageView.image = [UIImage imageNamed:@"Messages.png"];


  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  SMSChat *chat = (SMSChat *)[self.chatList objectAtIndex:indexPath.row];

  MessagesListViewController *msgList = [MessagesListViewController alloc];
  msgList.chatId = chat.chatId;

  [self.navigationController pushViewController:msgList animated:YES];
}

- (NSMutableArray *) findChats {
  NSString *path = @"/var/mobile/Library/SMS/sms.db";
  sqlite3_stmt *statement;

  sqlite3 *smsDb = nil;

  if (!smsDb && sqlite3_open([path UTF8String], &smsDb) != SQLITE_OK) {
      NSLog(@"Failed to open database");
      return nil;
  }

  NSString *querySQL = @"SELECT guid,rowid FROM chat ORDER BY guid";
  NSMutableArray *resultArray = [NSMutableArray new];
  if (sqlite3_prepare_v2(smsDb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
    while (sqlite3_step(statement) == SQLITE_ROW) {
      SMSChat *chat = [SMSChat alloc];

      chat.guid = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)];
      chat.guid = [chat.guid componentsSeparatedByString:@";"][2];

      chat.chatId = [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)];
      [resultArray addObject:chat];
    }
    sqlite3_reset(statement);
  }
  return [resultArray copy];
}

@end