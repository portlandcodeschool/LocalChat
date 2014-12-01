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
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    //Adding a tap gesture recognizer so if someone taps the screen, it will hide the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    //Set the number of taps required to initiate the action.
    tap.numberOfTapsRequired = 1;
    
    //Add this gesture recognizer to our views list of recognizers.
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillDisappear:(BOOL)animated {
    //Hide the keyboard if we navigate away from this view.
    [self hideKeyboard];
}

-(void)hideKeyboard {
    [self.textInput resignFirstResponder];
}

- (void)keyboardWasShown:(NSNotification *)notification
{

    //Get keyboard frame before it is shown (its there at this point, just hidden below the bootom of our screen.
    CGRect keyboardStartFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //Get keyboard frame after it is shown.
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //Get the animation curve being used by the keyboard animation. THis is returned as a NSNumber.
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    //Get the duration of the keyboard animation. This is returned as a NSNumber.
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    //Compute the difference in the 2 keyboard y origins.
    float originDifference = (keyboardStartFrame.origin.y - keyboardEndFrame.origin.y);
    
    //Fix for keyboard bug in iOS 7. iOS 7 reports the wrong frame size for the keyboard. It swaps the x/y and width/height so we need to compute the difference with x origin when on an iOS 7 device.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
        
        //Change our equation to use the x origin and reassign it to originDifference.
       originDifference = (keyboardStartFrame.origin.x - keyboardEndFrame.origin.x);
    }
    
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        
        //Set the animation curve for this animation so it matches the keyboard animation.
        [UIView setAnimationCurve:animationCurve.integerValue];
        
        //offset the layout constraint we referenced from the storyboard.
        self.keyboardHeight.constant -= originDifference;
        
        //Call layoutIfNeeded to finalize any existing changes.
        [self.view layoutIfNeeded];
    }];
    
    
    //Bonus question!
    
    //This method fires when our notification for "UIKeyboardDidShowNotification" comes in. We set this up in our ViewDidload. There is another keyboard notification to listen for instead that can be used that will move the keyboard at the same time the keyboard rises instead of after the keyboard has already finished risen? By using this other keyboard notification, it also correctly handles transitions to  portrait of landscape.

}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //Get keyboard frame before it is shown (its there at this point, just hidden below the bootom of our screen.
    CGRect keyboardStartFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    //Get keyboard frame after it is shown.
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //Get the animation curve being used by the keyboard animation.
    NSNumber *animationCurve = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    //Get the duration of the keyboard animation
    NSNumber *duration = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    //Compute the difference in the 2 keyboard y origins.
    float origin = (keyboardStartFrame.origin.y - keyboardEndFrame.origin.y);
    
    [UIView animateWithDuration:duration.floatValue animations:^{
        
        [UIView setAnimationCurve:animationCurve.integerValue];
        self.keyboardHeight.constant = origin;
        [self.view layoutIfNeeded];
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
