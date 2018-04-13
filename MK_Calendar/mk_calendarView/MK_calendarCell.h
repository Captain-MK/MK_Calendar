//
//  MK_calendarCell.h
//  MK_Calendar
//
//  Created by MK on 2018/4/13.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "FSCalendarCell.h"
typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};
@interface MK_calendarCell : FSCalendarCell
@property (weak, nonatomic) CAShapeLayer *selectionLayer;
@property (assign, nonatomic) SelectionType selectionType;
@property (weak, nonatomic) CAShapeLayer *middleLayer;
@end
