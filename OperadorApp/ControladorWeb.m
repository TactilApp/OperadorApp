//
//  ControladorWeb.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "ControladorWeb.h"


@implementation ControladorWeb
@synthesize web, url;

- (void)dealloc{
    [web release];
    [url release];

    [super dealloc];
}

- (void)viewDidLoad{
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [super viewDidLoad];
}

-(IBAction)volver{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
