#import <AppList/AppList.h>
#import "AppInfo.h"
#import "../ListExportController.h"
#import "../ListExportDelegate.h"

@interface AppInfoViewController : ListExportController <UITableViewDataSource, UITableViewDelegate, ListExportDelegate>
  @property (nonatomic, retain) AppInfo* appInfo;
  @property (nonatomic, retain) UITableView *infoTable;
  @property (nonatomic, retain) ALApplicationList *appList;
@end