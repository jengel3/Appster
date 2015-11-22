#import <AppList/AppList.h>
#import "AppInfo.h"
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@interface AppInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) AppInfo* appInfo;
  @property (nonatomic, retain) UITableView *infoTable;
  @property (nonatomic, retain) ALApplicationList *appList;
@end