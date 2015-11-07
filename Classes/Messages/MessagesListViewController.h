#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import <UIKit/UIKit.h>

@interface MessagesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) UITableView *chatTable;
  @property (nonatomic, retain) NSArray *chatList;
@end