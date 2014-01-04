//
//  MessagingToolViewController.h
//  GBluetooth
//
//  Created by Lion User on 04/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MessagingToolAppDelegate.h"
#import "MessagingToolPeerSelectionViewController.h"
#import "MessagingToolModel.h"
#import "MessagingToolServerFileListViewController.h"
@interface MessagingToolViewController : UIViewController<GKSessionDelegate,UITextFieldDelegate>

@property (strong,nonatomic) NSString *fileName;
@property (strong,nonatomic) NSArray *connectingList;
@property (nonatomic,retain)GKSession *currentSession;

-(void)downLoadRequestedFiles;
@end
