//
//  ControladorWeb.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControladorWeb : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIWebView *web;
@property (nonatomic, strong) NSString *url;

-(IBAction)volver;
@end
