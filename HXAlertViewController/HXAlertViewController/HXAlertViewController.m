//
//  HXAlertViewController.m
//  HXAlertViewController
//
//  Created by huangxiong on 15/1/14.
//  Copyright (c) 2015年 New_Life. All rights reserved.
//
#import "HXAlertViewController.h"
#import "AppDelegate.h"
#import "HXObject.h"

#define AlertBundle (@"AlertViewController.bundle")

/**
 *  ActionSheet的宽度
 */
#define HXACTION_SHEET_WIDTH (280)

/**
 *  ActionSheet的高度
 */
#define HXACTION_SHEET_HEIGHT (48)

/**
 *  Alert的高度
 */
#define HXALERT_HEIGHT (38)

/**
 *  AlertView的宽度
 */
#define HXALERT_VIEW_WIDTH (280)

/**
 *  ActionSheet风格标题宽度
 */
#define HXACTION_SHEET_TITLE_WIDTH (200)

/**
 *  ActionSheet风格消息宽度
 */
#define HXACTION_SHEET_MESSAGE_WIDTH (280)

/**
 * Alert风格标题宽度
 */
#define HXALERT_TITLE_WIDTH (200)

/**
 *  Alert风格消息宽度
 */
#define HXALERT_MESSAGE_WIDTH (250)

/**
 *  空行
 */
#define SPACE (10)


/**
 *  警告操作标志 HXAlertActionTag
 */
typedef NS_ENUM(NSInteger, HXAlertActionTag) {
    // 取消标记
    HXAlertActionTagCancel = 100,
    // 删除标记
    HXAlertActionTagDestructive,
    // 默认标记
    HXAlertActionTagDefault
};

#pragma mark---HXAlertAction类
@interface HXAlertAction ()

/**
 *  回调
 */
@property (nonatomic, strong) HXAlertActionBlock alertActionBlock;

/**
 *  按钮
 */
@property (nonatomic, strong) UIButton *button;

/**
 *  警告框风格
 */
@property (nonatomic, assign) HXAlertActionStyle alertActionStyle;

@end

@implementation HXAlertAction {
    /**
     *  标题 AlertAction 上的标题
     */
    NSString *_title;
}

@synthesize title = _title;

#pragma mark---使用 + 方法创建 AlertAction , 参数有标题, 风格, 以及 Block 回调
+ (instancetype)actionWithTitle:(NSString *)title style:(HXAlertActionStyle)style andActionBlock:(HXAlertActionBlock)actionBlock {
    // 标题必须存在
    HXAssert(!title, @"title must exist")
    
    HXAlertAction *alertAcion = [[HXAlertAction alloc] initWithTitle: title];
    
    if (alertAcion) {
        alertAcion.alertActionBlock = actionBlock;
        alertAcion.alertActionStyle = style;
    }
    
    return alertAcion;
}

