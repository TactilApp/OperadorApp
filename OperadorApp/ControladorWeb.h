//
//  ControladorWeb.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ControladorWeb : UIViewController {
    UIWebView *web;
    NSString *url;
}

@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) IBOutlet NSString *url;

-(IBAction)volver;
@end
