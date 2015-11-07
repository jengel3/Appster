#import <AppList/AppList.h>
#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 

@interface AppListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
	@property (nonatomic, retain) ALApplicationList *applications;
  @property (nonatomic, retain) NSMutableArray *appList;
	@property (nonatomic, retain) NSMutableArray *systemApps;
  @property (nonatomic, retain) NSMutableArray *mobileApps;
  @property (nonatomic, retain) NSArray *searchResults;
	@property (nonatomic, retain) UITableView *appTable;
  @property (strong, nonatomic) UISearchController *searchController;
	@property (nonatomic, retain) NSArray* hiddenDisplayIdentifiers;
@end