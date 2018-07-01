//
//  TaxUtility.m
//  TaxCaculater
//
//  Created by admin on 2018/6/27.
//  Copyright © 2018年 flybearTech. All rights reserved.
//

#import "TaxUtility.h"
#import "InsuranceFundModel.h"
@implementation TaxUtility

+ (CGFloat)caculateProfitWithIncome:(CGFloat)income andProfitModel:(InsuranceFundModel *)insuranceModel {
    if (income <=3500) {
        return income;
    }
    CGFloat profit = 0;
    CGFloat profitAfterInsurance = income - insuranceModel.yanglaoFund -insuranceModel.gongshangFund - insuranceModel.shiyeFund - insuranceModel.shengyuFund - insuranceModel.yiliaoFund -insuranceModel.gongjijinFund;
    CGFloat needTaxIncome = profitAfterInsurance - 3500;
    if (needTaxIncome  > 0 && needTaxIncome <= 1500)
    {
        profit =profitAfterInsurance - needTaxIncome*0.03;
        return profit;
    }
    else if(needTaxIncome  > 1500 && needTaxIncome <= 4500) {
        profit = profitAfterInsurance - (needTaxIncome-1500) * 0.1 - 1500 * 0.03;
    }
    else if (needTaxIncome > 4500 && needTaxIncome < 9000) {
        profit = profitAfterInsurance - (needTaxIncome-4500)*0.2 - (4500 - 1500)*0.1 - 1500 * 0.03;
    }
    else if (needTaxIncome >9000 && needTaxIncome <35000) {
        profit = profitAfterInsurance -(needTaxIncome - 9000)*0.25- (9000-4500)*0.2 - (4500 - 1500)*0.1 - 1500 * 0.03;
    }
    else if (needTaxIncome >35000 && needTaxIncome <55000) {
        profit = profitAfterInsurance - (needTaxIncome - 35000)*0.3 - (35000 - 9000)*0.25 - (9000-4500)*0.2 - (4500 - 1500)*0.1 - 1500 * 0.03;
    }
    else if (needTaxIncome >55000 && needTaxIncome < 80000) {
        profit = profitAfterInsurance -(needTaxIncome - 55000) * 0.35 - (55000 - 35000)*0.3 - (35000 - 9000)*0.25 - (9000-4500)*0.2 - (4500 - 1500)*0.1 - 1500 * 0.03;
    }
    else {
        profit = profitAfterInsurance -(needTaxIncome -80000)*0.45  -(80000 - 55000) * 0.35 - (55000 - 35000)*0.3 - (35000 - 9000)*0.25 - (9000-4500)*0.2 - (4500 - 1500)*0.1 - 1500 * 0.03;
    }
    NSLog(@"profit:%f",profit);
    return profit;
}

+ (InsuranceFundModel  *)getInsuranceWithIncome:(CGFloat)income andCity:(NSString *)city {
    InsuranceFundModel *insuranceModel = [[InsuranceFundModel alloc] init];
    insuranceModel.yanglaoFund = income * 0.08;
    insuranceModel.yiliaoFund = income * 0.02;
    insuranceModel.shengyuFund = income * 0 ;
    insuranceModel.gongshangFund = income * 0.005;
    insuranceModel.shiyeFund = income * 0.002;
    insuranceModel.gongjijinFund = income * 0.05;
    NSLog(@"insurnace:yanglaoFund:%f,yiliaoFund:%f,shengyuFund:%f,gongshangFund:%f,shiyeFund:%f,gongjijinFund:%f",insuranceModel.yanglaoFund,insuranceModel.yiliaoFund,insuranceModel.shengyuFund,insuranceModel.gongshangFund,insuranceModel.shiyeFund,insuranceModel.gongjijinFund);
    return insuranceModel;
}

+ (InsuranceFundModel  *)getCompanyInsuranceWithIncome:(CGFloat)income andCity:(NSString *)city {
    InsuranceFundModel *insuranceModel = [[InsuranceFundModel alloc] init];
    insuranceModel.yanglaoFund = income * 0.22;
    insuranceModel.yiliaoFund = income * 0.1;
    insuranceModel.shengyuFund = income * 0 ;
    insuranceModel.gongshangFund = income * 0.005;
    insuranceModel.shiyeFund = income * 0.002;
    insuranceModel.gongjijinFund = income * 0.05;

    return insuranceModel;
}

@end
