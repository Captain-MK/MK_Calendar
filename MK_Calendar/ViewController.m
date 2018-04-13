//
//  ViewController.m
//  MK_Calendar
//
//  Created by MK on 2018/4/13.
//  Copyright © 2018年 MK. All rights reserved.
//

#import "ViewController.h"
#import "MK_calaendarView.h"
#import "UIColor+HexColor.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define kBarFrame [[UIApplication sharedApplication] statusBarFrame]
@interface ViewController ()<MK_calaendarViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dateNum;
@property (weak, nonatomic) IBOutlet UILabel *dayNum;
@property (strong, nonatomic) MK_calaendarView *calendar;
@property (strong, nonatomic) UIView *coverView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapCoverView)];
    self.coverView.userInteractionEnabled = YES;
    [self.coverView addGestureRecognizer:tap];
}
- (IBAction)handleTapLeaveDays:(id)sender {
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.calendar];
    [UIView animateWithDuration:0.5f animations:^{
        self.coverView.alpha = 1;
        self.calendar.frame = CGRectMake(0, screen_height-356, screen_width, 356);
    }];
}
- (void)handleTapCoverView{
    [UIView animateWithDuration:0.5f animations:^{
        self.coverView.alpha = 0;
        self.calendar.frame = CGRectMake(0, screen_height, screen_width, 356);
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - ========HY_FSCalendarDelegate========
-(void)handleTapCancle{
    [self handleTapCoverView];
}
-(void)handleTapSureBtn:(NSInteger)days starDate:(NSString *)starDate endDate:(NSString *)endDate{
    [self handleTapCoverView];
    NSLog(@"(%@-%@) %ld",starDate,endDate,(long)days);
    if (starDate == nil ||starDate.length == 0) {
        self.dateNum.text = [NSString stringWithFormat:@"(%@)",endDate];
    }else{
        self.dateNum.text = [NSString stringWithFormat:@"(%@-%@)",starDate,endDate];
    }
    self.dayNum.text = [NSString stringWithFormat:@"%ld天",days];
    self.dayNum.textColor = [UIColor colorWithHexString:@"ff5533"];
}
-(MK_calaendarView *)calendar{
    if (!_calendar) {
        _calendar = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([MK_calaendarView class]) owner:self options:nil].lastObject;
        _calendar.delegate = self;
        _calendar.frame = CGRectMake(0, screen_height, screen_width, 356);
    }
    return _calendar;
}
-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    }
    return _coverView;
}
@end
