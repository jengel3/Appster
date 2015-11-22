#import <MessageUI/MessageUI.h> 
#import <MessageUI/MFMailComposeViewController.h> 
#import "TweakInfo.h"

@interface TweakInfoViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>
  @property (nonatomic, retain) NSString *package;
  @property (nonatomic, retain) NSString *name;

  @property (nonatomic, retain) NSString *author;
  @property (nonatomic, retain) NSString *authorEmail;
  @property (nonatomic, retain) NSString *maintainer;
  @property (nonatomic, retain) NSString *maintainerEmail;
  @property (nonatomic, retain) NSString *version;

  @property (nonatomic, retain) NSString *depiction;

  @property (nonatomic, retain) TweakInfo *info;
  @property (nonatomic, retain) UITableView  *infoTable;
@end