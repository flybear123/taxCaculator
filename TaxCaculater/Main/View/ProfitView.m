//
//  ProfitView.m
//  TaxCaculater
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 flybearTech. All rights reserved.
//

#import "ProfitView.h"

@implementation ProfitView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _profitLabel = [[UILabel alloc] init];
    _profitLabel.textColor  = [UIColor redColor];
    _profitLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    [self addSubview:_profitLabel];
    [_profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
        make.top.equalTo(self.mas_top).offset(0);
    }];
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = [UIColor lightGrayColor];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:noteLabel];
    [noteLabel   mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_profitLabel.mas_left).offset(-5);
        make.bottom.equalTo(_profitLabel.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@21);
    }];
    noteLabel.text = @"税后收入:";
}

-(void)setupWithIncome:(CGFloat)income {
    _profitLabel.text = [NSString stringWithFormat:@"%0.1f元",income];
    NSDictionary *textAtt = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:25.0f]};
    CGFloat contentW = ceil([_profitLabel.text boundingRectWithSize:CGSizeMake(Pd_Screen_width - 100, 50) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading  attributes:textAtt context:nil].size.width);
    [_profitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(contentW));
    }];
}

@end
