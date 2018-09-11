//
//  UIView+KeyboardLayoutGuide.m
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#import "UIView+KeyboardLayoutGuide.h"
#import "ALKeyboardManager.h"
#import <objc/runtime.h>

@interface ALKeyboardLayoutGuide ()
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;
@end

@implementation ALKeyboardLayoutGuide
@end



@implementation UIView (KeyboardLayoutGuide)

#pragma mark - <ALKeyboardManagerDelegate>

- (void)keyboardManagerKeyboardUpdateFrame {
    [self updateKeyboardLayoutGuideConstraintsIfNeeded];
}



#pragma mark - Private

- (ALKeyboardLayoutGuide *)setupKeyboardLayoutGuide {
    ALKeyboardLayoutGuide *keyboardLayoutGuide = [[ALKeyboardLayoutGuide alloc] init];
    [self setKeyboardLayoutGuide:keyboardLayoutGuide];
    [self addSubview:keyboardLayoutGuide];
    
    // constrints
    keyboardLayoutGuide.translatesAutoresizingMaskIntoConstraints = NO;
    [keyboardLayoutGuide.heightAnchor constraintEqualToConstant:0].active = YES;
    [keyboardLayoutGuide.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [keyboardLayoutGuide.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    // bottomConstraint
    NSLayoutYAxisAnchor *bottomAnchor;
    if (@available(iOS 11.0, *)) {
        bottomAnchor = self.safeAreaLayoutGuide.bottomAnchor;
    } else {
        bottomAnchor = self.bottomAnchor;
    }
    keyboardLayoutGuide.bottomConstraint = [keyboardLayoutGuide.bottomAnchor constraintEqualToAnchor:bottomAnchor];
    keyboardLayoutGuide.bottomConstraint.active = YES;
    [self initKeyboardLayoutGuideConstraints];
    
    id<ALKeyboardManagerDelegate> delegate = (id<ALKeyboardManagerDelegate>)self; // 因為在 Category 裡面不能聲明 Conform 某個 protocol，但我確知 self 有實作，於是在此轉型。
    [[ALKeyboardManager sharedManager] addDelegate:delegate];
    
    return keyboardLayoutGuide;
}

- (void)initKeyboardLayoutGuideConstraints {
    [self updateKeyboardLayoutGuideConstraintsIfNeededWithIsInit:YES];
}

- (void)updateKeyboardLayoutGuideConstraintsIfNeeded {
    [self updateKeyboardLayoutGuideConstraintsIfNeededWithIsInit:NO];
}

- (void)updateKeyboardLayoutGuideConstraintsIfNeededWithIsInit:(BOOL)isInit {
    UIWindow *window = ([self isKindOfClass:[UIWindow class]])? (UIWindow *)self : self.window;
    double constant = [[ALKeyboardManager sharedManager] keyboardTopYInWindow:window] - CGRectGetHeight(window.frame);
    if (isInit) {
        self.keyboardLayoutGuide.bottomConstraint.constant = constant;
        return;
    }
    
    if (constant == self.keyboardLayoutGuide.bottomConstraint.constant) {
        return;
    }
    self.keyboardLayoutGuide.bottomConstraint.constant = constant;
    
    NSTimeInterval animationDuration = [ALKeyboardManager sharedManager].keyboardChangeFrameAnimationDuration;
    UIViewAnimationOptions animationCurveOptions = [ALKeyboardManager sharedManager].keyboardChangeFrameAnimationCurveOptions;
    
    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | animationCurveOptions) animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}



#pragma mark - Accessor

- (ALKeyboardLayoutGuide *)keyboardLayoutGuide {
    ALKeyboardLayoutGuide *keyboardLayoutGuide = objc_getAssociatedObject(self, _cmd);
    if (!keyboardLayoutGuide) {
        keyboardLayoutGuide = [self setupKeyboardLayoutGuide];
    }
    return keyboardLayoutGuide;
}

- (void)setKeyboardLayoutGuide:(ALKeyboardLayoutGuide *)keyboardLayoutGuide {
    objc_setAssociatedObject(self, @selector(keyboardLayoutGuide), keyboardLayoutGuide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

