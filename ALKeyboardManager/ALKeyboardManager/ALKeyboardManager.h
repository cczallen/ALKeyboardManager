//
//  ALKeyboardManager.h
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#define ALKeyboardManagerLogEnabled // 打開即可記錄 keyboardWillChangeFrame、keyboardDidHide 等事件

#import <UIKit/UIKit.h>

@protocol ALKeyboardManagerDelegate <NSObject>
- (void)keyboardManagerKeyboardUpdateFrame;
@end



@interface ALKeyboardManager : NSObject

@property (assign, nonatomic) BOOL isKeyboardShowing;
@property (assign, nonatomic) CGRect keyboardFrame; // CGRectNull when !isKeyboardShowing

// setup after `willChangeFrame`, clean up after `didChangeFrame`
@property (assign, nonatomic) NSTimeInterval keyboardChangeFrameAnimationDuration;
@property (assign, nonatomic) UIViewAnimationOptions keyboardChangeFrameAnimationCurveOptions;

+ (instancetype)sharedManager;

- (CGFloat)keyboardTopYInKeyWindow;
- (CGFloat)keyboardTopYInWindow:(UIWindow *)window;

- (void)addDelegate:(id<ALKeyboardManagerDelegate>)delegate;
- (void)removeDelegate:(id<ALKeyboardManagerDelegate>)delegate; // optional: delegate 被 release 時會自動被移除。

@end

