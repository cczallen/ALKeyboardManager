//
//  ALMulticastDelegate.m
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

//  Ref: MrBoog/SafeMulticastDelegate https://github.com/MrBoog/SafeMulticastDelegate
//

#import "ALMulticastDelegate.h"

@interface ALMulticastDelegate ()
@property (strong, nonatomic) NSHashTable *delegates;
@end

@implementation ALMulticastDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}



#pragma mark - Public

- (void)addDelegate:(id)delegate {
    if (delegate != nil) {
        [self.delegates addObject:delegate];
    } else {
        NSAssert(NO, @"delegate couldn't be nil");
    }
}

- (void)removeDelegate:(id)delegate {
    [self.delegates removeObject:delegate];
}

- (void)removeAllDelegates {
    [self.delegates removeAllObjects];
}



#pragma mark - override

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    for (id delegate in self.delegates) {
        NSMethodSignature *result = [delegate methodSignatureForSelector:aSelector];
        if (result != nil) {
            return result;
        }
    }
    
    // prevent crash
    return [[self class] instanceMethodSignatureForSelector:@selector(doNothing)];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:sel]) {
            [invocation invokeWithTarget:delegate];
            
        } else {
            // prevent crash
            [self doNothing];
        }
    }
}

- (void)doNothing{
    // prevent crash: Delegate does not respond to selector
    //    NSLog(@"ALMulticastDelegate: -------> %s",__func__);
}

@end


