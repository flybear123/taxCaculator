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
#import "TaxUtility.h"
#import "PersonInsuranceModel.h"
#import "PdTaxTitleCell.h"
#import "TaxFormView.h"
#import "ProfitView.h"
#define kSocialLowIncome 3500
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
@property (nonatomic,strong)UITextField *incomeTextField;
@property (nonatomic,strong)UIView      *cityView;
@property (nonatomic,strong)UIView      *baseInsuranceView;
@property (nonatomic,strong)UIButton    *yesButton;
@property (nonatomic,strong)UIButton    *noButton ;
@property (nonatomic,strong)UIView      *titleHeadView;
@property (nonatomic,strong)TaxFormView *yanglaoView;
@property (nonatomic,strong)TaxFormView *yiliaoView;
@property (nonatomic,strong)TaxFormView *shiyeView;
@property (nonatomic,strong)TaxFormView *shengyuView;
@property (nonatomic,strong)TaxFormView *gongshangView;
@property (nonatomic,strong)TaxFormView *gongjijinView;

@property (nonatomic,strong)UIView      *cutTaxView;
@property (nonatomic,strong)UILabel     *cutTaxLabel ;
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
    NSArray *yiliaoArray = @[@"医疗",@"0.02",@"0",@"0.10",@"0"];
    NSArray *shiyeArray = @[@"失业",@"0.002",@"0",@"0.01",@"0"];
    NSArray *shengyuArray = @[@"生育",@"0.00",@"0",@"0.008",@"0"];
    NSArray *gongshangArray = @[@"工伤",@"0.00",@"0",@"0.005",@"0"];
    NSArray *gongjijinArray = @[@"公积金",@"0.05",@"0",@"0.05",@"0"];
    
    NSArray *array = @[yanglaoArray,yiliaoArray,shiyeArray,shengyuArray,gongshangArray,gongjijinArray];
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
    [self initCutTaxView];
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
    self.incomeTextField = incomeTextField;
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
    UILabel *cityNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 140, 44)];
    cityNameLabel.text = @"城市基本工资(元)";
    [cityView addSubview:cityNameLabel];
    UITextField *cityTextField = [[UITextField alloc] init];
    cityTextField.placeholder = @"2200";
    [cityView addSubview:cityTextField];
    
    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityView.mas_left).offset(15);
        make.height.equalTo(cityView.mas_height);
        make.width.equalTo(@140);
        make.top.equalTo(cityView.mas_top);
    }];
    
    [cityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cityNameLabel.mas_right);
        make.width.equalTo(@240);
        make.height.equalTo(cityView.mas_height);
        make.top.equalTo(cityView.mas_top);
    }];
    
    UIView *baseInsuranceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cityView.bottom, Pd_Screen_width, 44)];
