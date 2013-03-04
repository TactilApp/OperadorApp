//
//  OperadorAppAppDelegate.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 27/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppDelegate.h"

#import <AFUrbanAirshipClient/AFUrbanAirshipClient.h>
#import <MKStoreKit/MKStoreManager.h>
#import "OperadorAppViewController.h"
@implementation OperadorAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    #ifdef FLURRY
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
        [Flurry startSession:FLURRY_TOKEN];
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
    
    // Inicializar MKStoreKit
    [MKStoreManager sharedManager];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [OperadorAppViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    AFUrbanAirshipClient *client = [[AFUrbanAirshipClient alloc]
                                    initWithApplicationKey:kUrbanAirshipApplicationKey
                                    applicationSecret:kUrbanAirshipApplicationSecret];
    
    [client registerDeviceToken:deviceToken withAlias:nil success:^{
        NSLog(@"Success");
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
        [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
    }
#endif

@end