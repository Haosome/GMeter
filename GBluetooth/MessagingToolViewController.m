//
//  MessagingToolViewController.m
//  GBluetooth
//
//  Created by Lion User on 04/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "MessagingToolViewController.h"
#import "/Users/haoguo/Desktop/GBluetooth/kolpanic-zipkit-531cd75fef32/ZKFileArchive.h"
#import "/Users/haoguo/Desktop/GBluetooth/kolpanic-zipkit-531cd75fef32/ZKDataArchive.h"
#define REQUIRELIST @"11111101"
#define DOWNLOADFILES @"11111100"

@interface MessagingToolViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnRequireList;
@property (strong, nonatomic) IBOutlet UISwitch *manualSwitch;
@property (strong, nonatomic) IBOutlet UIButton *btnChoosePeer;
@property (strong, nonatomic) IBOutlet UITextField *textMsg;
@property (strong, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) IBOutlet UIButton *btnClear;
@property (strong, nonatomic) IBOutlet UIButton *btnFindPeer;
@property (strong, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (strong, nonatomic) IBOutlet UITextView *textLog;
@property (strong, nonatomic) IBOutlet UIButton *btnConnect;
@property (atomic) int step;
@property (nonatomic,strong) NSString *fn;
@property (nonatomic,strong) NSArray *serverFileList;
@property (nonatomic,strong) NSArray *requestedListForServer;
@property  (nonatomic,strong)ZKFileArchive *archive;
@end

@implementation MessagingToolViewController
@synthesize step=_step;//0 receive command, 1 receive list
@synthesize serverFileList = _serverFileList;
@synthesize manualSwitch;
@synthesize archive = _archive;
@synthesize btnChoosePeer;
@synthesize textMsg;
@synthesize fn = _fn;//file name for receiving
@synthesize btnSend;
@synthesize connectingList = _connectingList;
@synthesize btnClear;
@synthesize btnFindPeer;
@synthesize btnDisconnect;
@synthesize requestedListForServer = _requestedListForServer;
@synthesize currentSession = _currentSession;
@synthesize textLog;
@synthesize btnConnect;
@synthesize fileName = _fileName;//file name for sending
GKPeerPickerController *picker;

- (void)session:(GKSession *)session
           peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    switch (state)
    {
        case GKPeerStateConnected:{
            [session setDataReceiveHandler:self withContext:nil];
            NSString *name = [_currentSession displayNameForPeer:peerID];
            self.textLog.text = [self.textLog.text stringByAppendingFormat:@"\n Connected to %@",name];
            break;
        }
        case GKPeerStateDisconnected:
            self.textLog.text = [self.textLog.text stringByAppendingFormat:@"\n%@",@"Disconnected"];
            self.currentSession.delegate = nil;
            self.currentSession = nil;
            break;
        case GKPeerStateAvailable:{
            NSString *name = [_currentSession displayNameForPeer:peerID];
            self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
            self.textLog.text = [self.textLog.text stringByAppendingFormat:@"%@ found",name];
            break;
        }
    }
}

- (IBAction)requireListTouched:(id)sender {
    NSData* data;
    NSString *command = REQUIRELIST;
    data = [command dataUsingEncoding:NSUTF8StringEncoding];
        MessagingToolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.command = command;
    [self mySendDataToPeers:data];
}


-(void)downLoadRequestedFiles{
    NSData* data;
    MessagingToolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.command = DOWNLOADFILES;
    data = [DOWNLOADFILES dataUsingEncoding:NSUTF8StringEncoding];
    [self mySendDataToPeers:data];
    NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:delegate.requiredList];
    delegate.fileNumberCount = delegate.requiredList.count - 1;
    [self mySendDataToPeers:listData];
}

- (IBAction)sendTouched {
    
    NSData* data;
    data = [_fileName dataUsingEncoding:NSUTF8StringEncoding];
    [self mySendDataToPeers:data];
    self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
    self.textLog.text = [self.textLog.text stringByAppendingFormat:@"Begin to send file %@",_fileName];

    NSString *content = [MessagingToolModel getFileContent:_fileName];
    data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [self mySendDataToPeers:data];
    self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
    self.textLog.text = [self.textLog.text stringByAppendingFormat:@"Finish sending file %@",_fileName];
    
}

