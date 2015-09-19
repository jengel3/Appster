#import <AppList/AppList.h>
#import <MessageUI/MFMailComposeViewController.h> 

@interface TweakListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
  @property (nonatomic, retain) NSArray *tweakList;
  @property (nonatomic, retain) NSDictionary *tweakMap;
  @property (nonatomic, retain) UITableView *tweakTable;

  -(NSDictionary*)generateTweakInfoList;
@end