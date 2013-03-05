//
//  ControladorWeb.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "ControladorWeb.h"


@implementation ControladorWeb
-(IBAction)volver{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (void)viewDidUnload {
    self.activity = nil;
    self.web = nil;
    [super viewDidUnload];
}

#pragma mark - WebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [self.activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.activity stopAnimating];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [TAHelper mostrarAlertaConTitulo:@"Error" mensaje:error.localizedDescription];
    [self.activity stopAnimating];
}
@end