//    baseInsuranceView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:baseInsuranceView];
    self.baseInsuranceView = baseInsuranceView;
    UILabel *baseLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 44)];
    baseLabel.text = @"按基本工资缴纳社保";
    [baseInsuranceView addSubview:baseLabel];
    
    UIButton *yesButton = [[UIButton alloc] init];
    yesButton.backgroundColor = [UIColor lightGrayColor];
    [baseInsuranceView addSubview:yesButton];
    self.yesButton = yesButton;
    [yesButton setImage:[UIImage imageNamed:@"check_off.png"]forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"ico_Subscribe.png"]forState:UIControlStateSelected];
    yesButton.selected =  YES;
    yesButton.clipsToBounds = YES;
    yesButton.layer.cornerRadius = 10;
    [yesButton addTarget:self action:@selector(yesCheckBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baseLabel.mas_right).offset(10);
        make.centerY.equalTo(baseInsuranceView.mas_centerY);
        make.width.and.height.equalTo(@20);
    }];
    
    UILabel *yesLabel= [[UILabel alloc] init];
    yesLabel.text = @"是";
    [baseInsuranceView addSubview:yesLabel];
    [yesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yesButton.mas_right).offset(10);
        make.centerY.equalTo(baseInsuranceView.mas_centerY);
        make.width.and.height.equalTo(@20);
    }];
    
    UIButton *noButton = [[UIButton alloc] init];
    noButton.backgroundColor = [UIColor lightGrayColor];
    [baseInsuranceView addSubview:noButton];
    self.noButton = noButton;
    [noButton setImage:[UIImage imageNamed:@"check_off.png"]forState:UIControlStateNormal];
    [noButton setImage:[UIImage imageNamed:@"ico_Subscribe.png"]forState:UIControlStateSelected];
    noButton.clipsToBounds = YES;
    noButton.layer.cornerRadius = 10;
    [noButton addTarget:self action:@selector(noCheckBoxAction:) forControlEvents:UIControlEventTouchUpInside];
    [noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yesLabel.mas_right).offset(10);
        make.centerY.equalTo(baseInsuranceView.mas_centerY);
        make.width.and.height.equalTo(@20);
    }];
    
    UILabel *noLabel= [[UILabel alloc] init];
    noLabel.text = @"否";
    [baseInsuranceView addSubview:noLabel];
    [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noButton.mas_right).offset(10);
        make.centerY.equalTo(baseInsuranceView.mas_centerY);
        make.width.and.height.equalTo(@20);
    }];
}



- (void)initTaxCategoryView {
    UIView *categoryView = [[UIView alloc] init];
    [self.view addSubview:categoryView];
    _categoryView = categoryView;
    [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseInsuranceView.mas_bottom);
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
    _gongjijinView = [[[NSBundle mainBundle] loadNibNamed:@"TaxFormView" owner:self options:nil] lastObject];
    [self.view addSubview:_yanglaoView];
    [self.view addSubview:_yiliaoView];
    [self.view addSubview:_shiyeView];
    [self.view addSubview:_shengyuView];
    [self.view addSubview:_gongshangView];
    [self.view addSubview:_gongjijinView];
    [_yanglaoView initWithTaxInfo:[self.insureArray objectAtIndex:0]];
    [_yiliaoView initWithTaxInfo:[self.insureArray objectAtIndex:1]];
    [_shiyeView initWithTaxInfo:[self.insureArray objectAtIndex:2]];
    [_shengyuView initWithTaxInfo:[self.insureArray objectAtIndex:3]];
    [_gongshangView initWithTaxInfo:[self.insureArray objectAtIndex:4]];
    [_gongjijinView initWithTaxInfo:[self.insureArray objectAtIndex:5]];
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
    [_gongjijinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gongshangView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
}

- (void)initCutTaxView {
    
    UIView *cutTaxView = [[UIView alloc] initWithFrame:CGRectMake(0, Pd_Top_Bar_Height, Pd_Screen_width, 44)];
    [self.view addSubview:cutTaxView];
    self.cutTaxView = cutTaxView;
    [self.cutTaxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(_gongjijinView.mas_bottom);
        make.height.equalTo(@44);
    }];
    UILabel *cutTaxTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 44)];
    cutTaxTitleLabel.text = @"所得税扣除额(元)";
    [self.cutTaxView addSubview:cutTaxTitleLabel];
    UILabel *cutTaxLabel = [[UILabel alloc] init];
    cutTaxLabel.textAlignment = NSTextAlignmentLeft;
    [self.cutTaxView addSubview:cutTaxLabel];
    self.cutTaxLabel = cutTaxLabel;
    [cutTaxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cutTaxView.mas_left).offset(15);
        make.height.equalTo(self.cutTaxView.mas_height);
        make.width.equalTo(@(135));
        make.top.equalTo(self.cutTaxView.mas_top);
    }];
    
    [cutTaxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cutTaxTitleLabel.mas_right).offset(5);
        make.height.equalTo(self.cutTaxView.mas_height);
        make.width.equalTo(@180);
        make.top.equalTo(self.cutTaxView.mas_top);
    }];
    
    [self.view addSubview:self.cutTaxView];
}


