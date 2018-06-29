//
//  ProfitView.h
//  TaxCaculater
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 flybearTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfitView : UIView

@property(nonatomic,strong)UILabel *profitLabel;

-(void)setupWithIncome:(CGFloat)income;

@end
