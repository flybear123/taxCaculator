//
//  TaxViewController.m
//  TaxCaculater
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 flybearTech. All rights reserved.
//

#import "TaxViewController.h"
#import "PdTaxMoneyCell.h"
#import "PdTaxInsuranceCell.h"
#import "TaxModel.h"
#import "PersonInsuranceModel.h"
#import "PdTaxTitleCell.h"
#import "TaxFormView.h"
#import "ProfitView.h"
//#import "TaxtitleHeadie.xib"
static NSString *const kTaxTitleItemCellId = @"kTaxTitleItemCellId";
static NSString *const kTaxInsuranceItemCellId = @"kTaxInsuranceItemCellId";
@interface TaxViewController ()
<
UIScrollViewDelegate
>
{
    UIView *_categoryView;
}
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *insureArray;
@property (nonatomic,strong)UIView      *incomeView;
@property (nonatomic,strong)UIView      *cityView;


@property (nonatomic,strong)UIView      *titleHeadView;
@property (nonatomic,strong)TaxFormView *yanglaoView;
@property (nonatomic,strong)TaxFormView *yiliaoView;
@property (nonatomic,strong)TaxFormView *shiyeView;
@property (nonatomic,strong)TaxFormView *shengyuView;
@property (nonatomic,strong)TaxFormView *gongshangView;
@property (nonatomic,strong)ProfitView  *profitView;
@end

@implementation TaxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"个税计算器";
    [self initData];
    [self initViews];
    
    // Do any additional setup after loading the view.
}

- (void)initData {

    if (!_insureArray) {
        _insureArray = [[NSMutableArray alloc] init];
    }
    NSArray *yanglaoArray = @[@"养老",@"0.08",@"0",@"0.22",@"0"];
    NSArray *yiliaoArray = @[@"医疗",@"0.02",@"0",@"0.11",@"0"];
    NSArray *shiyeArray = @[@"失业",@"0.005",@"0",@"0.015",@"0"];
    NSArray *shengyuArray = @[@"生育",@"0.08",@"0",@"0.22",@"0"];
    NSArray *gongshangArray = @[@"工伤",@"0.08",@"0",@"0.22",@"0"];

    
    NSArray *array = @[yanglaoArray,yiliaoArray,shiyeArray,shengyuArray,gongshangArray];
    for (int i=0; i<array.count; i++) {
        PersonInsuranceModel *model =[[PersonInsuranceModel alloc]init];
        NSArray *subArr = [array objectAtIndex:i];
        model.insuranceName = [subArr objectAtIndex:0];
        model.personRate = [subArr objectAtIndex:1];
        model.personFund = [subArr objectAtIndex:2];
        model.companyRate = [subArr objectAtIndex:3];
        model.companyFund = [subArr objectAtIndex:4];
        [self.insureArray addObject:model];
    }
    
}

- (void)initViews {
    [self initIncomeView];
    [self initTaxCategoryView];
    [self initTaxTitleView];
    [self initTaxView];
    [self initProfitLabel];
}

