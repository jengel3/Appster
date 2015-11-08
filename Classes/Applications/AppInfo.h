#import <AppList/AppList.h>

@interface AppInfo : NSObject
  @property (nonatomic, retain) NSString *name;
  @property (nonatomic, retain) NSString *pk;
  @property (nonatomic, retain) NSString *identifier;
  @property (nonatomic, retain) NSString *type;
  @property (nonatomic, retain) NSString *bundle;
  @property (nonatomic, retain) NSString *rawPath;
  @property (nonatomic, retain) NSString *folder;
  @property (nonatomic, retain) NSString *version;
  @property (nonatomic, retain) NSString *artist;
  @property (nonatomic, retain) NSString *purchaserAccount;
  @property (nonatomic, retain) NSString *purchaseDate;
  @property (nonatomic, retain) NSString *releaseDate;
  @property (nonatomic, retain) ALApplicationList *appList;

  - (id)initWithIndentifier:(NSString*)ident withApplications:(ALApplicationList*)apps;
  - (void)loadExtraInfo;
  - (BOOL)isiTunes;
  - (BOOL)isSystem;
@end