#import "AppInfo.h"

@implementation AppInfo
  @synthesize name;
  @synthesize identifier;
  @synthesize type;
  @synthesize bundle;
  @synthesize rawPath;
  @synthesize folder;
  @synthesize version;

  - (id)initWithIndentifier:(NSString*)ident withApplications:(ALApplicationList*)apps {
    self.identifier = ident;

    self.name = [apps valueForKey:@"displayName" forDisplayIdentifier:self.identifier];
    self.rawPath = [apps valueForKey:@"path" forDisplayIdentifier:self.identifier];


    if ([rawPath hasPrefix:@"/Applications"]) {
      self.type = @"System";
      self.folder = @"/Applications/";
      self.bundle = [self.rawPath stringByReplacingOccurrencesOfString:@"/Applications/" withString:@""];
    } else if ([self.rawPath hasPrefix:@"/private/"]) {
      self.type = @"iTunes";

      NSArray *split = [rawPath componentsSeparatedByString:@"/"];
      self.folder = [split objectAtIndex:[split count] - 2];
      self.bundle = [split lastObject];
    }

    self.version = [apps valueForKey:@"bundleVersion" forDisplayIdentifier:self.identifier];

    return self;
  }

  - (NSString*) description {
    return self.name; 
  }
@end