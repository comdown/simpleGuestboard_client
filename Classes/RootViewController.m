//
//  RootViewController.m
//  guestbook_client
//
//  Created by comdown on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MessageViewController.h"
#import "AppDefine.h"
#import "EntityDefine.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RootViewController

NSUInteger SIZE_BUFFER = 1024;

@synthesize m_sendConnection;
@synthesize m_tableData;
@synthesize m_receivedData;

- (void)RequestDataFromServer
{
	// Setting up to download server data
	NSString* url_string = [NSString stringWithFormat:@"%@%@", SERVER_URL, ACTION_GET];
	NSURL* url = [NSURL URLWithString:url_string];
	NSURLRequest* request = [NSURLRequest requestWithURL:url 
											 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (!connection) {
		// error handling
	} else {
		// Connected successfully
	}
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	
	// Navigation buttons
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(OnComposeButtomPressed)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];

	
	// Initialize member vaiables
	m_receivedData = [[NSMutableData alloc] initWithCapacity:SIZE_BUFFER];
	m_tableData = [[NSArray alloc] init];
	
	m_sendConnection = nil;
	
	// ..
	[self RequestDataFromServer];
}


// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


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


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	assert( m_tableData );
	assert( [m_tableData count] >= indexPath.row );
	
	NSDictionary *cell_data = [m_tableData objectAtIndex:indexPath.row];

	cell.detailTextLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
	cell.textLabel.text = [cell_data objectForKey:KEY_NAME];
	cell.detailTextLabel.text = [cell_data objectForKey:KEY_CONTENT];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [m_tableData count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BOARD_CELL_HEIGHT;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the managed object for the given index path
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        // Save the context.
//        NSError *error = nil;
//        if (![context save:&error]) {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// Navigation logic may go here -- for example, create and push another view controller.
    MessageViewController *detailViewController = [[MessageViewController alloc] initWithNibName:@"MessageView" bundle:nil];

	NSMutableDictionary* aMessage = [m_tableData objectAtIndex:indexPath.row];
	
	detailViewController.title = [aMessage objectForKey:KEY_NAME];
	detailViewController.keyForMessage = [aMessage objectForKey:KEY_KEY];
//	detailViewController.m_message = aMessage;

    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[m_tableData release];
	[m_receivedData release];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Network delegate


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
	[m_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DidFinishLoading called");
	
	[connection release];
	
	if (connection == m_sendConnection) {
		[self RequestDataFromServer];
		return ;
	}
	
	if ([m_receivedData length] == 0) {
		NSLog(@"Size of received data is zero. Just returned");
		return ;
	}
	

	// For testing purpose
	[m_receivedData writeToFile:@"./receivedData.txt" atomically:YES];

	
	NSError* error;
	NSArray* response = [NSPropertyListSerialization propertyListWithData:m_receivedData options:NSPropertyListOpenStepFormat format:NULL error:&error];

	if (!response) {
		// Error handling
		NSLog(@"%@", [error localizedDescription]);
		return ;
	}
	
	// Do sth with response
	self.m_tableData = [response retain];
	[response release];
	
	[self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
	NSLog(@"Response Connection: %x", connection);

	if (connection != m_sendConnection) {
		[m_receivedData setLength:0];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"%@", [error localizedDescription]);	
	
	[connection release];
	
	// TODO : Nofity the Error!
}

#pragma mark -
#pragma mark Private Methods
- (void)OnComposeButtomPressed
{
	TTPostController *postController = [[[TTPostController alloc] init] autorelease];
	postController.delegate = self; // self must implement the TTPostControllerDelegate protocol
	
	[postController showInView:self.view animated:YES];
}

- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
	NSString* urlStr = [NSString stringWithFormat:@"%@%@", SERVER_URL, ACTION_POST];
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	
	// 전송할 데이터를 변수명=값&변수명=값 형태의 문자열로 등록
	NSString* strBody = [NSString stringWithFormat:@"author=%@&content=%@&category=%@", USERNAME, text, CATEGORY];
	[request setHTTPBody:[strBody dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	NSLog(@"send Connection: %x", connection);
	
	
	if (!connection) {
		// error handling
		NSLog(@"Occured an error while creating connection");
	} else {
		// Don't want to retain. Just trying to save the address
		m_sendConnection = connection;
	}
	
	return YES;	// dismiss the controller
}

@end

