#import <AppList/AppList.h>

@interface AppInfo : NSObject
  @property (nonatomic, retain) NSString *name;
  @property (nonatomic, retain) NSString *identifier;
  @property (nonatomic, retain) NSString *type;
  @property (nonatomic, retain) NSString *bundle;
  @property (nonatomic, retain) NSString *rawPath;
  @property (nonatomic, retain) NSString *folder;
  @property (nonatomic, retain) NSString *version;
  @property (nonatomic, retain) ALApplicationList *appList;

  - (id)initWithIndentifier:(NSString*)ident withApplications:(ALApplicationList*)apps;
@end