-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer
         inSession:(GKSession *)session
           context:(void *)context{//server

    
    if(_step == 0){//receive command
        
        NSString *command = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(command);
        if ([command isEqualToString:REQUIRELIST]) {
            NSArray *fileList = [MessagingToolModel requireList];
            NSData *listData = [NSKeyedArchiver archivedDataWithRootObject:fileList];
            [self mySendDataToPeers:listData];
        }else if ([command isEqualToString:DOWNLOADFILES]){
            _step = 1; //begin to receive file list
        }
        
    }else if (_step == 1){//receive list and send file
        
        _requestedListForServer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        for (int i = _requestedListForServer.count - 1 ; i>=0; i--) {
            
            //NSString *content = [MessagingToolModel getFileContent:[_requestedListForServer objectAtIndex:i]];
            //data = [content dataUsingEncoding:NSUTF8StringEncoding];
            //[self mySendDataToPeers:data];
            NSData *myData = [NSData dataWithContentsOfFile:[[MessagingToolModel getDirectory] stringByAppendingPathComponent:[_requestedListForServer objectAtIndex:i]]];
            NSLog([[MessagingToolModel getDirectory] stringByAppendingPathComponent:[_requestedListForServer objectAtIndex:i]]);
            [self mySendDataToPeers:myData];
            self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
            self.textLog.text = [self.textLog.text stringByAppendingFormat:@"Finish sending file %@",[_requestedListForServer objectAtIndex:i]];
        }
    _step = 0;
    }
}

//-(void)receiveData:(NSData *)data fromPeer:(NSString *)peer
//         inSession:(GKSession *)session
//           context:(void *)context{//client
//    
//    MessagingToolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    NSString *name = [_currentSession displayNameForPeer:peer];
//    if([delegate.command isEqualToString:REQUIRELIST]){
//
//        _serverFileList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        [self performSegueWithIdentifier:@"RequestList" sender:nil];
//    }else if ([delegate.command isEqualToString:DOWNLOADFILES] && delegate.fileNumberCount >=0){
//            NSLog([delegate.requiredList objectAtIndex:delegate.fileNumberCount]);
//            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            [MessagingToolModel writeToFile:[delegate.requiredList objectAtIndex:delegate.fileNumberCount] contentToWrite:content];
//            self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
//            self.textLog.text = [self.textLog.text stringByAppendingFormat:@"Recived file %@ from %@",[delegate.requiredList objectAtIndex:delegate.fileNumberCount], name];
//        
//        delegate.fileNumberCount -- ;
//        
//        if(delegate.fileNumberCount == -1){
//        delegate.requiredList = nil;
//        }
//    }
//}


- (IBAction)connectTouched {
    
    if (self.manualSwitch.on == YES) {
        for (int i =0; i<_connectingList.count; i++) {
           NSString *peerID = [_connectingList objectAtIndex:i];
            [self.currentSession  connectToPeer:peerID withTimeout:10000];
        }

    }else {
        NSArray *availablePeers = [_currentSession peersWithConnectionState:GKPeerStateAvailable];
        for (int i =0; i<availablePeers.count; i++) {
            NSString *peerID = [availablePeers objectAtIndex:i];
            
            [self.currentSession  connectToPeer:peerID withTimeout:10000];
        }
    }
}

-(void)CreateFiles{
  
}

- (IBAction)clearTouched:(id)sender {
    
     self.textLog.text = nil;
}


- (IBAction)findPeerTouched {

    
    [self startSearchingServer];
}

-(void) startSearchingServer{
    
    if(self.currentSession == nil){

        NSString *sessionIDString = @"Client";
        //create GKSession object
        GKSession *session = [[GKSession alloc] initWithSessionID:sessionIDString displayName:nil sessionMode:GKSessionModePeer];
        self.currentSession = session;
        self.currentSession.delegate = self;
        self.currentSession.available = YES;
    }
}

