//
//  Contador.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCARGAS @"cargas"
#define kACIERTOS @"aciertos"
#define SUGERIR 2

@interface Contador : NSObject {

}

+(BOOL)primeraCarga;
+(BOOL)sugerirResena;
@end