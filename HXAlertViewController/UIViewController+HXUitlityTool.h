//
//  UIViewController+HXUitlityTool.h
//  HXAlertViewController
//
//  Created by huangxiong on 15/4/16.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HXUitlityTool)

/**
 *  @brief: 计算一段文字需要的高度和宽度
 *  @param: text 是字符串文本, 是带计算的文本
 *  @param: maxSize 是允许的最大size
 *  @param: fontSize 是字体大小
 *  @return: 返回值是 CGSize 类型, 代表了文本在 maxSize 条件下的实际尺寸
 */
- (CGSize) sizeForText: (NSString *) text WithMaxSize: (CGSize) maxSize AndWithFontSize: (CGFloat) fontSize;

@end
