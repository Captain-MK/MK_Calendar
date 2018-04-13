//
//  MK_calaendarView.h
//  MK_Calendar
//
//  Created by MK on 2018/4/13.
//  Copyright © 2018年 MK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MK_calaendarViewDelegate <NSObject>
- (void)handleTapSureBtn:(NSInteger)days starDate:(NSString *)starDate endDate:(NSString *)endDate;
- (void)handleTapCancle;
@end
@interface MK_calaendarView : UIView
@property(nonatomic,weak) id <MK_calaendarViewDelegate> delegate;
@end
