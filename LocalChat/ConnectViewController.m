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
}

-(void)addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPCDidChangeState:) name:@"MPCDidChangeStateNotification" object:nil];
}

-(void)MPCDidChangeState:(NSNotification *) notification {
    self.connectedPeers = myAppDelegate.mpcManager.connectedPeers;
    [self.connectionsTableView reloadData];

}

- (IBAction)browse:(id)sender {
    [myAppDelegate.mpcManager setupMCBrowser];
    myAppDelegate.mpcManager.browser.delegate = self;
    [self presentViewController:[myAppDelegate.mpcManager browser] animated:YES completion:^{
        
    }];
    
}

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [myAppDelegate.mpcManager.browser dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
