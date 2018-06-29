//
//  TaxUtility.h
//  TaxCaculater
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 flybearTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InsuranceFundModel.h"
@interface TaxUtility : NSObject
- (CGFloat)caculateProfitWithIncome:(CGFloat)income andProfitModel:(InsuranceFundModel *)insuranceModel ;

- (InsuranceFundModel  *)caculateInsuranceWithIncome:(CGFloat)income andCity:(NSString *)city ;
@end
