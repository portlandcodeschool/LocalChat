//
//  MPCManager.m
//  LocalChat
//
//  Created by Erick Bennett on 12/1/14.
//  Copyright (c) 2014 Portland Code School. All rights reserved.
//

#import "MPCManager.h"

@implementation MPCManager

-(id)init {
    self = [super init];
    
    if (self) {
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
        
        self.connectedPeers = [[NSMutableArray alloc] init];
        
        [self setupPeerAndSessionWithDisplayName:@"Erick"];
        [self advertiseSelf:TRUE];
        
    }
    
    return self;
}



-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName {
    
    self.peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}

-(void)setupMCBrowser {
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat" session:self.session];
}

-(void)advertiseSelf:(BOOL)shouldAdvertise {
 
    if (shouldAdvertise) {
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat" discoveryInfo:nil session:self.session];
        
        [self.advertiser start];

    } else {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
}

-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}


-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    //state 0 = Not Connected
    //state 1 = Connecting
    //State 2 = Connected
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [self.connectedPeers addObject:peerID.displayName];
        }
        else if (state == MCSessionStateNotConnected){
            if ([self.connectedPeers count] > 0) {
                NSInteger indexOfPeer = [self.connectedPeers indexOfObject:peerID.displayName];
                [self.connectedPeers removeObjectAtIndex:indexOfPeer];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MPCDidChangeStateNotification" object:nil];
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    
}

-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    
}

@end
