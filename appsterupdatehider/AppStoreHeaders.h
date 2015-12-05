#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ASUpdatesViewController
- (void)_setUpdatesPageWithUpdates:(id)arg1 fromCache:(char)arg2 ;
@end

@interface SSSoftwareUpdate : NSObject
@property (nonatomic, readonly) NSString *bundleIdentifier;
@property (nonatomic, readonly) long long storeItemIdentifier;
@property (nonatomic, readonly) NSDictionary *updateDictionary;
@property (nonatomic) int updateState;

- (id)bundleIdentifier;
- (void)setInstallDate:(id)arg1;
- (void)setUpdateState:(int)arg1;
- (long long)storeItemIdentifier;
- (id)updateDictionary;
- (int)updateState;
@end
