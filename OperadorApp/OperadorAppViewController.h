//
//  operadorAppGHViewController.h
//  operadorAppGH
//
//  Created by Jorge Maroto Garc√≠a on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Contador.h"
#import "SugerirResena.h"

#import "Agenda.h"

#import "ControladorWeb.h"
#import "EnviarMail.h"

#import "TAPublicidadView.h"

#define URL_TACTILAPP   @"http://tactilapp.com"
#define URL_CMT     @"http://www.cmt.es/estado-portabilidad-movil"
#define POST_URL @"http://www.cmt.es/pmovil/SelectOption.do"
#define CAPTCHA_URL @"http://www.cmt.es/pmovil/jcaptcha.jpg"


@interface OperadorAppViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic, retain) IBOutlet UIView *informacion;
@property (nonatomic, retain) IBOutlet UIView *paso1;
@property (nonatomic, retain) IBOutlet UIView *paso2;
@property (nonatomic, retain) IBOutlet UIView *paso3;

@property (nonatomic, retain) IBOutlet UITextField *TFtelefono;
@property (nonatomic, retain) IBOutlet UIImageView *captcha;
@property (nonatomic, retain) IBOutlet UITextField *codigoCaptcha;


-(IBAction)desplazarScroll:(id)sender;

-(void)hideKeyboard;
-(IBAction)ocultarTecladoYColocarScroll;

-(void)goToPage:(int)pagina;
-(IBAction)mostrarPantallaInformacion;
-(IBAction)paginaSiguiente:(id)sender;

-(void)enviarPeticionCompleta;

// Parafernalia de la pantalla de info
-(IBAction)cargarWeb:(id)sender;
-(IBAction)mandarMailAlSoporte;

// Navegación
-(BOOL)intentaIrAPagina:(int)pagina;

//Agenda
-(IBAction)cargarAgendaDeContactos;

//Llamar
-(IBAction)llamarAlTelefono;
@end