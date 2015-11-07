#import <UIKit/UIKit.h>

@interface NotesListTableCell : UITableViewCell
  @property (strong, nonatomic) IBOutlet UILabel *titleLabel;
  @property (strong, nonatomic) IBOutlet UILabel *bodyLabel;
  @property (strong, nonatomic) IBOutlet UILabel *authorLabel;
  @property (nonatomic, assign) BOOL didSetupConstraints;
@end