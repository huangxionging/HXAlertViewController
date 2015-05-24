//
//  UIViewController+HXUitlityTool.m
//  HXAlertViewController
//
//  Created by huangxiong on 15/4/16.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import "UIViewController+HXUitlityTool.h"

@implementation UIViewController (HXUitlityTool)

#pragma mark---计算文本的尺寸大小
- (CGSize) sizeForText: (NSString *) text WithMaxSize: (CGSize) maxSize AndWithFontSize: (CGFloat) fontSize {
    
    // 对操作系统进行判断
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        CGRect rect = [text boundingRectWithSize: maxSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName: [UIFont systemFontOfSize: fontSize]} context:nil];
        return rect.size;
    }
    else {
        return  [text sizeWithFont:[UIFont systemFontOfSize: fontSize] constrainedToSize: maxSize];
    }
}

@end