#pragma mark---标题
- (instancetype)initWithTitle: (NSString *) title {
    self = [super init];
    
    if (self) {
        _title = title;
        
        // 创建按钮
        _button = [UIButton buttonWithType: UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, HXACTION_SHEET_WIDTH, HXACTION_SHEET_HEIGHT);
        _button.layer.masksToBounds = YES;
        _button.layer.borderWidth = 0.5;
        _button.layer.borderColor = [UIColor grayColor].CGColor;
        _button.layer.cornerRadius = 5;
        [_button addTarget: self action: @selector(buttonClick) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark---按钮点击事件
- (void) buttonClick {
    _alertActionBlock(self);
}

@end


#pragma mark---HXAlertViewController类
@interface HXAlertViewController () <UITextFieldDelegate>

/**
 *  用来保持AlertAction
 */
@property (nonatomic, strong) NSMutableArray *alertActionArray;

/**
 *  警告操作框视图
 */
@property (nonatomic, strong) UIView *alertActionView;

/**
 *  警告框视图的高度
 */
@property (nonatomic, assign) CGFloat alertActionHeight;

/**
 *  是否已经有取消 Cancle AlertAction
 */
@property (nonatomic, assign) BOOL isCancleAlertAction;

/**
 *  是否已经有破坏 Destructive AlertAction
 */
@property (nonatomic, assign) BOOL isDestructiveAlertAction;

/**
 *  普通按钮的个数
 */
@property (nonatomic, assign) NSInteger defaultAlertActionCount;

/**
 *  标题的高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 *  标题最大宽度
 */
@property (nonatomic, assign) CGFloat maxTitleWidth;

/**
 *  消息的高度
 */
@property (nonatomic, assign) CGFloat messageHeight;

/**
 *  标题最大宽度
 */
@property (nonatomic, assign) CGFloat maxMessageWidth;

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  消息标签
 */
@property (nonatomic, strong) UILabel *messageLabel;

/**
 *  存放 textField 的数组
 */
@property (nonatomic, strong) NSMutableArray *alertTextFields;

/**
 *  判断文本框是否存在
 */
@property (nonatomic, assign) BOOL isTextFieldExist;

/**
 *  所有文本框的高度
 */
@property (nonatomic, assign) CGFloat allTextFieldHeight;

/**
 *  Original Frame, 用于记录 AlertView 最开始的 frame
 */
@property (nonatomic, assign) CGRect originalFrame;

/**
 * @brief:  创建遮罩层
 * @param:  无
 * @return: 无
 */
- (void) setMaskLayer;

@end

@implementation HXAlertViewController

#pragma mark---创建 HXAlertViewController 对象实例
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(HXAlertControllerStyle)preferredStyle {
    // 必须是这两种风格
    HXAssert((preferredStyle != HXAlertControllerStyleActionSheet) && (preferredStyle != HXAlertControllerStyleAlert),  @"The preferredStyle only support HXAlertControllerStyleActionSheet Or HXAlertControllerStyleAlert");
    
    // 初始化
    HXAlertViewController *alertViewController = [[HXAlertViewController alloc] initWithPreferredStyle: preferredStyle AndWithTitle: title AndWithMessage: message];
    
    if (alertViewController) {
        // 通过系统版本判断以产生不同的操作
        alertViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            
            alertViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        else {
            [alertViewController getCurrentVC].modalPresentationStyle = UIModalPresentationCurrentContext;
        }
        
    }
    return alertViewController;
}

#pragma mark---初始化方法
- (instancetype)initWithPreferredStyle : (HXAlertControllerStyle) preferredStyle AndWithTitle: (NSString *)title AndWithMessage: (NSString *)message {
    
    self = [super init];
    
    if (self) {
        // 创建警告框
        _alertActionView = [[UIView alloc] initWithFrame: CGRectMake(0, HXSCREEN_HEIGHT, HXSCREEN_WIDTH, HXSCREEN_HEIGHT)];
        _alertActionView.backgroundColor = COLOR_FROM_ONE(256);
        // 背景颜色
      //  _alertActionView.backgroundColor = COLOR_FROM_RGB(232, 233, 232, 1.0);
        // 数组用于保存AlertAction
        _alertActionArray = [[NSMutableArray alloc] init];
        // 偏爱风格
        _preferredStyle = preferredStyle;
        
        // 标题高度
        _titleHeight = 0;
        // 消息高度
        _messageHeight = 0;
        // 消息
        _alertActionTitle = title;
        // 消息
        _alertActionMessage = message;
        
        // 创建标题
        if (_alertActionTitle != nil) {
            _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
            _titleLabel.font = [UIFont systemFontOfSize: 15.0];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.numberOfLines = 0;
            _titleLabel.text = _alertActionTitle;
            _titleHeight = SPACE;
        }
        
        // 创建消息
        if (_alertActionMessage != nil) {
            _messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
            _messageLabel.font = [UIFont systemFontOfSize: 13.0];
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.numberOfLines = 0;
            _messageLabel.text = _alertActionMessage;
            _messageHeight = SPACE;
        }
        
        if (_preferredStyle == HXAlertControllerStyleAlert) {
            // 调整alertActionView的属性
            _alertActionView.layer.masksToBounds = YES;
            _alertActionView.layer.cornerRadius = 5;
            
            _maxTitleWidth = HXALERT_TITLE_WIDTH;
            _maxMessageWidth = HXALERT_MESSAGE_WIDTH;
        }
        else if (_preferredStyle == HXAlertControllerStyleActionSheet) {
            _maxTitleWidth = HXACTION_SHEET_TITLE_WIDTH;
            _maxMessageWidth = HXACTION_SHEET_MESSAGE_WIDTH;
        }
        
        // 获取标题的高度
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            NSDictionary *attributeDict = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 15.0]};
            CGSize size = [_alertActionTitle boundingRectWithSize: CGSizeMake(_maxTitleWidth, 50) options: NSStringDrawingUsesLineFragmentOrigin attributes: attributeDict context: nil].size;
            _titleHeight += size.height;
        }
        else {
            CGSize size = [_alertActionTitle sizeWithFont: [UIFont boldSystemFontOfSize: 15.0] constrainedToSize: CGSizeMake(_maxTitleWidth, 50) lineBreakMode: NSLineBreakByCharWrapping];
            _titleHeight += size.height;
        }
        
        // 获取消息的高度
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            NSDictionary *attributeDict = @{NSFontAttributeName: [UIFont systemFontOfSize: 13.0]};
            CGSize size = [_alertActionMessage boundingRectWithSize: CGSizeMake(_maxMessageWidth, 100) options:  NSStringDrawingUsesLineFragmentOrigin attributes: attributeDict context: nil].size;
            _messageHeight += size.height;
        }
        else {
            CGSize size = [_alertActionMessage sizeWithFont: [UIFont systemFontOfSize: 13.0] constrainedToSize: CGSizeMake(_maxMessageWidth, 100) lineBreakMode: NSLineBreakByWordWrapping];
            _messageHeight += size.height;
        }
    }
    
    return self;
}

