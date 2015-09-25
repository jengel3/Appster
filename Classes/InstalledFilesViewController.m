#import "InstalledFilesViewController.h"

@implementation InstalledFilesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"Installed Files";
  }
  return self;
}

- (void) viewDidLoad {
  self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
  self.view.backgroundColor = [UIColor whiteColor];

  self.filesList = [[UITextView alloc] initWithFrame:self.view.bounds];
  self.filesList.scrollEnabled = YES;

  NSData* data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"/var/lib/dpkg/info/%@.list", self.package]];
  NSString* raw = [[NSString alloc] 
    initWithBytes:[data bytes]
    length:[data length] 
    encoding:NSUTF8StringEncoding];

  self.filesList.text = raw;
  
  [self.view addSubview:self.filesList];
}
@end