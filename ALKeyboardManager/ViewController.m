//
//  ViewController.m
//  ALKeyboardManager
//
//  Created by ALLENMAC on 2018/9/11.
//  Copyright © 2018年 ALLENMAC. All rights reserved.
//

#import "ViewController.h"
#import "UIView+KeyboardLayoutGuide.h"
#import "ALKeyboardManager.h"

@interface ViewController () <ALKeyboardManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *toggleKeyboardButton;

- (IBAction)toggleKeyboardButtonAction:(id)sender;

@end

@implementation ViewController

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.toggleKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.keyboardLayoutGuide.topAnchor constant:-8].active = YES;
    
    [[ALKeyboardManager sharedManager] addDelegate:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toggleKeyboardButtonAction:(id)sender {
    if ([ALKeyboardManager sharedManager].isKeyboardShowing) {
        [self.textField resignFirstResponder];
    } else {
        [self.textField becomeFirstResponder];
    }
}



#pragma mark - <ALKeyboardManagerDelegate>

- (void)keyboardManagerKeyboardUpdateFrame {
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"isKeyboardShowing: %@", ([ALKeyboardManager sharedManager].isKeyboardShowing)? @"YES":@"NO"];
    [string appendString:@"\n"];
    [string appendFormat:@"keyboardFrame: %@", NSStringFromCGRect([ALKeyboardManager sharedManager].keyboardFrame)];
    [string appendString:@"\n"];
    [string appendFormat:@"keyboardChangeFrameAnimationDuration: %@", @([ALKeyboardManager sharedManager].keyboardChangeFrameAnimationDuration)];
    [string appendString:@"\n"];
    [string appendFormat:@"keyboardChangeFrameAnimationCurveOptions: %@", @([ALKeyboardManager sharedManager].keyboardChangeFrameAnimationCurveOptions)];
    
    self.textView.text = string;
}

@end
