//
//  ConnectViewController.h
//  LocalChat
//
//  Created by Erick Bennett on 11/25/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ConnectViewController : UIViewController <MCBrowserViewControllerDelegate>  {
    AppDelegate *myAppDelegate;
}
@property (weak, nonatomic) IBOutlet UITableView *connectionsTableView;
@property (nonatomic, strong) NSArray *connectedPeers;

@end
