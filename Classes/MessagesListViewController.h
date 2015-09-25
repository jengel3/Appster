@interface MessagesListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
  @property (nonatomic, retain) UITableView *chatTable;
  @property (nonatomic, retain) NSArray *chatList;
@end