#pragma mark---添加操作
- (void)addAction:(HXAlertAction *)action {
    switch (action.alertActionStyle) {
        case HXAlertActionStyleCancel: {
            // 如果已经存在该类型 AlertAction
            HXAssert(_isCancleAlertAction, @"HXAlertActionStyleCancel existed!")
            
            // 取消按钮的颜色
            [action.button setBackgroundImage: GET_IMAGE_FROM_BUNDLE(@"cancle", AlertBundle) forState: UIControlStateNormal];
            _isCancleAlertAction = YES;
            action.button.tag = HXAlertActionTagCancel;
            break;
        }
            
        case HXAlertActionStyleDefault: {
            // 默认按钮的颜色
            [action.button setBackgroundImage: GET_IMAGE_FROM_BUNDLE(@"default", AlertBundle) forState: UIControlStateNormal];
            action.button.tag = _defaultAlertActionCount + HXAlertActionTagDefault;
            [action.button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            _defaultAlertActionCount++;
            break;
        }
            
        case HXAlertActionStyleDestructive: {
            // 如果已经存在该类型 AlertAction
            HXAssert(_isDestructiveAlertAction,  @"HXAlertActionStyleDestructive existed!")
            
            // 破坏按钮的颜色
            [action.button setBackgroundImage: GET_IMAGE_FROM_BUNDLE(@"destructive", AlertBundle) forState: UIControlStateNormal];
            _isDestructiveAlertAction = YES;
            action.button.tag = HXAlertActionTagDestructive;
            break;
        }
        default:
            break;
    }

    
    // 添加按钮
    [_alertActionView addSubview: action.button];
    // 设置标题
    [action.button setTitle: action.title forState: UIControlStateNormal];
    // 添加到数组
    [_alertActionArray addObject: action];
}

#pragma mark---视图已经出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    // 调整AlertAction的位置
    [self adjustAlertActionView];
    
    // 在此添加动画才能正常显示出来
    [self performSelector:@selector(popAlerActiontView) withObject: nil afterDelay: 0.05];
}

