//
//  ConnectViewController.m
//  LocalChat
//
//  Created by Erick Bennett on 11/25/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import "ConnectViewController.h"

@interface ConnectViewController ()

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.connectedPeers = myAppDelegate.mpcManager.connectedPeers;
    
    //Dont forget to actually run the method that adds our notification. We moved it out of the viewdidload and into its own incase we wanted to add other notifications. This is purely a developer preference.
    [self addNotifications];
    
    BOOL savedVisibility = [[NSUserDefaults standardUserDefaults] boolForKey:@"visibility"];
    
    self.visibilitySwitch.on = savedVisibility;
    
    self.displayNameText.text = myAppDelegate.mpcManager.peerID.displayName;


}

-(void)addNotifications {
    
    //Subscribe to MPCDidChangeStateNotification notifications. This is how we get told that we have added a new peerID to our list of connections
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPCDidChangeState:) name:@"MPCDidChangeStateNotification" object:nil];
}

-(void)MPCDidChangeState:(NSNotification *) notification {
    //When this notification comes in, updated the local array of peers, with the list of peers in the mpcmanager.
    self.connectedPeers = myAppDelegate.mpcManager.connectedPeers;
    
    //Reload the table view so that it displays the updated connectedPeers info.
    [self.connectionsTableView reloadData];

}

- (IBAction)browse:(id)sender {
    //setup the MPC browser
    [myAppDelegate.mpcManager setupMCBrowser];
    
    //Assign this viewcontroller as its delegate. This will tell us when DONE or CANCEL is pressed so we can dismiss the browser from our view. Dismissing a view is usually dont on the viewcontroller that preseneted it.
    myAppDelegate.mpcManager.browser.delegate = self;
    
    //Present the mpcManager browser.
    [self presentViewController:[myAppDelegate.mpcManager browser] animated:YES completion:^{
     //This completion block would run after the view is presented. You might use this for some custom code need after the view was displayed.
    }];
    
}

- (IBAction)visibilityChanged:(id)sender {
    
    [myAppDelegate.mpcManager advertiseSelf:self.visibilitySwitch.isOn];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.visibilitySwitch.isOn forKey:@"visibility"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma -mark
#pragma mpcBrowser delegate calls
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    //Dismiss the mpcManager browser.
    [myAppDelegate.mpcManager.browser dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    
    //Dismiss the mpcManager browser.
    [myAppDelegate.mpcManager.browser dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
#pragma -mark
#pragma TableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //returns the number of sections you need.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //how many rows are in each of the above sections (Total number of cells needing to be displayed).
    return self.connectedPeers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //This sets the size of the cell at any given index.
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //The actual code to return each cell, configured with the data you want to display.
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    cell.textLabel.text = [self.connectedPeers objectAtIndex:indexPath.row];
    
    return cell;
    
}

#pragma -mark
#pragma TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //This delegate method gets call when a user taps a TableView cell. This method sends the index of the tapped cell in the indexpath argument.
    
    //Show an animated deselection of the selected cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma -mark
#pragma UITextfield

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.displayNameText resignFirstResponder];
    
    if (self.visibilitySwitch.isOn) {
        [myAppDelegate.mpcManager advertiseSelf:NO];
    }
    
    myAppDelegate.mpcManager.peerID = nil;
    myAppDelegate.mpcManager.session = nil;
    myAppDelegate.mpcManager.browser = nil;
    myAppDelegate.mpcManager.advertiser = nil;
    
    
    [myAppDelegate.mpcManager setupPeerAndSessionWithDisplayName:self.displayNameText.text];
    
    [myAppDelegate.mpcManager advertiseSelf:self.visibilitySwitch.isOn];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.displayNameText.text forKey:@"displayName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
