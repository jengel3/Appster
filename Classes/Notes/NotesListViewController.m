#import "NotesListViewController.h"
#import <sqlite3.h> 
#import "NoteData.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "NotesListTableCell.h"

static NSString *CellIdentifier = @"Cell";

@implementation NotesListViewController
- (void)viewDidLoad {
  [super viewDidLoad];

  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.notesTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  self.notesTable.dataSource = self;
  self.notesTable.delegate = self;

  self.title = @"Notes";

  [self.notesTable registerClass:[NotesListTableCell class] forCellReuseIdentifier:CellIdentifier];

  self.notesTable.estimatedRowHeight = 44;
  self.notesTable.rowHeight = UITableViewAutomaticDimension;


  UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    target:self
    action:@selector(exportOptions:)];

  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
    target:self
    action:@selector(loadData)];


  self.navigationItem.rightBarButtonItems = @[shareButton, refreshButton];

  [self.view addSubview:self.notesTable];

  [self loadData];
}


- (void)exportOptions:(id)sender {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Notes Export Options"
    message:nil
    preferredStyle:UIAlertControllerStyleActionSheet];

  UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
    handler:^(UIAlertAction * action) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }];

  UIAlertAction* exportDB = [UIAlertAction actionWithTitle:@"Export Database" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self exportList:0];
    }];

  UIAlertAction* exportText = [UIAlertAction actionWithTitle:@"Export Text" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {
      [self exportList:1];
    }];
   
  [alert addAction:cancelAction];
  [alert addAction:exportDB];
  [alert addAction:exportText];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)exportList:(int)type {
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
    [mailCont setToRecipients:nil];
    NSMutableString *body = [[NSMutableString alloc] init];


    if (type == 0) {
      [mailCont setSubject:[NSString stringWithFormat:@"Appster Notes Database Export - %@", timestamp]];

      [body appendString:[NSString stringWithFormat:@"Appster Notes Database Export - %@ <br><br><br>", timestamp]];
      [body appendString:@"Notes database is attached to email."];

      NSData *dbData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Notes/notes.sqlite"];
      [mailCont addAttachmentData:dbData mimeType:@"application/x-sqlite3" fileName:@"notes.sqlite"];
    } else if (type == 1) {
      [mailCont setSubject:[NSString stringWithFormat:@"Appster Notes Export - %@", timestamp]];

      [body appendString:[NSString stringWithFormat:@"Appster Notes Export - %@ <br><br><br>", timestamp]];

      for (NoteData* note in self.notes) {
        NSDictionary *documentAttributes = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};    
        NSData *htmlData = [note.body dataFromRange:NSMakeRange(0, note.body.length) documentAttributes:documentAttributes error:NULL];
        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        [body appendString:[NSString stringWithFormat:@"<p><b>%@</b><br>%@<br><div style='color:gray;font-size:75%%;'>by: %@ - %@</div></p><br>",
          note.title, htmlString, (note.author ? note.author : @"n/a"), [formatter stringFromDate:note.createdAt]]];
      }
  
    }

    [mailCont setMessageBody:body isHTML:YES];

    [self presentViewController:mailCont animated:YES completion:nil];
  }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadData {
  self.notes = [self findNotes];
  [self.notesTable reloadData];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
  return 1;
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
  if (tableView != self.notesTable) return 0;
  return [self.notes count];
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {\
  NotesListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  NoteData *note = [self.notes objectAtIndex:indexPath.row];
  cell.titleLabel.text = note.title;

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  NSDateFormatterStyle style = NSDateFormatterShortStyle;

  [formatter setTimeStyle:style];
  [formatter setDateStyle:style];

  cell.authorLabel.text = [NSString stringWithFormat:@"by: %@ - %@", (note.author ? note.author : @"n/a"), [formatter stringFromDate:note.updatedAt]];
  cell.bodyLabel.attributedText = note.body;
  

  cell.authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
  cell.authorLabel.textColor = [UIColor grayColor];

  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (NSArray*) findNotes {
  NSString *path = @"/var/mobile/Library/Notes/notes.sqlite";
  sqlite3_stmt *statement;

  sqlite3 *smsDb = nil;

  if (!smsDb && sqlite3_open([path UTF8String], &smsDb) != SQLITE_OK) {
      NSLog(@"Failed to open database");
      return nil;
  }

  NSString *querySQL = @"SELECT N.Z_PK,ZAUTHOR,ZTITLE,ZCONTENT,ZCREATIONDATE,ZMODIFICATIONDATE FROM ZNOTE AS N JOIN ZNOTEBODY AS B ON N.Z_PK=B.ZOWNER ORDER BY ZMODIFICATIONDATE;";
  NSMutableArray *resultArray = [NSMutableArray new];
  if (sqlite3_prepare_v2(smsDb, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
      while (sqlite3_step(statement) == SQLITE_ROW) {
        NoteData *note = [NoteData alloc];
        note.pk = (NSInteger)sqlite3_column_int(statement, 0);
        const unsigned char * rawAuthor = sqlite3_column_text(statement, 1);
        if (rawAuthor) {
          note.author = [NSString stringWithFormat:@"%s",rawAuthor];
        } else {
          note.author = nil;
        }
        note.title = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 2)];
        NSString *rawBody = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 3)];

        note.body = [[NSAttributedString alloc] initWithData:[rawBody dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];

        NSString *creationDate = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 4)];
        NSString *updateDate = [NSString stringWithFormat:@"%s",(char*)sqlite3_column_text(statement, 5)];

        note.createdAt = [NSDate dateWithTimeIntervalSinceReferenceDate:[creationDate doubleValue]];
        note.updatedAt = [NSDate dateWithTimeIntervalSinceReferenceDate:[updateDate doubleValue]];

        [resultArray addObject:note];
      }
      sqlite3_reset(statement);
  }
  return [resultArray copy];
}

@end