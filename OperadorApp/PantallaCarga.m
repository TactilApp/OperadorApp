//
//  PantallaCarga.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright 2011 http://blog.patoroco.net. All rights reserved.
//

#import "PantallaCarga.h"


@implementation PantallaCarga
@synthesize publicidad;

-(id)iniciarEnVista:(UIView *)vista{
    self = [super init];
    
    if (self){
        publicidad = nil;
        vistaContenedora = vista;
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.65;
    }
    
    return self;
}

-(void)show{
    [self removeFromSuperview];

    CGRect frameTmp = vistaContenedora.frame;
    frameTmp.origin = CGPointMake(0, 0);
    
    //En caso de que haya banner de publicidad asignado, se deja el hueco
    if (publicidad != nil)
        frameTmp.size = CGSizeMake(frameTmp.size.width, frameTmp.size.height - publicidad.frame.size.height);
    
    self.frame = frameTmp;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = self.center;
    [activityIndicator startAnimating];
    [self addSubview:activityIndicator];
    [activityIndicator release];
    
    [vistaContenedora addSubview:self];
}

-(void)hide{
    [self removeFromSuperview];
}

- (void)dealloc{
    [super dealloc];
}

@end

