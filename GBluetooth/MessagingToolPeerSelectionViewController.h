//
//  MessagingToolPeerSelectionViewController.h
//  GBluetooth
//
//  Created by Lion User on 11/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MessagingToolViewController.h"

@interface MessagingToolPeerSelectionViewController : UITableViewController
@property (nonatomic,strong) GKSession *currentSession;

@end
