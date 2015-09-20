#import <AppList/AppList.h>
#import <MessageUI/MFMailComposeViewController.h> 

@interface TweakListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
  @property (nonatomic, retain) NSArray *tweakList;
  @property (nonatomic, retain) NSArray *searchResults;
  @property (nonatomic, retain) NSMutableArray *tweakData;
  @property (nonatomic, retain) UITableView *tweakTable;
  @property (nonatomic, retain) UISearchBar *searchBar;

  -(NSDictionary*)generateTweakInfoList;
@end