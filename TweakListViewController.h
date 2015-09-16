@interface TweakListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
  @property (nonatomic, retain) NSMutableArray *tweakList;
  @property (nonatomic, retain) UITableView *tweakTable;
@end