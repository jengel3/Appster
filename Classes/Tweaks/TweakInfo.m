#import "TweakInfo.h"
#import "../Utilities.h"

@implementation TweakInfo
@synthesize package;
@synthesize name;
@synthesize author;
@synthesize authorEmail;
@synthesize maintainer;
@synthesize maintainerEmail;
@synthesize version;
@synthesize description;
@synthesize architecture;
@synthesize installSize;
@synthesize section;
@synthesize depiction;
@synthesize rawData;
@synthesize installed;

-(id)initWithIdentifier:(NSString *)ident andInfo:(NSDictionary *)tweakMap {
  self.package = ident;
  self.name = [tweakMap objectForKey:@"Name"];
  self.rawData = tweakMap;
  if (!self.name) {
    self.name = package;
  }

  self.depiction = [tweakMap objectForKey:@"Depiction"];
  self.architecture = [tweakMap objectForKey:@"Architecture"];
  self.installSize = [tweakMap objectForKey:@"Installed-Size"];
  self.version = [tweakMap objectForKey:@"Version"];
  self.section = [tweakMap objectForKey:@"Section"];
  self.description = [tweakMap objectForKey:@"Description"];

  NSString *rawStatus = [tweakMap objectForKey:@"Status"];

  if ([rawStatus rangeOfString:@"deinstall"].location == NSNotFound && 
    [rawStatus rangeOfString:@"not-installed"].location == NSNotFound) {
    self.installed = YES;
  } else {
    self.installed = NO;
  }

  self.author = [tweakMap objectForKey:@"Author"];
  self.maintainer = [tweakMap objectForKey:@"Maintainer"];

  self.authorEmail = self.author ? [Utilities emailForControl:self.author] : nil;
  self.maintainerEmail = self.maintainer ? [Utilities emailForControl:self.maintainer] : nil;

  self.author = self.authorEmail ? [Utilities usernameForControl:self.author andEmail:self.authorEmail] : self.author;
  self.maintainer = self.maintainerEmail ? [Utilities usernameForControl:self.maintainer andEmail:self.maintainerEmail] : self.maintainer;

  return self;
}

+ (id)tweakForProperty:(NSString *)prop withValue:(NSString *)val andData:(NSMutableArray *)data {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == '%@'", prop, val]];
  NSArray *filtered = [data filteredArrayUsingPredicate:predicate];
  if (filtered) {
    return (TweakInfo *)[filtered objectAtIndex:0];
  }
  return nil;
}

- (UIImage *)getIcon:(float)bestFit {
  NSString *iconPath = [self.rawData objectForKey:@"Icon"];
  NSString *tempSec = self.section;
  BOOL existed = false;

  if (iconPath) {

    if ([iconPath hasPrefix:@"file://"]) {
      iconPath = [iconPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }
    existed = [[NSFileManager defaultManager] fileExistsAtPath:iconPath];
    if (existed) {
      UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
      if (bestFit && img.size.width > bestFit) {
        img = [Utilities imageWithImage:img scaledToWidth:bestFit];
      }
      return img;
    }
  } 
  
  if (!tempSec) {
    tempSec = @"Addons";
  }
  iconPath = [NSString stringWithFormat:@"/Applications/Cydia.app/Sections/%@.png", tempSec];
  existed = [[NSFileManager defaultManager] fileExistsAtPath:iconPath];
  if (!existed) {
    tempSec = @"Addons";
  }
  iconPath = [NSString stringWithFormat:@"/Applications/Cydia.app/Sections/%@", tempSec];
  UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
  
  img = [Utilities imageWithImage:img scaledToWidth:img.size.width/4];

  return img;
}
@end