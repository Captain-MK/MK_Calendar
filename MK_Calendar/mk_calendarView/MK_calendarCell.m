//
//  MK_calendarCell.m
//  MK_Calendar
//
//  Created by MK on 2018/4/13.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MK_calendarCell.h"
#import "UIColor+HexColor.h"
@implementation MK_calendarCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        selectionLayer.fillColor = [UIColor colorWithHexString:@"ffddd6"].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        
        CAShapeLayer *middleLayer = [[CAShapeLayer alloc] init];
        middleLayer.fillColor = [UIColor colorWithHexString:@"ffddd6"].CGColor;
        middleLayer.actions = @{@"hidden":[NSNull null]}; // Remove hiding animation
        [self.contentView.layer insertSublayer:middleLayer below:self.titleLabel.layer];
        self.middleLayer = middleLayer;
        
        //         Hide the default selection layer
        self.shapeLayer.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateUI];
}
- (void)updateUI{
    self.titleLabel.frame = self.contentView.bounds;
    CGFloat diameter = 25.f;
    CGFloat center_y = self.titleLabel.center.y;
    CGFloat center_x = self.titleLabel.center.x;
    CGFloat w = 25/2.f;
    if (self.selectionType == SelectionTypeMiddle) {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, center_y-w, self.titleLabel.frame.size.width, diameter)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, center_y-w, self.titleLabel.frame.size.width, diameter)].CGPath;
    } else if (self.selectionType == SelectionTypeLeftBorder) {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center_x-w, center_y-w, center_x+w, diameter) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(w, w)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(center_x-w, center_y-w, center_x+w, diameter) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(w, w)].CGPath;
    } else if (self.selectionType == SelectionTypeRightBorder) {
        self.selectionLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, center_y-w, center_x+w, diameter) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(w, w)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, center_y-w, center_x+w, diameter) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(w, w)].CGPath;
    } else if (self.selectionType == SelectionTypeSingle) {
        self.selectionLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.frame.size.width/2-diameter/2, self.contentView.frame.size.height/2-diameter/2, diameter, diameter)].CGPath;
        self.middleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.frame.size.width/2-diameter/2, self.contentView.frame.size.height/2-diameter/2, diameter, diameter)].CGPath;
    }else if(self.selectionType == SelectionTypeNone){
        self.selectionLayer.hidden = YES;
        self.middleLayer.hidden = YES;
    }
}
- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}
- (void)configureAppearance
{
    [super configureAppearance];
}
@end
