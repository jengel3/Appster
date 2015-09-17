@interface TweakInfoViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate>
  @property (nonatomic, retain) NSString *package;
  @property (nonatomic, retain) NSString *name;
  @property (nonatomic, retain) NSDictionary *tweakInfo;
  @property (nonatomic, retain) UITableView  *infoTable;
@end