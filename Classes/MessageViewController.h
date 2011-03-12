//
//  MessageViewController.h
//  guestbook_client
//
//  Created by comdown on 2/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>

@interface MessageViewController : UITableViewController<TTPostControllerDelegate> {
	NSString* keyForMessage;
	NSArray *m_dataReply;
	
	NSMutableDictionary* m_message;
	
	NSURLConnection* m_sendConnection;
	NSMutableData *m_receivedData;
}

@property (nonatomic, retain) NSMutableDictionary* m_message;
@property (nonatomic, retain) NSString* keyForMessage;
@property (nonatomic, retain) NSURLConnection* m_sendConnection;
@property (nonatomic, retain) NSMutableData *m_receivedData;
@property (nonatomic, retain) NSArray *m_dataReply;

-(void) RequestDataFromServer;

@end
