#import <UIKit/UIKit.h>
#import "UIMessageTableViewCell.h"
#import "../ListExportController.h"
#import "../ListExportDelegate.h"

@interface MessagesListViewController : ListExportController <UITableViewDataSource, UITableViewDelegate, ListExportDelegate>
  @property (nonatomic, retain) UITableView *messagesTable;
  @property (nonatomic, strong) UIMessageTableViewCell *prototypeCell;
  @property (nonatomic, retain) NSArray *messages;
  @property (nonatomic, retain) NSString *chatId;
@end