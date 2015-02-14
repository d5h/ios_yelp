//
//  SegmentCell.h
//  Yelp
//
//  Created by Dan Hipschman on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentCell;

@protocol SegmentCellDelegate <NSObject>

- (void)segmentCell:(SegmentCell *)cell didUpdate:(NSInteger)value;

@end

@interface SegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, weak) id<SegmentCellDelegate> delegate;


@end
