//
//  OperadorAppAppDelegate.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 27/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppDelegate.h"

#import "OAprivate-configure.h"

#import "MKStoreManager.h"
#import "UAPush.h"

#import "OperadorAppViewController.h"

@implementation OperadorAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [FlurryAnalytics startSession:FLURRY_TOKEN];
    
    [MKStoreManager sharedManager];
    
    //  UrbanAirship
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [UAirship takeOff:takeOffOptions];
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = [[OperadorAppViewController new] autorelease];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UAirship land];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
    [[UAirship shared] registerDeviceToken:deviceToken];
}

- (void)dealloc{
    [_window release];
    [super dealloc];
}

@end
