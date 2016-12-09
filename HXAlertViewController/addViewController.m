//
//  addViewController.m
//  HXAlertViewController
//
//  Created by huangxiong on 15/1/16.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import "addViewController.h"
#import "HXAlertViewController.h"
#import <UIKit/UIKit.h>

@interface addViewController ()

@end

@implementation addViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftTitle: @"Action"];
    
    [self setNavigationRightTitle: @"Alert"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationBarLeftClick:(UIButton *)sender
{
    // 创建警告框
    HXAlertViewController *alertViewController = [HXAlertViewController alertControllerWithTitle: @"微信" message: @"当群聊为保存到通讯录时, 删除后将无法在通讯录中找到, 确认删除?" preferredStyle: HXAlertControllerStyleActionSheet];
    
    [alertViewController addAction: [HXAlertAction actionWithTitle: @"取消" style: HXAlertActionStyleCancel andActionBlock:^(HXAlertAction *action) {
        [alertViewController dismissViewControllerAnimated: YES completion:^{
            
        }];
    }]];
    
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"小视频" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            NSLog(@"sss");
//        }];
//    }]];
//    
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"拍照" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            
//        }];
//    }]];
    
    
    [alertViewController addAction: [HXAlertAction actionWithTitle: @"删除" style: HXAlertActionStyleDestructive andActionBlock:^(HXAlertAction *action) {
        [alertViewController dismissViewControllerAnimated: YES completion:^{
            
        }];
    }]];
    
    [self getCurrentVC];
    
    
    [alertViewController show];

}


- (void)navigationBarRightClick:(UIButton *)sender
{
    // 创建警告框
    HXAlertViewController *alertViewController = [HXAlertViewController alertControllerWithTitle: @"用户登陆" message: @"请输入登陆账号和登陆密码!" preferredStyle: HXAlertControllerStyleAlert];
    
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"取消" style: HXAlertActionStyleCancel andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            
//        }];
//    }]];
//    
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"小视频" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            NSLog(@"sss");
//        }];
//    }]];
    
//
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"拍照" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            
//        }];
//    }]];
//
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"从手机相册选择" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            
//        }];
//    }]];
    
    
    
//    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        
//    }];
//    
//    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//      
//    }];
    
//    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.layer.masksToBounds = YES;
//        textField.layer.borderWidth = 0.5;
//    }];
    
//    [alertViewController addAction: [HXAlertAction actionWithTitle: @"登陆" style: HXAlertActionStyleDestructive andActionBlock:^(HXAlertAction *action) {
//        
//        UITextField *userAccountTextField = alertViewController.textFields[0];
//        UITextField *passwordTextField = alertViewController.textFields[1];
//        
//        NSString *user = userAccountTextField.text;
//        NSString *password = passwordTextField.text;
//        
//        NSLog(@"%@ ---- %@", user, password);
//        
//        
//        [alertViewController dismissViewControllerAnimated: YES completion:^{
//            
//        }];
//    }]];
    
    [alertViewController addAction: [HXAlertAction actionWithTitle: @"取消" style: HXAlertActionStyleDefault andActionBlock:^(HXAlertAction *action) {
        [alertViewController dismissViewControllerAnimated: YES completion:^{
            
        }];
    }]];
    
    [self presentViewController: alertViewController animated: YES completion:^{
        
    }];
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    // 获取住窗口
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    // 如果主窗口不是普通的窗口则执行if语句
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        // 遍历窗口找到窗口
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    // 获得窗口的第一个子视图
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    // 先判断 UITransitionView
    if ([frontView isKindOfClass: NSClassFromString(@"UITransitionView")]) {
        NSLog(@"%@", frontView);
        if (frontView.subviews.count != 0) {
            frontView = frontView.subviews[0];
        }
    }
    // 得到其响应者
    id nextResponder = [frontView nextResponder];
    
    // 获取最上层的控制器
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    
    return result;
}

@end
