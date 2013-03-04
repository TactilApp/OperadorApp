//
//  TAHelper.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 18/12/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define X(element) element.frame.origin.x
#define Y(element) element.frame.origin.y
#define WIDTH(element) element.frame.size.width
#define HEIGHT(element) element.frame.size.height

@interface TAHelper : NSObject
    +(BOOL)isIphone4;
    +(void)mostrarAlertaConTitulo:(NSString *)titulo mensaje:(NSString *)mensaje;

// FLURRY
    +(void)registrarEvento:(NSString *)nombre;
    +(void)registrarEvento:(NSString *)nombre parametros:(NSDictionary *)dict;
@end