- (void)initIncomeView {
    UIView *incomeView = [[UIView alloc] initWithFrame:CGRectMake(0, Pd_Top_Bar_Height, Pd_Screen_width, 44)];
    [self.view addSubview:incomeView];
    self.incomeView = incomeView;
    UILabel *incomeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    incomeNameLabel.text = @"税前工资";
    [incomeView addSubview:incomeNameLabel];
    UITextField *incomeTextField = [[UITextField alloc] init];
    incomeTextField.placeholder = @"(元)";
    incomeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [incomeView addSubview:incomeTextField];
    
    [incomeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(incomeView.mas_left).offset(15);
        make.height.equalTo(incomeView.mas_height);
        make.width.equalTo(@80);
        make.top.equalTo(incomeView.mas_top);
    }];
    
    [incomeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(incomeNameLabel.mas_right).offset(0);
        make.height.equalTo(incomeView.mas_height);
        make.width.equalTo(@180);
        make.top.equalTo(incomeView.mas_top);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taxInputChange:) name:UITextFieldTextDidChangeNotification object:nil];

    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, incomeView.bottom, Pd_Screen_width, 44)];
    [self.view addSubview:cityView];
    self.cityView = cityView;
    UILabel *cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    cityNameLabel.text = @"所在城市";
    [cityView addSubview:cityNameLabel];
    UITextField *cityTextField = [[UITextField alloc] init];
    cityTextField.placeholder = @"深圳(点此更换城市)";
    [cityView addSubview:cityTextField];
    
    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityView.mas_left).offset(15);
        make.height.equalTo(cityView.mas_height);
        make.width.equalTo(@80);
        make.top.equalTo(cityView.mas_top);
    }];
    
    [cityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityNameLabel.mas_right);
        make.width.equalTo(@240);
        make.height.equalTo(cityView.mas_height);
        make.top.equalTo(cityView.mas_top);
    }];
}



- (void)initTaxCategoryView {
    UIView *categoryView = [[UIView alloc] init];
    [self.view addSubview:categoryView];
    _categoryView = categoryView;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    UILabel *personCatView = [[UILabel alloc] init];
    personCatView.text = @"个人";
    personCatView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:personCatView];
    [personCatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(Pd_Screen_width/5);
        make.width.equalTo(@(Pd_Screen_width*2/5));
        make.top.equalTo(categoryView.mas_top);
        make.bottom.equalTo(categoryView.mas_bottom);
    }];
    
    UILabel *companyCatView = [[UILabel alloc] init];
    companyCatView.text = @"单位";
    companyCatView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:companyCatView];
    [companyCatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personCatView.mas_right).offset(0);
        make.right.equalTo(categoryView.mas_right);
        make.top.equalTo(categoryView.mas_top);
        make.bottom.equalTo(categoryView.mas_bottom);
    }];
    
    
}

- (void)initTaxTitleView {
    UIView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TaxTitleHeadView" owner:self options:nil] lastObject];
    _titleHeadView = titleView;
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_categoryView.mas_bottom);
        make.left.equalTo(_categoryView.mas_left);
        make.right.equalTo(_categoryView.mas_right);
        make.height.equalTo(@44);
    }];
}

- (void)initTaxView {
    _yanglaoView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    _yiliaoView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    _shiyeView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    _shengyuView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    _gongshangView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    
    [self.view addSubview:_yanglaoView];
    [self.view addSubview:_yiliaoView];
    [self.view addSubview:_shiyeView];
    [self.view addSubview:_shengyuView];
    [self.view addSubview:_gongshangView];
    
    [_yanglaoView initWithTaxInfo:[self.insureArray objectAtIndex:0]];
    [_yiliaoView initWithTaxInfo:[self.insureArray objectAtIndex:1]];
    [_shiyeView initWithTaxInfo:[self.insureArray objectAtIndex:2]];
    [_shengyuView initWithTaxInfo:[self.insureArray objectAtIndex:3]];
    [_gongshangView initWithTaxInfo:[self.insureArray objectAtIndex:4]];
    
    [_yanglaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleHeadView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    [_yiliaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yanglaoView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    [_shiyeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_yiliaoView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    [_shengyuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shiyeView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    [_gongshangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_shengyuView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
}

- (void)initProfitLabel {
    _profitView = [[ProfitView alloc] init];
    [self.view addSubview:_profitView];
    [_profitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.top.equalTo(_gongshangView.mas_bottom).offset(30);
    }];
    [_profitView setupWithIncome:0];
}

#pragma mark -- UITextInputChange
- (void)taxInputChange :(NSNotification *)noti {

    UITextField *textField = noti.object;
    CGFloat income = [textField.text floatValue];
    
    
    
    [_profitView setupWithIncome:income];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
