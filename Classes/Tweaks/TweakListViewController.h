#import "../ListExportController.h"
#import "../ListExportDelegate.h"

@interface TweakListViewController : ListExportController <UITableViewDataSource, UITableViewDelegate, ListExportDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
  @property (nonatomic, retain) NSArray *tweakList;
  @property (nonatomic, retain) NSArray *searchResults;
  @property (nonatomic, retain) NSArray *sources;
  @property (nonatomic, retain) NSMutableArray *tweakData;
  @property (nonatomic, retain) UITableView *tweakTable;
  @property (strong, nonatomic) UISearchController *searchController;

  -(NSDictionary *)loadTweaks;
  -(void)loadSources;
@end