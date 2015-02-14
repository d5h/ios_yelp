//
//  SegmentCell.m
//  Yelp
//
//  Created by Dan Hipschman on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SegmentCell.h"

@interface SegmentCell ()

- (IBAction)segmentValueChanged:(id)sender;

@end

@implementation SegmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)segmentValueChanged:(id)sender {
    [self.delegate segmentCell:self didUpdate:self.segmentControl.selectedSegmentIndex];
}

@end
