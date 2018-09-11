//
//  ALMulticastDelegate.h
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALMulticastDelegate : NSObject

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

@end