#pragma mark---调整AlertAction上按钮的位置
- (void) adjustAlertActionView {
    switch (_preferredStyle) {
        case HXAlertControllerStyleActionSheet: {
            
            _alertActionHeight = (_defaultAlertActionCount + (_isCancleAlertAction ? 1 : 0) + (_isDestructiveAlertAction ? 1 : 0)) * (HXACTION_SHEET_HEIGHT + 10) + 30 + _titleHeight + _messageHeight;
            
            // 调整标题
            if (_alertActionTitle != nil) {
                _titleLabel.frame = CGRectMake((HXSCREEN_WIDTH - _maxTitleWidth) / 2, 10, _maxTitleWidth, _titleHeight);
                [_alertActionView addSubview: _titleLabel];
            }
            
            // 调整消息
            if (_alertActionMessage != nil) {
                _messageLabel.frame = CGRectMake((HXSCREEN_WIDTH - _maxMessageWidth) / 2, 10 + _titleHeight, _maxMessageWidth, _messageHeight - SPACE);
                [_alertActionView addSubview: _messageLabel];
            }
            
            
            if (_isCancleAlertAction) {
                
                // 通过标记找到取消按钮
                UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagCancel];
                // 设置frame
                button.frame = CGRectMake((HXSCREEN_WIDTH - HXACTION_SHEET_WIDTH) / 2, _alertActionHeight - HXACTION_SHEET_HEIGHT - 10, HXACTION_SHEET_WIDTH, HXACTION_SHEET_HEIGHT);
            }
            
            if (_isDestructiveAlertAction) {
                // 通过标记找到破坏按钮
                UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagDestructive];
                // 设置frame
                button.frame = CGRectMake((HXSCREEN_WIDTH - HXACTION_SHEET_WIDTH) / 2, 10 + _titleHeight + _messageHeight, HXACTION_SHEET_WIDTH, HXACTION_SHEET_HEIGHT);
            }
            
            for (NSInteger index = 0; index < _defaultAlertActionCount; ++index) {
                // 通过标记找到按钮
                UIButton *button = (UIButton *)[_alertActionView viewWithTag: index + HXAlertActionTagDefault];
                // 设置frame
                button.frame = CGRectMake((HXSCREEN_WIDTH - HXACTION_SHEET_WIDTH) / 2, index * (HXACTION_SHEET_HEIGHT + 10) + 20 + (_isDestructiveAlertAction ?HXACTION_SHEET_HEIGHT : 0) + _titleHeight + _messageHeight, HXACTION_SHEET_WIDTH, HXACTION_SHEET_HEIGHT);
            }

            break;
        }
            
        case HXAlertControllerStyleAlert: {
            
            _alertActionHeight = 20;
            // 调整标题
            if (_alertActionTitle != nil) {
                _titleLabel.frame = CGRectMake((HXALERT_VIEW_WIDTH - _maxTitleWidth) / 2, 10, _maxTitleWidth, _titleHeight - SPACE);
                [_alertActionView addSubview: _titleLabel];
                _alertActionHeight += _titleHeight;
            }
            
            // 调整消息
            if (_alertActionMessage != nil) {
                _messageLabel.frame = CGRectMake((HXALERT_VIEW_WIDTH - _maxMessageWidth) / 2, 10 + _titleHeight, _maxMessageWidth, _messageHeight - SPACE);
                [_alertActionView addSubview: _messageLabel];
                
                _alertActionHeight += _messageHeight;
            }
            
            NSInteger count = _defaultAlertActionCount + (_isCancleAlertAction?1:0) + (_isDestructiveAlertAction?1:0);
            
            if (_isTextFieldExist) {
                _allTextFieldHeight = _alertTextFields.count * 20;
                
                CGFloat textFieldWidth = HXALERT_VIEW_WIDTH - 30;
                for (NSInteger index = 0; index < _alertTextFields.count; ++index) {
                    UITextField *textField = (UITextField *)_alertTextFields[index];
                    textField.frame = CGRectMake((HXALERT_VIEW_WIDTH - textFieldWidth) / 2, _alertActionHeight + index * 22, textFieldWidth, 20);
                    
                    // 添加特效
                    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
                        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect: [UIBlurEffect effectWithStyle: UIBlurEffectStyleLight]];
                        
                        UIVisualEffectView *textVisualView = [[UIVisualEffectView alloc] initWithEffect: vibrancyEffect];
                        textVisualView.layer.borderColor = [UIColor grayColor].CGColor;
                        textVisualView.layer.borderWidth = 0.4;
                        textVisualView.frame = textField.frame;
                        textVisualView.frame = CGRectMake(textField.frame.origin.x - 1, textField.frame.origin.y - 1, textField.frame.size.width + 2, textField.frame.size.height + 2);
                        [_alertActionView addSubview: textVisualView];
                    }
                    [_alertActionView addSubview: textField];
                }
                
                _alertActionHeight += _allTextFieldHeight + 20;
            }
            
            if (count <= 3 && count != 0) {
                
                _alertActionHeight +=  HXALERT_HEIGHT;
                
                CGFloat space = 10;
                
                CGFloat localWidth = HXALERT_VIEW_WIDTH - space;
                CGFloat width = localWidth / count;
                CGFloat height = HXALERT_HEIGHT + 10;
                
                if (_isDestructiveAlertAction) {
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagDestructive];
                    button.frame = CGRectMake(space, _alertActionHeight - height, width - space, HXALERT_HEIGHT);
                    [_alertActionView addSubview: button];
                }
                
                if (_isCancleAlertAction) {
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagCancel];
                    button.frame = CGRectMake(HXALERT_VIEW_WIDTH - width, _alertActionHeight - height, width - space, HXALERT_HEIGHT);
                }
                
                
                for (NSInteger index = 0; index < _defaultAlertActionCount; ++index) {
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagDefault + index];
                    button.frame = CGRectMake(index * width + space +  (NSInteger) _isDestructiveAlertAction * width, _alertActionHeight - height, width - space, HXALERT_HEIGHT);
                }
            }
            else if (count > 3) {
                _alertActionHeight = SPACE + _titleHeight + _messageHeight +  (HXALERT_HEIGHT + SPACE) * count;
                
                if (_isCancleAlertAction) {
                    // 通过标记找到取消按钮
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagCancel];
                    // 设置frame
                    button.frame = CGRectMake(SPACE, _alertActionHeight - HXALERT_HEIGHT - SPACE, HXALERT_VIEW_WIDTH - SPACE * 2, HXALERT_HEIGHT);
                }
                
                if (_isDestructiveAlertAction) {
                    // 通过标记找到破坏按钮
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: HXAlertActionTagDestructive];
                    // 设置frame
                    button.frame = CGRectMake(SPACE, SPACE + _titleHeight + _messageHeight, HXALERT_VIEW_WIDTH - SPACE * 2, HXALERT_HEIGHT);
                }
                
                for (NSInteger index = 0; index < _defaultAlertActionCount; ++index) {
                    // 通过标记找到按钮
                    UIButton *button = (UIButton *)[_alertActionView viewWithTag: index + HXAlertActionTagDefault];
                    // 设置frame
                    button.frame = CGRectMake(SPACE, index * (HXALERT_HEIGHT + SPACE) + (_isDestructiveAlertAction ?(HXALERT_HEIGHT + SPACE) : 0) + _titleHeight + _messageHeight + SPACE, HXALERT_VIEW_WIDTH - SPACE * 2, HXALERT_HEIGHT);
                }
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark---视图已经加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor clearColor];
    [self setMaskLayer];
}

