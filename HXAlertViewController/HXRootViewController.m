//
//  HXRootViewController.m
//  HXAdaptLabel
//
//  Created by huangxiong on 14/12/23.
//  Copyright (c) 2014年 New_Life. All rights reserved.
//

#import "HXRootViewController.h"
#import "HXNavigationController.h"
#import "HXAlertViewController.h"
#import "AppDelegate.h"
#import "addViewController.h"


@interface HXRootViewController ()

@end

@implementation HXRootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationLeftTitle: @"按钮"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)navigationBarLeftClick:(UIButton *)sender
{
    
    addViewController *add = [[addViewController alloc] init];
    
    [self presentViewController: add animated: YES completion:^{
        
    }];
    
//    HXAlertViewController *alertViewController = [HXAlertViewController alertControllerWithTitle: nil message: nil preferredStyle: HXAlertControllerStyleActionSheet];
    
//    if (IOS8)
//    {
//        alertViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    }
//    else
//    {
//        alertViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
//    }
    NSLog(@"%@", [self class]);
    
//    UIPresentationController
    
//    [self presentViewController: alertViewController animated: YES completion:^{
//        
//    }];
    
   // [self.view addSubview: alertViewController.view];
}


@end
