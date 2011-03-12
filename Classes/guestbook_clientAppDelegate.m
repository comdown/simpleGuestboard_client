//
//  guestbook_clientAppDelegate.m
//  guestbook_client
//
//  Created by comdown on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "guestbook_clientAppDelegate.h"
#import "RootViewController.h"


@implementation guestbook_clientAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    
    [navigationController release];
    [window release];
    [super dealloc];
}


@end

