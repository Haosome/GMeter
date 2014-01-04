//
//  MessagingToolAppDelegate.h
//  GBluetooth
//
//  Created by Lion User on 04/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface MessagingToolAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GKSession *currentSession;
@property (nonatomic) int step;
@property (nonatomic,strong) NSString *command;
@property (nonatomic)int fileNumberCount;
@property (nonatomic,strong)NSArray *requiredList;

@end
