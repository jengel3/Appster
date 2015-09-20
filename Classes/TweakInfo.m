#import "TweakInfo.h"
#import "Utilities.h"

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

  -(id)initWithIdentifier:(NSString*)ident andInfo:(NSDictionary*)tweakMap {
    self.package = ident;
    self.name = [tweakMap objectForKey:@"Name"];
    self.rawData = tweakMap;
    if (!self.name) {
      self.name = package;
    }

    self.depiction = [tweakMap objectForKey:@"Depiction"];
    self.architecture = [tweakMap objectForKey:@"Architecture"];
    self.installSize = [tweakMap objectForKey:@"Installed-Size"];

    self.author = [tweakMap objectForKey:@"Author"];
    self.maintainer = [tweakMap objectForKey:@"Maintainer"];
    self.version = [tweakMap objectForKey:@"Version"];
    self.section = [tweakMap objectForKey:@"Section"];
    self.description = [tweakMap objectForKey:@"Description"];

    self.authorEmail = self.author ? [Utilities emailForControl:self.author] : nil;
    self.maintainerEmail = self.maintainer ? [Utilities emailForControl:self.maintainer] : nil;

    self.author = self.authorEmail ? [Utilities usernameForControl:self.author andEmail:self.authorEmail] : self.author;
    self.maintainer = self.maintainerEmail ? [Utilities usernameForControl:self.maintainer andEmail:self.maintainerEmail] : self.maintainer;

    return self;
  }

  +(id)tweakForProperty:(NSString*)prop withValue:(NSString*)val andData:(NSMutableArray*)data {
    NSLog(@"CALLED %@ -- %@ -- %@", prop, val, data);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@", prop, val]];
    NSArray *filtered = [data filteredArrayUsingPredicate:predicate];
    if (filtered) {
      NSLog(@"NOT NIl");
      return (TweakInfo*)[filtered objectAtIndex:0];
    }
    return nil;
  }
@end