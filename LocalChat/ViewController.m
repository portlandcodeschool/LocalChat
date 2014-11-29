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
    /*
    The "UIKeyboardDidShowNotification" is sent when the keyboard is shown, and in ioS 8 when the quick text hides or unhides. This is the notification that fires this keyboardWasShown method. If I click on the "UIKeyboardFrameEndUSerInfoKey" in our previous code, the quick help on the right panel in Xcode will show all available keys related and available for this.
     
     These are the additional, similar keys it shows. Using these we can get additional information, not just "UIKeyboardFrameEndUSerInfoKey"
     
     UIKeyboardAnimationCurveUserInfoKey
     UIKeyboardAnimationDurationUserInfoKey
     UIKeyboardBoundsUserInfoKey
     UIKeyboardCenterBeginUserInfoKey
     UIKeyboardCenterEndUserInfoKey
     UIKeyboardFrameEndUserInfoKey
    
    In those keys, there is "UIKeyboardFrameBeginUserInfoKey" (the frame size before it shows on screen). Using that along with the existing "UIKeyboardFrameEndUserInfoKey" we can compute the size difference for when the keyboard initialy shows, and the difference in the keyboard size when the keyboard quick text is opend or closed.
     
     previous versions if the iOS dont have the quick text entry but still have these same keys available so this method works in iOS 7 and fixes the issue in iOS 8.
    
    */
    
    //Get keyboard frame before it is shown (its there at this point, just hidden below the bootom of our screen.
    CGRect keyboardStartFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    //For reference, log this startFrame to our console
    NSLog(@"**keyboardStartFrame**\n x = %f\n y = %f\n width = %f\n height = %f", keyboardStartFrame.origin.x, keyboardStartFrame.origin.y, keyboardStartFrame.size.width, keyboardStartFrame.size.height);
    
    //Get keyboard frame after it is shown.
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //For reference, log this startFrame to our console
    NSLog(@"**keyboardEndFrame**\n x = %f\n y = %f\n width = %f\n Height = %f", keyboardEndFrame.origin.x, keyboardEndFrame.origin.y, keyboardEndFrame.size.width, keyboardEndFrame.size.height);

    //Compute the difference in the 2 keyboard y origins.
    float origin = (keyboardStartFrame.origin.y - keyboardEndFrame.origin.y);
    
    //For reference, log this difference to our console
    NSLog(@"**Difference**\n keyboardStartFrame - keyboardEndFrame = %f", origin);
    
    [UIView animateWithDuration:.2 animations:^{
        //Create a new CGRect frame "newFrame" that can be modified since the frame property of our textEntryView cannot be modified directly.
        CGRect newFrame = self.textEntryView.frame;
        
        //Adjust our textEntryViews frame y origin by the difference
        newFrame.origin.y -= origin;
        
        //Reassign our textEntryView frame to our newly adjust frame.
        self.textEntryView.frame = newFrame;
    }];
    
    
    //Bonus question!
    
    //This method fires when our notification for "UIKeyboardDidShowNotification" comes in. We set this up in our ViewDidload. There is another keyboard notification to listen for instead that can be used that will move the keyboard at the same time the keyboard rises instead of after the keyboard has already finished risen? By using this other keyboard notification, it also correctly handles transitions to  portrait of landscape.

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
