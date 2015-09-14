#import <AppList/AppList.h>

@interface AppInfoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
	@property (nonatomic, retain) NSString *identifier;
	@property (nonatomic, retain) NSString *appName;
  @property (nonatomic, retain) UITableView *infoTable;
  @property (nonatomic, retain) ALApplicationList *appList;
@end