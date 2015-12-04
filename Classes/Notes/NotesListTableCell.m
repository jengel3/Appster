#import "NotesListTableCell.h"
#import "../PureLayout/PureLayout.h"

#define horizontalInset 15.0f
#define verticalInset 10.0f

@implementation NotesListTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      
    self.titleLabel = [UILabel newAutoLayoutView];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.titleLabel setNumberOfLines:1];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];

    self.bodyLabel = [UILabel newAutoLayoutView];
    [self.bodyLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.bodyLabel setNumberOfLines:0];
    [self.bodyLabel setTextAlignment:NSTextAlignmentLeft];

    self.authorLabel = [UILabel newAutoLayoutView];
    [self.authorLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.authorLabel setNumberOfLines:1];
    [self.authorLabel setTextAlignment:NSTextAlignmentLeft];

    [self.contentView addSubview:self.bodyLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.authorLabel];
  }
  
  return self;
}

- (void)updateConstraints {
  if (!self.didSetupConstraints) {
    // setup title
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.titleLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];

    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:verticalInset];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];

    // setup body 

    [self.bodyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:verticalInset];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.bodyLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }]; 
    [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
    [self.bodyLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];

    // setup author 

    [self.authorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bodyLabel withOffset:verticalInset];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
      [self.authorLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:verticalInset];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:horizontalInset];
    [self.authorLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:horizontalInset];
    
    self.didSetupConstraints = YES;
  }
    
  [super updateConstraints];
}

@end