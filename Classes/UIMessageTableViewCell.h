#import <UIKit/UIKit.h>

@interface UIMessageTableViewCell : UITableViewCell
  @property (strong, nonatomic) IBOutlet UILabel *msgLabel;
  @property (strong, nonatomic) IBOutlet UILabel *timestampLabel;
  @property (nonatomic, assign) BOOL didSetupConstraints;
@end