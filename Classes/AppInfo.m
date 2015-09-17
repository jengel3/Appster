#import "AppInfo.h"

@implementation AppInfo
  @synthesize name;
  @synthesize identifier;
  @synthesize type;
  @synthesize bundle;
  @synthesize rawPath;
  @synthesize folder;
  @synthesize version;
  @synthesize appList;

  - (id)initWithIndentifier:(NSString*)ident withApplications:(ALApplicationList*)apps {
    self.identifier = ident;
    self.appList = apps;

    self.name = [self valueForKey:@"displayName"];
    self.rawPath = [self valueForKey:@"path"];

    if ([rawPath hasPrefix:@"/Applications"]) {
      self.type = @"System App";
      self.folder = @"/Applications/";
      self.bundle = [self.rawPath stringByReplacingOccurrencesOfString:@"/Applications/" withString:@""];
    } else if ([self.rawPath hasPrefix:@"/private/"]) {
      self.Type = @"iTunes App";

      NSArray *split = [rawPath componentsSeparatedByString:@"/"];
      self.folder = [split objectAtIndex:[split count] - 2];
      self.bundle = [split lastObject];
    }

    self.version = [self valueForKey:@"bundleVersion"];

    return self;
  }

  - (id)initWithDisplay:(NSString*)display withApplications:(ALApplicationList*)apps {
    NSArray *t = [apps.applications allKeysForObject:display];
    NSString *ident = [t lastObject];
    return [self initWithIndentifier:ident withApplications:apps];
  }

  - (id)valueForKey:(NSString*)key {
    return [self.appList valueForKey:key forDisplayIdentifier:self.identifier];
  }
@end