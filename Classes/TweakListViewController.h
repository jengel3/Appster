#import <AppList/AppList.h>
#import <MessageUI/MFMailComposeViewController.h> 

@interface TweakListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
  @property (nonatomic, retain) NSArray *tweakList;
  @property (nonatomic, retain) NSMutableArray *searchResults;
  @property (nonatomic, retain) NSDictionary *tweakMap;
  @property (nonatomic, retain) UITableView *tweakTable;
  @property (nonatomic, retain) UISearchBar *searchBar;

  -(NSDictionary*)generateTweakInfoList;
@end