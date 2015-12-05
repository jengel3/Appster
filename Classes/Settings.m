#import "Settings.h"

/*
  Custom settings wrapper to make it easier
  to sync preferences between Appster, 
  AppsterUpdateHider, and the Appster preference
  bundle.
 */

#define valuesPath @"/User/Library/Preferences/com.jake0oo0.appster.plist"

@implementation AppsterSettings
@synthesize preferences;

-(id)init {
  self.preferences = [self loadData];
  return self;
}

-(NSDictionary *)loadData {
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:valuesPath];
  if (!settings) {
    settings = [[NSDictionary alloc] init];
  }
  return [settings mutableCopy];
}

-(BOOL)reload {
  self.preferences = [self loadData];
  return YES;
}

-(void)setValue:(id)val forKey:(id)key {
  [self.preferences setValue:val forKey:key];
  [self.preferences writeToFile:valuesPath atomically:NO];
}

-(id)valueForKey:(NSString *)key {
  return ([self.preferences objectForKey:key] ? [self.preferences objectForKey:key] : nil);
}

-(id)valueForKey:(NSString *)key orDefault:(id)def {
  return ([self.preferences objectForKey:key] ? [self.preferences objectForKey:key] : def);
}
@end