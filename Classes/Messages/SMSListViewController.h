#import <UIKit/UIKit.h>
#import "UIMessageTableViewCell.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@interface SMSListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) UITableView *msgTable;
  @property (nonatomic, strong) UIMessageTableViewCell *prototypeCell;

  @property (nonatomic, retain) NSArray *messages;
  @property (nonatomic, retain) NSString *chatId;
@end