#pragma mark---内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---触摸事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if (_isTextFieldExist)
//    {
//        // 文本框放弃第一响应
//        for (NSInteger index = 0; index < _alertTextFields.count; ++index)
//        {
//            UITextField *textField = (UITextField *)_alertTextFields[index];
//            [textField resignFirstResponder];
//        }
//        
//        // 恢复原来的位置
//        _alertActionView.frame = _originalFrame;
//        
//        return;
//    }
//    
//    [self dismissViewControllerAnimated: YES completion:^{
//        
//    }];
//}

#pragma mark---设置遮罩
- (void) setMaskLayer {
    // 遮罩层
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.backgroundColor = [UIColor blackColor].CGColor;
    maskLayer.frame = self.view.bounds;
    maskLayer.opacity = 0.3;
    [self.view.layer addSublayer: maskLayer];
}

#pragma mark---创建警告框视图
- (void) popAlerActiontView {
    [self.view addSubview: _alertActionView];
    
    switch (_preferredStyle) {
        case HXAlertControllerStyleActionSheet: {
            [UIView animateWithDuration: 0.3 animations:^{
                _alertActionView.frame = CGRectMake(0, HXSCREEN_HEIGHT - _alertActionHeight, HXSCREEN_WIDTH, _alertActionHeight);
            }];
            break;
        }
            
        case HXAlertControllerStyleAlert: {
            _alertActionView.frame = CGRectMake((HXSCREEN_WIDTH - HXALERT_VIEW_WIDTH) / 2, (HXSCREEN_HEIGHT - _alertActionHeight) / 2, HXALERT_VIEW_WIDTH, _alertActionHeight);
            break;
        }
        default:
            break;
    }
    
    _originalFrame = _alertActionView.frame;
    
    if (_isTextFieldExist)
    {
        UITextField *textFied = self.textFields[0];
        [textFied becomeFirstResponder];
    }
}