- (IBAction)disconnectTouched:(id)sender {
    [self.currentSession disconnectFromAllPeers];
    _currentSession.available = NO;
    _currentSession = nil;
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    [self.currentSession    acceptConnectionFromPeer:peerID error:nil];
}
- (void) mySendDataToPeers:(NSData *) data
{
    if (self.currentSession)
        [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}


-(void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
 
   // NSLog(@"%@",error.localizedFailureReason);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textMsg resignFirstResponder];
    textMsg.text = nil;
    return NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [textMsg resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    MessagingToolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _step = delegate.step;
    _currentSession = delegate.currentSession;
    if (delegate.requiredList != nil) {
        [self downLoadRequestedFiles];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    MessagingToolAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.currentSession = _currentSession;
    delegate.step = _step;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    self.textMsg.delegate =self;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"data"];
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *name = @"Jan.xml";
    
//    NSString *xmlData = @"<January>\n ";
//    [MessagingToolModel writeToFile:name contentToWrite:xmlData];
    
//    NSArray *category = [[NSArray alloc] initWithObjects:@"lighting",@"laundary",@"charging",@"heating",@"stove",@"of", nil];
//    
//        for (int p =28; p<=31; p++) {//day
//          NSString * xmlData = [NSString stringWithFormat:@"<day%i>",p];
//                        
//            for (int j = 1; j<=24; j++) {//hour
//                xmlData = [xmlData stringByAppendingFormat:@"<hour%i>",j];
//                for (int q = 1; q<=4; q++){//quarter
//                    
//                    xmlData = [xmlData stringByAppendingFormat:@"<quarter%i>",q];
//                    
//                    for (int c = 0; c<6; c++) {
//                        xmlData = [xmlData stringByAppendingFormat:@"<%@>",[category objectAtIndex:c]];
//                        xmlData = [xmlData stringByAppendingFormat:@"%i",arc4random()%10];
//                        xmlData = [xmlData stringByAppendingFormat:@"</%@>\n",[category objectAtIndex:c]];
//                    }
//                    xmlData = [xmlData stringByAppendingFormat:@"</quarter%i>\n",q];
//                }//quarter
//                xmlData = [xmlData stringByAppendingFormat:@"</hour%i>\n",j];
//            }//hour
//            xmlData = [xmlData stringByAppendingFormat:@"</day%i>\n",p];
//            [MessagingToolModel appendToFile:name contentToAppend:xmlData];
//        }//day
//  NSString * xmlData = @"</January>\n";
//    [MessagingToolModel appendToFile:name contentToAppend:xmlData];
//    NSString *zipFilePath = [[MessagingToolModel getDirectory] stringByAppendingPathComponent:@"data.zip"];
    
//    self.archive = [ZKFileArchive archiveWithArchivePath:zipFilePath];
//    [self.archive inflateToDiskUsingResourceFork:NO];
//    [self.archive deflateDirectory:[[MessagingToolModel getDirectory] stringByAppendingPathComponent:@"data"] relativeToPath:[MessagingToolModel getDirectory] usingResourceFork:NO];
//    //NSLog(@"%i",result);
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentDirectory = [paths objectAtIndex:0];
//        NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"January"];
//    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *name1,*name2;
//    for (int p = 1; p<=31; p++) {//day
//        NSString *name = @"Jan";
//       name = [name stringByAppendingFormat:@"_%i",p];
//        name1 = name;
//        for (int j = 1; j<=24; j++) {//hour
//            name = name1;
//            name = [name stringByAppendingFormat:@"_%i",j];
//            name2 = name;
//            for (int i=1; i<=6; i++) {//cat
//                name = name2;
//                NSString *cat;
//                
//                switch (i) {
//                    case 1:
//                        cat = @"lighting";
//                        break;
//                    case 2:
//                        cat = @"laundary";break;
//                    case 3:
//                        cat = @"charging";break;
//                    case 4:
//                        cat = @"heating";break;
//                        case 5:
//                        cat = @"stove";break;
//                        case 6:
//                        cat = @"o&f";break;
//                    default:
//                        break;
//                }
//                
//                name = [name stringByAppendingString:@"_"];
//                name = [name stringByAppendingString:cat];
//                 NSString *content = [[NSString alloc] init];
//                for (int q=1; q<=4; q++) {
//                    
//                    content = [content stringByAppendingFormat:@"%i %i\n",q*15,arc4random()%10];
//                }
// 
//                    [MessagingToolModel writeToFile:name contentToWrite:content];
//            }
//        }
//    }
    
    
    
   // [MessagingToolModel deleteAllFiles];
   self.textLog.text = [self.textLog.text stringByAppendingString:@"\n"];
    self.textLog.text = [self.textLog.text stringByAppendingFormat:@"File Chosen: %@",_fileName];
}

- (void)viewDidUnload
{

    [self setTextMsg:nil];
    [self setBtnSend:nil];
    [self setBtnClear:nil];
    [self setTextLog:nil];
    [self setBtnFindPeer:nil];
    [self setBtnDisconnect:nil];
    [self setTextLog:nil];
    [self setBtnChoosePeer:nil];
    [self setManualSwitch:nil];
    [self setBtnConnect:nil];
    [self setBtnRequireList:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
        if([segue.identifier isEqualToString: @"RequestList"])
            [segue.destinationViewController setFileList:_serverFileList];
    if ([segue.identifier isEqualToString: @"choosePeer"]) {
        [segue.destinationViewController setCurrentSession:_currentSession];

    }
}

@end
