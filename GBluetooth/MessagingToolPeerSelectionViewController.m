//
//  MessagingToolPeerSelectionViewController.m
//  GBluetooth
//
//  Created by Lion User on 11/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessagingToolPeerSelectionViewController.h"

@interface MessagingToolPeerSelectionViewController ()

@end

@implementation MessagingToolPeerSelectionViewController

@synthesize currentSession = _currentSession;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelection = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_currentSession peersWithConnectionState:GKPeerStateAvailable].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    //cell.textLabel.text = [_peerNameList objectAtIndex:indexPath.row];
    cell.textLabel.text = [_currentSession displayNameForPeer:[[_currentSession peersWithConnectionState:GKPeerStateAvailable] objectAtIndex:indexPath.row]];
    // Configure the cell...
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    thisCell.accessoryType = UITableViewCellAccessoryNone;

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"choosed"]) {
        
        NSArray *index = [self.tableView indexPathsForSelectedRows];
        NSMutableArray *mconnectingList = [[NSMutableArray alloc]initWithCapacity:index.count];
        
        for(int i=0;i<index.count;i++){
            UITableViewCell *thisCell = [self.tableView cellForRowAtIndexPath: [index objectAtIndex:i]];
            
            NSArray *peerList = [_currentSession peersWithConnectionState:GKPeerStateAvailable];
            int p;
            for(p = 0; p<peerList.count;p++){
                NSString *name = [_currentSession displayNameForPeer:[peerList objectAtIndex:p]];
                if ([name isEqualToString: thisCell.textLabel.text]) {
                    break;
                }
            }
            
            [mconnectingList addObject:[peerList objectAtIndex:p]];
        }
        
        NSArray *connectingList = [[NSArray alloc] initWithArray:mconnectingList];
        
        [segue.destinationViewController setConnectingList:connectingList];
    }
}

@end
