//
//  Contador.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "Contador.h"
#import "OAprivate-configure.h"

@implementation Contador


+(BOOL)primeraCarga{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kCARGAS] == nil){
        [defaults setObject:[NSNumber numberWithInt:1] forKey:kCARGAS];
        return TRUE;
    }
    NSNumber *cargas = [NSNumber numberWithInt:([(NSNumber *)[defaults objectForKey:kCARGAS] intValue] + 1)];
    [defaults setObject:cargas forKey:kCARGAS];
    return FALSE;
}

+(BOOL)sugerirResena{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:kHARESENADO] != nil){
        return FALSE;
    }
    
    if ([defaults objectForKey:kACIERTOS] == nil){
        [defaults setObject:[NSNumber numberWithInt:0] forKey:kACIERTOS];
        return TRUE;
    }
    
    NSNumber *aciertos = [NSNumber numberWithInt:([(NSNumber *)[defaults objectForKey:kACIERTOS] intValue] + 1)];
    [defaults setObject:aciertos forKey:kACIERTOS];
    
    if (([(NSNumber *)[defaults objectForKey:kACIERTOS] intValue] % (SUGERIR + 1)) == 0)
        return TRUE;
    
    return FALSE;
}

@end
