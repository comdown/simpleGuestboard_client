//
//  RootViewController.h
//  guestbook_client
//
//  Created by comdown on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface RootViewController : UITableViewController <TTPostControllerDelegate> {

	// Data array for table.
	NSArray *m_tableData;
	
	// This is like a buffer. Stores data from server.
	NSMutableData *m_receivedData;
	
	// saving sending connection for refresh
	NSURLConnection *m_sendConnection;

}

- (void)RequestDataFromServer;

@property (nonatomic, retain) NSURLConnection *m_sendConnection;

@property (nonatomic, retain) NSArray *m_tableData;
@property (nonatomic, retain) NSMutableData *m_receivedData;

@end