- (void)initProfitLabel {
    _profitView = [[ProfitView alloc] init];
    [self.view addSubview:_profitView];
    [_profitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.top.equalTo(_cutTaxView.mas_bottom).offset(30);
    }];
    [_profitView setupWithIncome:0];
}

#pragma mark -- UIButton action
- (void)noCheckBoxAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.yesButton.selected = NO;
    }
    else {
        self.yesButton.selected = YES;
    }
    
}

- (void)yesCheckBoxAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        self.noButton.selected = NO;
    }
    else {
        self.noButton.selected = YES;
    }
    
}

#pragma mark -- UITextInputChange
- (void)taxInputChange :(NSNotification *)noti {

    UITextField *textField = noti.object;
    if (textField != self.incomeTextField) {
        return;
    }
    CGFloat income = [textField.text floatValue];
    InsuranceFundModel *insuranceModel  = [TaxUtility getInsuranceWithIncome:income andCity:@"深圳"];
    InsuranceFundModel *companyModel = [TaxUtility getCompanyInsuranceWithIncome:income andCity:@"深圳"];
    CGFloat profit = [TaxUtility caculateProfitWithIncome:income andProfitModel:insuranceModel];
    [self updateInsuranceWithInsuranceModel:insuranceModel andCompanyModel:companyModel andIncome:income];
    
    [_profitView setupWithIncome:profit];
    
}

- (void)updateInsuranceWithInsuranceModel:(InsuranceFundModel *)insuranceModel andCompanyModel:(InsuranceFundModel *)companyModel andIncome:(CGFloat)income {
    _yanglaoView.personFund = [NSString stringWithFormat:@"%.0f",insuranceModel.yanglaoFund];
    _yiliaoView.personFund = [NSString stringWithFormat:@"%.0f",insuranceModel.yiliaoFund];
    _gongshangView.personFund =  [NSString stringWithFormat:@"%.0f",insuranceModel.gongshangFund];
    _shengyuView.personFund =  [NSString stringWithFormat:@"%.0f",insuranceModel.shengyuFund];
    _shiyeView.personFund =  [NSString stringWithFormat:@"%.0f",insuranceModel.shiyeFund];
    _gongjijinView.personFund  = [NSString stringWithFormat:@"%.0f",insuranceModel.gongjijinFund];
    
    _yanglaoView.companyFund = [NSString stringWithFormat:@"%.0f",companyModel.yanglaoFund];
    _yiliaoView.companyFund = [NSString stringWithFormat:@"%.0f",companyModel.yiliaoFund];
    _gongshangView.companyFund =  [NSString stringWithFormat:@"%.0f",companyModel.gongshangFund];
    _shengyuView.companyFund =  [NSString stringWithFormat:@"%.0f",companyModel.shengyuFund];
    _shiyeView.companyFund =  [NSString stringWithFormat:@"%.0f",companyModel.shiyeFund];
    _gongjijinView.companyFund  = [NSString stringWithFormat:@"%.0f",companyModel.gongjijinFund];
    
    CGFloat insuranceFund =  insuranceModel.yanglaoFund +  insuranceModel.yiliaoFund + insuranceModel.gongjijinFund + insuranceModel.gongshangFund + insuranceModel.shiyeFund + insuranceModel.shengyuFund;
    CGFloat profit = [TaxUtility caculateProfitWithIncome:income andProfitModel:insuranceModel];
    CGFloat taxForGovenment ;
    if (profit > kSocialLowIncome) {
        taxForGovenment =  income - profit - insuranceFund ;
    }
    else {
        taxForGovenment = 0;
    }
    _cutTaxLabel.text = [NSString stringWithFormat:@"%.0f",taxForGovenment];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
