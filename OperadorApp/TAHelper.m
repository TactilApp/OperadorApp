//
//  TAHelper.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 18/12/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TAHelper.h"

@implementation TAHelper
+(BOOL)isIphone4{
    return !([UIScreen mainScreen].bounds.size.height == 568);
}

+(void)mostrarAlertaConTitulo:(NSString *)titulo mensaje:(NSString *)mensaje{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alerta show];
}
@end
