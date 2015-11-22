#import "AppInfo.h"

@implementation AppInfo
  @synthesize name;
  @synthesize identifier;
  @synthesize type;
  @synthesize bundle;
  @synthesize rawPath;
  @synthesize folder;
  @synthesize version;
  @synthesize icon;

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

    self.bundleVersion = [apps valueForKey:@"bundleVersion" forDisplayIdentifier:self.identifier];

    [self loadExtraInfo];

    return self;
  }

  - (void)loadExtraInfo {
    NSString *metaPath = [NSString stringWithFormat:@"/private/var/mobile/Containers/Bundle/Application/%@/%@", self.folder, @"iTunesMetadata.plist"];
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] initWithContentsOfFile:metaPath];

    self.artist = [metadata objectForKey:@"artistName"];
    self.pk = [metadata objectForKey:@"itemId"];
    self.purchaserAccount = [[metadata objectForKey:@"com.apple.iTunesStore.downloadInfo"] valueForKeyPath:@"accountInfo.AppleID"];
    self.purchaseDate = [[metadata objectForKey:@"com.apple.iTunesStore.downloadInfo"] valueForKeyPath:@"purchaseDate"];
    self.releaseDate = [metadata objectForKey:@"releaseDate"];
    self.version = [metadata objectForKey:@"bundleShortVersionString"];
  }

  - (NSString*) description {
    return self.name; 
  }

  - (BOOL)isiTunes {
    return [self.type isEqualToString:@"iTunes"];
  }

  - (BOOL)isSystem {
    return [self.type isEqualToString:@"System"];
  }
@end