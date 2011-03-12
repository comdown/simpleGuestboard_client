//
//  guestbook_clientAppDelegate.h
//  guestbook_client
//
//  Created by comdown on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface guestbook_clientAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

