//
//  ViewController.m
//  LocalChat
//
//  Created by Erick Bennett on 11/20/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Notify this ViewController when the keyboard is was shown.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    //Notify this ViewController when the keyboard will hide.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //Adding a tap gesture recognizer so if someone taps the screen, it will hide the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    //Set the number of taps required to initiate the action.
    tap.numberOfTapsRequired = 1;
    
    //Add this gesture recognizer to our views list of recognizers.
    [self.view addGestureRecognizer:tap];
}

-(void)hideKeyboard {
    [self.textInput resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    //Get the size of the keyboard so we know how far to move.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    //Move our view with a smooth animation subtracting the keyboard height.
    [UIView animateWithDuration:.2 animations:^{
        self.textEntryView.center = CGPointMake(self.textEntryView.center.x, self.textEntryView.center.y - keyboardSize.height);
    }];
  
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    //Get the size of the keyboard so we know how far to move.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Move our view with a smooth animation adding the keyboard height.
    [UIView animateWithDuration:.3 animations:^{
        self.textEntryView.center = CGPointMake(self.textEntryView.center.x, self.textEntryView.center.y + keyboardSize.height);
    }];
    
}

#pragma mark -
#pragma mark UITextfield delegate methods

//This delegate method gets called when the user presses return.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Dismiss the keyboard by calling this method.
    [self hideKeyboard];
    
    //Needs a return value to know if a return should be inserted in the textfield.
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
