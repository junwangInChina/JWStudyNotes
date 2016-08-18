//
//  JWLoginController.m
//  JWStudyRealmOC
//
//  Created by wangjun on 16/8/18.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWLoginController.h"

#import <Realm.h>

@interface JWLoginController ()

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation JWLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"登陆";
    
    JW_WS(this)
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(this.view);
        make.left.top.right.equalTo(this.view).with.insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(this.view);
        make.top.equalTo(this.descLabel.mas_bottom).with.offset(10);
        make.left.equalTo(this.view).with.offset(10);
        make.right.equalTo(this.view).with.offset(-10);
        make.height.equalTo(@40);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(this.view);
        make.left.equalTo(this.view).with.offset(10);
        make.right.equalTo(this.view).with.offset(-10);
        make.top.equalTo(this.accountTextField.mas_bottom).with.offset(10);
        make.height.equalTo(@40);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy loading
- (UITextField *)accountTextField
{
    if (!_accountTextField)
    {
        self.accountTextField = [[UITextField alloc] init];
        _accountTextField.font = [UIFont systemFontOfSize:14];
        _accountTextField.borderStyle = UITextBorderStyleRoundedRect;
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.placeholder = @"请输入登陆帐号";
        [self.view addSubview:_accountTextField];
    }
    return _accountTextField;
}

- (UIButton *)loginButton
{
    if (!_loginButton)
    {
        self.loginButton = [UIButton new];
        _loginButton.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.8];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
    }
    return _loginButton;
}

- (UILabel *)descLabel
{
    if (!_descLabel)
    {
        self.descLabel = [UILabel new];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont systemFontOfSize:13];
        _descLabel.text = @"模拟登陆，实现Realm数据库的切换功能";
        [self.view addSubview:_descLabel];
    }
    return _descLabel;
}

- (void)loginButtonAction:(id)sender
{
    NSString *tempInput = [self.accountTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tempInput.length > 0)
    {
        // 使用默认目录，但是使用用户名来替换默认的文件名
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:tempInput] URLByAppendingPathExtension:@"realm"];
        // 将这个配置应用到默认的 Realm 数据库当中
        [RLMRealmConfiguration setDefaultConfiguration:config];
        
        if (self.complete)
        {
            self.complete(YES);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
