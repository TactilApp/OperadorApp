//
//  ControladorWeb.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControladorWeb : UIViewController<UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UIWebView *web;
@property (nonatomic, retain) NSString *url;

-(IBAction)volver;
@end
