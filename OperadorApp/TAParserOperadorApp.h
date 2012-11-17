//
//  TAParserOperadorApp.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 14/04/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define keParseHTML         @"errorParseHTML"
#define keCaptchaTelefono   @"errorCaptchaTelefono"
#define keDesconocido       @"errorDesconocido"

@interface TAParserOperadorApp : NSObject
    +(NSString *)parsearStringWebCMT:(NSString *)stringCMT;
@end