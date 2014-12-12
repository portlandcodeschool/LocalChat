//
//  ViewController.m
//  LocalChat
//
//  Created by Erick Bennett on 11/20/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

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

- (IBAction)send:(id)sender {
    
    [self sendMyMessage];
    
}

-(void)sendMyMessage {
    
    //We dont want to send a blank message, check to make sure there is at least one character in the text box.
    if (self.textInput.text.length > 0) {
        
        //make a reference to our existing AppDelegate
        AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //Convert the text in our input to NSData since this is the format we need in the sendData method below.
        NSData *dataToSend = [self.textInput.text dataUsingEncoding:NSUTF8StringEncoding];
        
        //We also need to create an NSError reference in case the method below returns an error. Returning this error is a function of this particular method.
        NSError *error;
        
        //We need an NSArray type class, the method will crash if given the mutable array that exists in the MPCManager.
        NSArray *allPeers = myAppDelegate.mpcManager.connectedPeers;
        
        //In our mpcManager session object, run this method to send the data.
        [myAppDelegate.mpcManager.session sendData:dataToSend toPeers:allPeers withMode:MCSessionSendDataReliable error:&error];
        
        //Format the display of our text chat view  so it is clear that this message is from you and also displays the text you wrote.
        NSString *formatedTextWithDisplayName = [NSString stringWithFormat:@"Me:\n %@\n\n",self.textInput.text];
        
        //Using our custom method, pass the formatted string to display
        [self updateChatViewWithString:formatedTextWithDisplayName];
        
        //Clear out our text input view (where we type our message into) since the message has been sent.
        self.textInput.text = @"";
    
    }
    
    //Hide the keyboard
    [self hideKeyboard];
    
}

-(void)updateChatViewWithString:(NSString *)textForView {
    //Use this method to update our chatView window by taking the existing chat text view text and appending the new text that came in as an argument - textForView.
    self.chatTextView.text = [self.chatTextView.text stringByAppendingString:textForView];
    
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

}

#pragma mark -
#pragma mark UITextfield delegate methods

//This delegate method gets called when the user presses return.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Send our message if the user hits return
    [self sendMyMessage];
    
    //We can remove this [self hideKeyboard] call in this method since our [self sendMyMessage] also calls [self hidekeyboard]
    
    //Dismiss the keyboard by calling this method.
   // [self hideKeyboard];
    
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
