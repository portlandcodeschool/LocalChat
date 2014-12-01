//
//  ViewController.h
//  LocalChat
//
//  Created by Erick Bennett on 11/20/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeight;

@property (weak, nonatomic) IBOutlet UIView *textEntryView;
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIButton *sendText;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;

@end

