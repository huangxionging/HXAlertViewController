//
//  HXObject.h
//  HXAlertViewController
//
//  Created by huangxiong on 15/3/22.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//

#ifndef HXAlertViewController_HXObject_h
#define HXAlertViewController_HXObject_h

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////调试相关/////////////////////////////////////
/**
 *  仅仅当 condition 条件成立时会执行
 */
#define HXAssert(condition, desc, ...) \
if (condition) { \
    [[NSAssertionHandler currentHandler] handleFailureInMethod:_cmd \
    object:self file:[NSString stringWithUTF8String: __FILE__] \
    lineNumber: __LINE__ description: desc, ##__VA_ARGS__];\
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////屏幕相关/////////////////////////////////////
/**
 *  屏幕尺寸信息
 */
#define HXSCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define HXSCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////颜色相关/////////////////////////////////////
/**
 *  @brief: 从数字取颜色, RGB
 *  @param: r, g, b, a 分别是 红色, 绿色, 黄色以及 alpha 值四个分量
 */
#define COLOR_FROM_RGB(r, g, b, a) ([UIColor colorWithRed: r / 256.0  green: g / 256.0 blue: b / 256.0 alpha: a])

/**
 *  @brief: 从颜色值取颜色
 *  @param: value 是 0x 开头的 16 进制颜色值, a 为 alpha 值
 */
#define COLOR_FROM_VALUE(value, a) ([UIColor colorWithRed: ((value & 0xFF0000) >> 16) / 256.0  green: ((value & 0x00FF00) >> 8) / 256.0 blue: (value & 0x0000FF) / 256.0 alpha: a])

/**
 *  @brief: 从单一颜色取颜色, 即是 r, g, b 值都相同, alpha 值默认为 1.0
 *  @param: colorValue
 */
#define COLOR_FROM_ONE(colorValue) COLOR_FROM_RGB(colorValue, colorValue, colorValue, 1.0)

////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////图片相关/////////////////////////////////////
/**
 * 获取图片, 普通获取
 */
#define GET_IMAGE(image) ([UIImage imageNamed: image])


/**
 *  从包里获取图片
 *  image 是图片名字, bundle 是图片所在的包名, 后缀为.bundle的文件夹
 */
#define GET_IMAGE_FROM_BUNDLE(image, bundle) ([UIImage imageNamed: [bundle stringByAppendingPathComponent: image]])
////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////操作系统版本//////////////////////////////////////////////////////////////
/**
 *  iOS 6
 */
#define IOS6 ([UIDevice currentDevice].systemVersion.floatValue >= 6.0 && [UIDevice currentDevice].systemVersion.floatValue < 7.0)

/**
 *  iOS 7
 */
#define IOS7 ([UIDevice currentDevice].systemVersion.floatValue >= 7.0 && [UIDevice currentDevice].systemVersion.floatValue < 8.0)

/**
 *  iOS 8
 */
#define IOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0 && [UIDevice currentDevice].systemVersion.floatValue < 9.0)

#endif
