//
//  ALKeyboardManager.m
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#import "ALKeyboardManager.h"
#import "ALMulticastDelegate.h"

// ALStringify：參數名稱轉換成 NSString 的 Macro。 其中利用 _arg_ 來達成在 IDE 中輸入時 AutoComplete 的效果。而是用 (1 || 在前方來運用編譯器優化的特性，避免掉在 runtime 做三元運算子比較的性能浪費。（if 比較中如果使用或運算，第一個為真則整體為真，後面就不用判斷了，而在編譯時期就可以確定為真的判斷式，編譯器也就可以把 else 的部分及判斷的部分全都省略了。）
#define ALStringify(_arg_)                   ((1 || _arg_)?  (@#_arg_):(@#_arg_))                                                                   // name -> @"name"


#define ALKeyboardManagerLog(object) {}

#ifdef DEBUG
#    ifdef ALKeyboardManagerLogEnabled
#        undef ALKeyboardManagerLog
#        define ALKeyboardManagerLog(object) NSLog(@"ALKeyboardManager LOG:  %@: %@", ALStringify(object), object);
#    endif
#endif


@interface ALKeyboardManager ()
@property (strong, nonatomic) ALMulticastDelegate<ALKeyboardManagerDelegate> *multicastDelegate;
@end

@implementation ALKeyboardManager

#pragma mark - LifeCycle

+ (void)load {
    // init sharedManager
    [self sharedManager];
}

+ (instancetype)sharedManager {
    static ALKeyboardManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (void)dealloc {
    [self unregisterNotifications];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetKeyboardProperties];
        [self registerNotifications];
    }
    return self;
}



#pragma mark - Public

- (CGFloat)keyboardTopYInKeyWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    return [self keyboardTopYInWindow:keyWindow];
}

- (CGFloat)keyboardTopYInWindow:(UIWindow *)window {
    CGFloat keyboardTopY;
    
    if (self.isKeyboardShowing) {
        keyboardTopY = CGRectGetMinY(self.keyboardFrame);
    } else {
        keyboardTopY = CGRectGetHeight(window.frame);
    }
    
    return keyboardTopY;
}

- (void)addDelegate:(id<ALKeyboardManagerDelegate>)delegate {
    [self.multicastDelegate addDelegate:delegate];
}

- (void)removeDelegate:(id<ALKeyboardManagerDelegate>)delegate {
    [self.multicastDelegate removeDelegate:delegate];
}



#pragma mark - Accessor

- (ALMulticastDelegate<ALKeyboardManagerDelegate> *)multicastDelegate {
    if (!_multicastDelegate) {
        _multicastDelegate = [[ALMulticastDelegate<ALKeyboardManagerDelegate> alloc] init];
    }
    
    return _multicastDelegate;
}

- (BOOL)isKeyboardShowing {
    return !CGRectIsNull(self.keyboardFrame);
}



#pragma mark - Private

- (void)resetKeyboardProperties {
    self.keyboardFrame = CGRectNull;
    [self resetKeyboardAnimationProperties];
}

- (void)resetKeyboardAnimationProperties {
    self.keyboardChangeFrameAnimationDuration = 0;
    self.keyboardChangeFrameAnimationCurveOptions = kNilOptions;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}



#pragma mark - Notifications

#pragma mark ChangeFrame

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    self.keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self setKeyboardAnimationPropertiesWithNotification:notification];
    
    // multicast to delegates
    [self.multicastDelegate keyboardManagerKeyboardUpdateFrame];
    
    ALKeyboardManagerLog(notification);
}

#pragma mark Hide

- (void)keyboardDidHide:(NSNotification *)notification {
    [self resetKeyboardProperties];
    
    // multicast to delegates
    [self.multicastDelegate keyboardManagerKeyboardUpdateFrame];
    
    ALKeyboardManagerLog(notification);
}

#pragma mark Utility

- (void)setKeyboardAnimationPropertiesWithNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    
    self.keyboardChangeFrameAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.keyboardChangeFrameAnimationCurveOptions = curve << 16;
}

@end
