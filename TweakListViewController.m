#import "TweakListViewController.h"

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

	[self loadApps];
}

- (NSInteger) tableView: (UITableView * ) tableView numberOfRowsInSection: (NSInteger) section {
	if (tableView == self.tweakTable) {
		return ([self.tweakList count]);
	}
	return 0;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView * ) tableView {
	return 1;
}

- (UITableViewCell * ) tableView: (UITableView * ) tableView cellForRowAtIndexPath: (NSIndexPath * ) indexPath {
	NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}

	cell.textLabel.text = [self.tweakList objectAtIndex:indexPath.row];

	return cell;
}

- (void) loadApps {
	self.tweakList = nil;
	self.tweakList = [[NSMutableArray alloc] init];

	[tweakList addObject:@"Test thing"];
	[tweakList addObject:@"New Thing"];

	[self.tweakTable reloadData];
}


@end