//
//  UIView+KeyboardLayoutGuide.h
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

// 對齊 keyboard top 的一條 0 高度的 view
@interface ALKeyboardLayoutGuide : UIView;
@end



@interface UIView (KeyboardLayoutGuide)

// 經典用法： 在 masonry 中 make.bottom.equalTo(self.view.keyboardLayoutGuide.mas_top);
@property (strong, nonatomic) ALKeyboardLayoutGuide *keyboardLayoutGuide;

@end



