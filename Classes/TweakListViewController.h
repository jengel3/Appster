#import <AppList/AppList.h>
#import <MessageUI/MFMailComposeViewController.h> 

@interface TweakListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
  @property (nonatomic, retain) NSArray *tweakList;
  @property (nonatomic, retain) NSArray *searchResults;
  @property (nonatomic, retain) NSArray *sources;
  @property (nonatomic, retain) NSMutableArray *tweakData;
  @property (nonatomic, retain) UITableView *tweakTable;
  @property (strong, nonatomic) UISearchController *searchController;

  -(NSDictionary*)generateTweakInfoList;
  -(void)loadSourcesList;
@end