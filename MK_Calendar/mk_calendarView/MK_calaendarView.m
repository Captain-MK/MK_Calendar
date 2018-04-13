//
//  MK_calaendarView.m
//  MK_Calendar
//
//  Created by MK on 2018/4/13.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "MK_calaendarView.h"
#import <FSCalendar.h>
#import "MK_calendarCell.h"
#import "UIColor+HexColor.h"
@interface MK_calaendarView ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (weak, nonatomic) IBOutlet UILabel *middleLable;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSCalendar *gregorian;
// The start date of the range
@property (strong, nonatomic) NSDate *date1;
// The end date of the range
@property (strong, nonatomic) NSDate *date2;
@end
@implementation MK_calaendarView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.calendarView.today = nil;
    self.calendarView.allowsMultipleSelection = YES;
    self.calendarView.placeholderType = FSCalendarPlaceholderTypeFillSixRows;
    self.calendarView.swipeToChooseGesture.enabled = YES;
    
    self.middleLable.text = [self.dateFormatter stringFromDate:self.calendarView.currentPage];//默认显示当前月
    [self.calendarView registerClass:[MK_calendarCell class] forCellReuseIdentifier:@"cell"];
}
- (IBAction)handleTapSureBtn:(id)sender {
    if (self.date1 == nil && self.date2 == nil) {
//        [ITTPromptView showMessage:@"请选择日期" andFrameY:0];
        return;
    }
    if (self.date1 == nil) {
//        [ITTPromptView showMessage:@"日期选择错误" andFrameY:0];
        return;
    }
    NSComparisonResult compare=[self.gregorian compareDate:self.date1 toDate:self.date2 toUnitGranularity:NSCalendarUnitDay];
    if (compare==1) {
        NSDate *temp;
        temp = self.date1;
        self.date1 = self.date2;
        self.date2 = temp;
    }
    if ([self.delegate respondsToSelector:@selector(handleTapSureBtn:starDate:endDate:)]) {
        [self.delegate handleTapSureBtn:labs([self daySWithFromDate:self.date1 toDate:self.date2]) starDate:[self.dateFormatter stringFromDate:self.date1] endDate:[self.dateFormatter stringFromDate:self.date2]];
    }
}
- (IBAction)handleTapCancle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(handleTapCancle)]) {
        [self.delegate handleTapCancle];
    }
}
#pragma mark - ========FSCalendarDelegate========
-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [NSDate new];
}
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:10 toDate:[NSDate date] options:0];
}
- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self oneNumberDay:date] == 1) {
        return [NSString stringWithFormat:@"%ld月",(long)[self MonthNumber:date]];
    }
    return nil;
}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    MK_calendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];
    return cell;
}
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition
{
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];//防止数据错位
}
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    self.middleLable.text = [self.dateFormatter stringFromDate:calendar.currentPage];
}
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return monthPosition == FSCalendarMonthPositionCurrent;
}
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    return NO;
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"didSelectDate %@", date);
    if (calendar.swipeToChooseGesture.state == UIGestureRecognizerStateChanged) {
        // If the selection is caused by swipe gestures
        if (!self.date1) {
            self.date1 = date;
        } else {
            if (self.date2) {
                [calendar deselectDate:self.date2];
            }
            self.date2 = date;
        }
    } else {
        if (self.date2) {
            [calendar deselectDate:self.date1];
            [calendar deselectDate:self.date2];
            self.date1 = date;
            self.date2 = nil;
        } else if (!self.date1) {
            self.date1 = date;
        } else {
            self.date2 = date;
        }
    }
    if (self.date1 && self.date2) {
        NSComparisonResult compare=[self.gregorian compareDate:self.date1 toDate:self.date2 toUnitGranularity:NSCalendarUnitDay];
        if (compare==1) {
            NSDate *temp;
            temp = self.date1;
            self.date1 = self.date2;
            self.date2 = temp;
        }
    }
    [self configureVisibleCells];
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did deselect date %@",[self.dateFormatter stringFromDate:date]);
    [self configureVisibleCells];
}
#pragma mark - ========Private methods========
- (void)configureVisibleCells
{
    [self.calendarView.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendarView dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendarView monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}
- (void)configureCell:(__kindof FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position
{
    MK_calendarCell *rangeCell = cell;
    if (position != FSCalendarMonthPositionCurrent) {
        rangeCell.selectionType = SelectionTypeNone;
        rangeCell.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        return;
    }
    BOOL isSelected = NO;
    isSelected |= self.date1 && [self.gregorian isDate:date inSameDayAsDate:self.date1];
    isSelected |= self.date2 && [self.gregorian isDate:date inSameDayAsDate:self.date2];
    rangeCell.selectionLayer.hidden = !isSelected;
    rangeCell.selectionType = SelectionTypeSingle;
    if (self.date1 && self.date2) {
        SelectionType selectionType = SelectionTypeNone;
        // The date is in the middle of the range
        BOOL isMiddle = [date compare:self.date1] != [date compare:self.date2];
        rangeCell.middleLayer.hidden = !isMiddle;
        if (isMiddle) {
            //            NSLog(@"%@",[self.dateFormatter stringFromDate:date]);
            if ([date compare:[NSDate new]] == NSOrderedDescending || [date compare:[NSDate new]] == NSOrderedSame) {
                rangeCell.titleLabel.textColor = [UIColor colorWithHexString:@"ff5533"];
            }
            NSInteger weekday = [self weekDay:date];
            if (weekday == 1) {
                selectionType = SelectionTypeLeftBorder;
            }else if (weekday == 7){
                selectionType = SelectionTypeRightBorder;
            }else{
                selectionType = SelectionTypeMiddle;
            }
        }
        if (date == self.date1){
            selectionType = SelectionTypeLeftBorder;
        }
        if (date == self.date2){
            selectionType = SelectionTypeRightBorder;
        }
        rangeCell.selectionType = selectionType;
    } else {
        rangeCell.middleLayer.hidden = YES;
        if (position != FSCalendarMonthPositionCurrent) {
            rangeCell.titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
            return;
        }
        if ([date compare:[NSDate new]] == NSOrderedDescending || [date compare:[NSDate new]] == NSOrderedSame) {
            rangeCell.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        }
        if (date==self.date1) {
            rangeCell.titleLabel.textColor = [UIColor colorWithHexString:@"ff5533"];
        }
    }
}
//是否是1号
- (NSInteger)oneNumberDay:(NSDate *)date{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitDay fromDate:date];
    NSInteger dayNum = [componets day];
    return dayNum;
}
- (NSInteger)MonthNumber:(NSDate *)date{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitMonth fromDate:date];
    NSInteger Num = [componets month];
    return Num;
}
- (NSInteger)weekDay:(NSDate *)date{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [componets weekday];
    return weekday;
}
- (NSInteger)daySWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSDateComponents *comp = [self.gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
    return comp.day+1;
}
#pragma mark - ========lazy========
-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy.MM.dd";
    }
    return _dateFormatter;
}
-(NSCalendar *)gregorian{
    if (!_gregorian) {
        _gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return _gregorian;
}
@end
