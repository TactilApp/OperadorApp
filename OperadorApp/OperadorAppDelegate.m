//
//  OperadorAppAppDelegate.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 27/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppDelegate.h"

#import "MKStoreManager.h"
#import <UrbanAirship-iOS-SDK/UAirship.h>

#import "OperadorAppViewController.h"

@implementation OperadorAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    #ifdef FLURRY
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        [FlurryAnalytics startSession:FLURRY_TOKEN];
    #endif
    #ifdef TESTFLIGHT
        NSSetUncaughtExceptionHandler(&HandleExceptions);
        struct sigaction newSignalAction;
        memset(&newSignalAction, 0, sizeof(newSignalAction));
        newSignalAction.sa_handler = &SignalHandler;
        sigaction(SIGABRT, &newSignalAction, NULL);
        sigaction(SIGILL, &newSignalAction, NULL);
        sigaction(SIGBUS, &newSignalAction, NULL);

        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
        #pragma clang diagnostic pop

        [TestFlight takeOff:TESTFLIGHT_TOKEN];
    #endif
    
    [MKStoreManager sharedManager];
    
    //  UrbanAirship
    NSMutableDictionary *takeOffOptions = [[[NSMutableDictionary alloc] init] autorelease];
    [takeOffOptions setValue:launchOptions forKey:UAirshipTakeOffOptionsLaunchOptionsKey];
    [UAirship takeOff:takeOffOptions];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
        (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = [[OperadorAppViewController new] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [UAirship land];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[UAirship shared] registerDeviceToken:deviceToken];
}

- (void)dealloc{
    [_window release];
    [super dealloc];
}


#ifdef TESTFLIGHT
void HandleExceptions(NSException *exception) {
    NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
}
void SignalHandler(int sig) {
    NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}
#endif

#ifdef FLURRY
    void uncaughtExceptionHandler(NSException *exception) {
        [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
    }
#endif

@end