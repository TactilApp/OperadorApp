//
//  TAParserOperadorApp.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 14/04/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TAParserOperadorApp.h"
#import "Element.h"
#import "DocumentRoot.h"
@interface TAParserOperadorApp()
+(NSString *)limpiarCadena:(NSString *)cadena;
@end

@implementation TAParserOperadorApp
+(NSString *)parsearStringWebCMT:(NSString *)HTMLString{
    DocumentRoot* document = [Element parseHTML:HTMLString];
    if (document == nil)
        [NSException raise:keParseHTML format:@"Error al parsear el HTML"];
    
    //Comprobar que no existe ningún error
    NSArray *errores = [document selectElements:@"div#error .mensajes_error"];
    if (errores.count > 0){
        Element *elementError = [errores objectAtIndex:0];
        NSArray *erroresEnString = [[TAParserOperadorApp limpiarCadena:elementError.contentsText] componentsSeparatedByString:@"\n"];
        
        NSMutableString *stringDeError = [NSMutableString string];
        
        for (NSString *errorConcreto in erroresEnString)
            [stringDeError appendFormat:@"\n%@", errorConcreto];
        
        NSDictionary *dictData = [NSDictionary dictionaryWithObject:stringDeError forKey:@"Error"];
        [FlurryAnalytics logEvent:@"Errores Analisis" withParameters:dictData];

        
        [NSException raise:keCaptchaTelefono format:@"%@", stringDeError];
    }
    
    
    //TELEFONO Y CAPTCHA PARECEN CORRECTOS  
	NSArray *acierto = [document selectElements:@"div.formulario .textcontenido"];
    if (acierto.count == 0)
        [NSException raise:keCaptchaTelefono format:@"Error desconocido"];
    
    Element *elementAcierto = [acierto objectAtIndex:0];
    NSArray *lineasDeAcierto = [[TAParserOperadorApp limpiarCadena:elementAcierto.contentsText] componentsSeparatedByString:@"\n"];
    
    //El contenido del número se encuentra en la segunda posicion (index = 1). Quitamos los espacios.
    NSString *lineaOperador = [[lineasDeAcierto objectAtIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *bloquesOperador = [lineaOperador componentsSeparatedByString:@":"];
    
    NSString *operadorStr = [bloquesOperador objectAtIndex:1];
    
    NSDictionary *dictData = [NSDictionary dictionaryWithObject:operadorStr forKey:@"Compañía"];
    [FlurryAnalytics logEvent:@"OperadorApp Acierto" withParameters:dictData];
    
    return operadorStr;
}

+(NSString *)limpiarCadena:(NSString *)cadena{
    //Sustituir espacios en HTML por normales
    cadena = [cadena stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    //Sustituir dobles saltos de línea por normales (se podría sustituir por una expresión regular)
    for (int i = 0; i<5; i++) {
        cadena = [cadena stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    }
    
    return cadena;
}
@end
