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

  -(id)initWithIdentifier:(NSString*)ident andInfo:(NSDictionary*)tweakMap {
    self.package = ident;
    self.name = [self.tweakMap objectForKey:@"Name"];
    if (!self.name) {
      self.name = package;
    }

    self.depiction = [self.tweakMap objectForKey:@"Depiction"];
    self.architecture = [self.tweakInfo objectForKey:@"Architecture"];
    self.installSize = [self.tweakInfo objectForKey:@"Installed-Size"];

    self.author = [self.tweakMap objectForKey:@"Author"];
    self.maintainer = [self.tweakMap objectForKey:@"Maintainer"];
    self.version = [self.tweakMap objectForKey:@"Version"];
    self.section = [self.tweakMap objectForKey:@"Section"];
    self.description = [self.tweakMap objectForKey:@"Description"];

    self.authorEmail = self.author ? [Utilities emailForControl:self.author] : nil;
    self.maintainerEmail = self.maintainer ? [Utilities emailForControl:self.maintainer] : nil;

    self.author = self.authorEmail ? [Utilities usernameForControl:self.author andEmail:self.authorEmail] : self.author;
    self.maintainer = self.maintainerEmail ? [Utilities usernameForControl:self.maintainer andEmail:self.maintainerEmail] : self.maintainer;

    return self;
  }
@end