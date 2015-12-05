#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "NotesListTableCell.h"

@interface NotesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) UITableView *notesTable;
  @property (nonatomic, strong) NotesListViewController *prototypeCell;
  @property (nonatomic, strong) NSArray *notes;

  - (NSArray *)findNotes;
@end