#pragma mark---获取包含所有的 Action 的数组
- (NSArray *)actions {
    return [_alertActionArray mutableCopy];
}

#pragma mark---获取当前顶层视图控制器
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

#pragma mark---获取装有 TextFiled 的数组
- (NSArray *)textFields {
    return [_alertTextFields mutableCopy];
}

#pragma mark---添加 TextFiled
- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField *))configurationHandler {
    
    HXAssert(_preferredStyle != HXAlertControllerStyleAlert, @"the _preferredStyle only support HXAlertControllerStyleAlert");
    
    // 创建文本框
    if (_alertTextFields == nil) {
        _alertTextFields = [[NSMutableArray alloc] initWithCapacity: 2];
        _isTextFieldExist = YES;
    }
    
    UITextField *textField = [[UITextField alloc] init];
    // 配置textField
    configurationHandler(textField);
    
    // 添加到 数组
    [_alertTextFields addObject: textField];
    
    textField.delegate = self;
    
    if (_isTextFieldExist == YES) {
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(showKeyboard:) name: UIKeyboardWillShowNotification object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(hideKeyboard:) name: UIKeyboardWillHideNotification object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(changeFrameKeyboard:) name: UIKeyboardWillChangeFrameNotification object: nil];
    }
}


#pragma mark---键盘出现通知
- (void)showKeyboard: (NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
//    NSLog(@"%s, %@", __FUNCTION__, userInfo);
    
    NSValue *showFrame = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    
    CGRect frame = showFrame.CGRectValue;
    
    // 设置新位置
    _alertActionView.frame = CGRectMake(_alertActionView.frame.origin.x, HXSCREEN_HEIGHT - _alertActionView.frame.size.height - frame.size.height - 5, _alertActionView.frame.size.width, _alertActionView.frame.size.height);
}

#pragma mark---键盘隐藏通知
- (void)hideKeyboard: (NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSLog(@"%s, %@", __FUNCTION__, userInfo);
    
    // 恢复到原来的位置
    _alertActionView.frame = _originalFrame;
}

#pragma mark---键盘改变通知
- (void)changeFrameKeyboard: (NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSLog(@"%s, %@", __FUNCTION__, userInfo);
}

#pragma mark---UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // textField 在 self.textFields 中的索引值
    NSInteger  index = [self.textFields indexOfObject: textField];
    
    // 改变第一响应者
    if (index != self.textFields.count - 1) {
        UITextField *nextTextField = self.textFields[index + 1];
        [nextTextField becomeFirstResponder];
    }
    else {
        //[textField resignFirstResponder];
        [self dismissViewControllerAnimated: YES completion:^{
            
        }];
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
