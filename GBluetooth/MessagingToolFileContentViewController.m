//
//  MessagingToolFileContentViewController.m
//  GBluetooth
//
//  Created by Lion User on 19/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessagingToolFileContentViewController.h"
#import "MessagingToolViewController.h"
@interface MessagingToolFileContentViewController ()
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong, nonatomic) IBOutlet UITextView *fileContent;
@end

@implementation MessagingToolFileContentViewController
@synthesize sendBtn = _sendBtn;
@synthesize fileContent = _fileContent;
@synthesize fileName = _fileName;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _fileContent.text = [MessagingToolModel getFileContent:_fileName];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setFileContent:nil];
    [self setSendBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSString *newContent = _fileContent.text;
    [MessagingToolModel writeToFile:_fileName contentToWrite:newContent];
    
    
        [segue.destinationViewController setFileName:_fileName];
    
}

@end
