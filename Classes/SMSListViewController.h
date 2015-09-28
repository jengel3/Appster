#import <UIKit/UIKit.h>

@interface SMSListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
  @property (nonatomic, retain) UITableView *msgTable;
  @property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

  @property (nonatomic, retain) NSArray *messages;
  @property (nonatomic, retain) NSString *chatId;

@end