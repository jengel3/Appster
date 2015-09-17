#import "TweakListViewController.h"
#import "TweakInfoViewController.h"

float bestFit;

@implementation TweakListViewController
@synthesize tweakList;
@synthesize tweakTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Cydia Tweaks";
    }
    return self;
}

- (void) viewDidLoad {
	self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
	self.view.backgroundColor = [UIColor whiteColor];

	self.tweakTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tweakTable.dataSource = self;
	self.tweakTable.delegate = self;

	[self.view addSubview:self.tweakTable];

	[self generateTweakInfoList];

	[self loadApps];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView != self.tweakTable)	return 0;

	return [self.tweakMap count];
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
	return 1;
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;

    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	}

	NSString *key = [self.tweakList objectAtIndex:indexPath.row];

	NSDictionary *tweak = (NSDictionary*)[self.tweakMap objectForKey:key];
	NSString *name = [tweak objectForKey:@"Name"];

	if (!name) {
		cell.textLabel.text = key;
	} else {
		cell.textLabel.text = name;
		cell.detailTextLabel.text = key;
	}

	NSString *iconPath = [tweak objectForKey:@"Icon"];
	NSString *section = [tweak objectForKey:@"Section"];

	if (iconPath) {

		if ([iconPath hasPrefix:@"file://"]) {
			iconPath = [iconPath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
		}
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
		if (bestFit && img.size.width > bestFit) {
			img = [TweakListViewController imageWithImage:img scaledToWidth:bestFit];
		}
		cell.imageView.image = img;
	} else if (section) {
		iconPath = [NSString stringWithFormat:@"/Applications/Cydia.app/Sections/%@", section];
		UIImage *img = [[UIImage alloc] initWithContentsOfFile:iconPath];
		
		img = [TweakListViewController imageWithImage:img scaledToWidth:img.size.width/4];
		if (!bestFit) {
			bestFit = img.size.width;
		}

		cell.imageView.image = img;

	} else {
		cell.imageView.image = nil;
	}

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

	NSString *name = cell.textLabel.text;
	NSString *pkg = cell.detailTextLabel.text;

	TweakInfoViewController *tweakView = [[TweakInfoViewController alloc] init];
	tweakView.package = pkg;
	tweakView.name = name;
	tweakView.tweakInfo = [self.tweakMap objectForKey:pkg];

	UITabBarController *tabBarController = (UITabBarController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;

	[(UINavigationController*)tabBarController.selectedViewController pushViewController:tweakView animated:YES];

}

- (void) loadApps {
	[self generateTweakInfoList];

	[self.tweakTable reloadData];
}

-(NSDictionary*)generateTweakInfoList {
	if (!self.tweakMap) {
		NSData* data = [NSData dataWithContentsOfFile:@"/var/lib/dpkg/status"];
		NSString* string = [[NSString alloc] 
			initWithBytes:[data bytes]
	   	length:[data length] 
	  	encoding:NSUTF8StringEncoding];

		NSArray* items = [string componentsSeparatedByString:@"\n"];

		NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
		NSMutableArray *keys = [[NSMutableArray alloc] init];

		for (id i in items) {
			NSString *test = [i stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			if ([test isEqualToString:@""]) continue;
			NSRange match = [i rangeOfString:@":"];
			if (match.location == NSNotFound) continue;
			NSString *key = [i substringToIndex:match.location];
      NSString *value = [i substringFromIndex:match.location+match.length];

			value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

			if ([key isEqualToString:@"Package"]) {
				[keys addObject:value];
				[response setValue:[[NSMutableDictionary alloc] init] forKey:value];
			} else {
				NSString *lastKey = [keys lastObject];
				[[response objectForKey:lastKey] setObject:value forKey:key];
			}

		}

		NSMutableArray *removed = [[NSMutableArray alloc] init];
		for (id key in response) {
			if ([key hasPrefix:@"gsc."]) {
				[removed addObject:key];
			}
		}

		for (id r in removed) {
			[response removeObjectForKey:r];
		}
	
		self.tweakMap = response;
		self.tweakList = [response allKeys];
	}

	return self.tweakMap;
}


@end