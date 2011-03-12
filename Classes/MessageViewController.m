//
//  MessageViewController.m
//  guestbook_client
//
//  Created by comdown on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageViewController.h"
#import "EntityDefine.h"
#import "AppDefine.h"

@implementation MessageViewController
@synthesize keyForMessage;
@synthesize m_sendConnection;
@synthesize m_receivedData;
@synthesize m_dataReply;
@synthesize m_message;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	// Navigation buttons
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(OnComposeReplyButtomPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	// Initialize member vaiables
	m_receivedData = [[NSMutableData alloc] initWithCapacity:1024];
	m_sendConnection = nil;
	NSMutableString *str = [m_message objectForKey:KEY_CONTENT];
	[str appendFormat:@"appended!"];
	
	self.m_dataReply = [m_message objectForKey:KEY_REPLIES];
//	m_message = [[NSDictionary alloc] init];

	[self RequestDataFromServer];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	return [m_message objectForKey:KEY_CONTENT];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [m_dataReply count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSDictionary* reply = [m_dataReply objectAtIndex:indexPath.row];
	
	NSString* strToDisplay = [NSString stringWithFormat:@"%@", [reply objectForKey:KEY_CONTENT]];

   	cell.textLabel.text = strToDisplay;
    
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[m_message release];
	[keyForMessage release];
	[m_sendConnection release];
	[m_receivedData release];
	[m_dataReply release];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Posting Replies

- (void)OnComposeReplyButtomPressed
{
	TTPostController *postController = [[[TTPostController alloc] init] autorelease];
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol
	
	[postController showInView:self.view animated:YES];
}

- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
	NSString* urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, ACTION_REPLY];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	
	// 전송할 데이터를 변수명=값&변수명=값 형태의 문자열로 등록
	NSString* strBody = [NSString stringWithFormat:@"key=%@&author=%@&content=%@", keyForMessage, USERNAME, text];
	[request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

	if (!connection) {
		// error handling
		NSLog(@"MessageViewController:: Occured an error while creating connection");
	} else {
		// Don't want to retain. Just trying to save the address
		m_sendConnection = connection;
	}
	
	return YES;	// dismiss the controller
}

- (void)RequestDataFromServer
{
	// Setting up to download server data
	NSString* url_string = [NSString stringWithFormat:@"%@%@?key=%@", SERVER_URL, ACTION_REPLY, keyForMessage];
	NSURL* url = [NSURL URLWithString:url_string];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (!connection) {
		// error handling
		NSLog(@"reply: connection failed");
	} else {
		// Connected successfully
		NSLog(@"reply: connection succeeded");
	}
}

#pragma mark -
#pragma mark Network delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[m_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"MessageViewController::DidFinishLoading called");
	
	[connection release];
	
	if (connection == m_sendConnection) {
		[self RequestDataFromServer];
		return ;
	}
	
	if ([m_receivedData length] == 0) {
		NSLog(@"MessageViewController::Size of received data is zero. Just returned");
		return ;
	}
	
	
	// For testing purpose
	[m_receivedData writeToFile:@"./receivedData_reply.txt" atomically:YES];
	
	
	NSError* error;
	NSMutableDictionary* response = [NSPropertyListSerialization propertyListWithData:m_receivedData options:NSPropertyListOpenStepFormat format:NULL error:&error];
	
	if (!response) {
		// Error handling
		NSLog(@"MessageViewController: %@", [error localizedDescription]);
		return ;
	}
	
	self.m_message = response;
	
	// Do sth with response
	NSArray* replies = [[NSArray alloc] initWithArray:[response objectForKey:KEY_REPLIES] copyItems:YES];
	self.m_dataReply = replies;
	
	[self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"MessageViewController:: Response Connection: %x", connection);
	
	if (connection != m_sendConnection) {
		[m_receivedData setLength:0];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"MessageViewController:: %@", [error localizedDescription]);	
	
	[connection release];
	
	// TODO : Nofity the Error!
}


@end

