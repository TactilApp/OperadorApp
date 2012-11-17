//
//  SugerirResena.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TITULO  @"Haz una reseña"
#define MENSAJE @"Si OperadorApp te ha resultado útil nos gustaría que dejases una reseña en la AppStore. Cada versión de la aplicación es independiente, por lo que aunque lo hicieses en el pasado, agradeceríamos que opinases también sobre esta versión.\n Si lo deseas, también puedes enviarnos tus sugerencias por mail pulsando en el logo de la aplicación."
#define NEGATIVO @"Ahora no"
#define POSITIVO @"Reseñar"

@interface SugerirResena : NSObject<UIAlertViewDelegate> {
    
}

-(void)sugerir;
@end
