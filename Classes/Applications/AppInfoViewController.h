#import <AppList/AppList.h>
#import "AppInfo.h"

@interface AppInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
  @property (nonatomic, retain) AppInfo* appInfo;
  @property (nonatomic, retain) UITableView *infoTable;
  @property (nonatomic, retain) ALApplicationList *appList;
@end