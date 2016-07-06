//
//  HXAlertViewController.h
//  HXAlertViewController
//
//  Created by huangxiong on 15/1/14.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  声明类
 */
@class HXAlertAction, HXAlertViewController;

/**
 *  警告操作风格 HXAlertActionStyle
 */
typedef NS_ENUM(NSInteger, HXAlertActionStyle)
{
    // 默认风格
    HXAlertActionStyleDefault = 0,
    // 取消风格
    HXAlertActionStyleCancel,
    // 删除风格
    HXAlertActionStyleDestructive
};

/**
 *  警告框风格
 */
typedef NS_ENUM(NSInteger, HXAlertControllerStyle)
{
    // ActionSheet风格
    HXAlertControllerStyleActionSheet = 0,
    // Alert风格
    HXAlertControllerStyleAlert,
} ;

#pragma mark---HXAlertAction的Block回调
typedef void(^HXAlertActionBlock)(HXAlertAction *action);

#pragma mark---HXAlertAction 类的声明
@interface HXAlertAction : NSObject

/**
 *  标题
 */
@property (nonatomic, readonly) NSString *title;

/**
 *  警告风格
 */
@property (nonatomic, readonly) HXAlertActionStyle style;

/**
 *  是否可用
 */
@property (nonatomic, getter=isEnabled) BOOL enabled;

/**
 *  @brief: 使用+方法创建一个HXAlertAction
 *  @param: (title, NSString) 是操作的标题
 *  @param: (style, UIAlertActionStyle) 是操作的风格
 *  @param: (actionBlock, HXAlerActionBlock) 是操作的回调
 *  @return:HXAlertAction 类型的对象实例
 */
+ (instancetype)actionWithTitle:(NSString *)title style:(HXAlertActionStyle)style andActionBlock: (HXAlertActionBlock) actionBlock;

@end

#pragma mark---HXAlertViewController 的声明
@interface HXAlertViewController : UIViewController

/**
 *  装有所有 Action 的数组
 */
@property (nonatomic, readonly) NSArray *actions;

/**
 *  装有所有 TextField 的数组
 */
@property (nonatomic, readonly) NSArray *textFields;

/**
 *  标题, 显示在 AlertActionView 上的标题
 */
@property (nonatomic, readonly, copy) NSString *alertActionTitle;

/**
 *  消息, 显示在 AlertActionView 上的消息
 */
@property (nonatomic, readonly, copy) NSString *alertActionMessage;

/**
 *  警告视图控制器风格
 */
@property (nonatomic, readonly) HXAlertControllerStyle preferredStyle;

/**
 *  @author huangxiong, 2016/04/20 17:08:19
 *
 *  @brief 获取当前控制器
 *
 *  @since 1.0
 */
@property (nonatomic, readonly, weak) UIViewController *currentViewController;

/**
 *  @brief: 创建一个 HXAlertViewController 类型的对象实例
 *  @param: title 是控制器的标题
 *  @param: message 是控制器的消息
 *  @param: preferredStyle 是控制器的风格
 *  @return:HXAlertViewController 类型的对象实例
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HXAlertControllerStyle)preferredStyle;

/**
 *  @brief: 添加Action
 *  @param: action 是代添加的 HXAlertAction
 *  @return:返回值为 (void)空
 */
- (void)addAction:(HXAlertAction *)action;

/**
 *  @brief: 添加TextField
 *  @param: configurationHandler 是配置 TextField 的 block
 *  @return:返回值为 (void) 空
 */
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *textField))configurationHandler;

/**
 *  @author huangxiong, 2016/04/20 15:49:30
 *
 *  @brief 展示, 不再使用别的控制器展示
 *
 *  @since 1.0
 */
- (void) show;
@end

