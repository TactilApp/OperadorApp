//
//  operadorAppGHViewController.h
//  operadorAppGH
//
//  Created by Jorge Maroto Garc√≠a on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "Contador.h"
#import "SugerirResena.h"

#import "Agenda.h"

#import "PantallaCarga.h"
#import "ControladorWeb.h"
#import "EnviarMail.h"

#import "TAPublicidadView.h"

#define URL_TACTILAPP   @"http://tactilapp.com"
#define URL_CMT     @"http://www.cmt.es/estado-portabilidad-movil"
#define POST_URL @"http://www.cmt.es/pmovil/SelectOption.do"
#define CAPTCHA_URL @"http://www.cmt.es/pmovil/jcaptcha.jpg"


#define SCROLL_HEIGHT   347
#define SCROLL_WIDTH    260

#define PANTALLA_INFORMACION    0
#define PANTALLA_TELEFONO       1
#define PANTALLA_CAPTCHA        2
#define PANTALLA_RESULTADOS     3

#define ALERTA_NUMERO_SIN_IMAGEN    56

//  Constantes sobre el tamaño de los strings que se están solicitando
#define LONGITUD_TELEFONO   9

#define BOTON_WEB_CMT       0
#define BOTON_SOPORTE       1
#define BOTON_WEB_TACTILAPP 2


@interface OperadorAppViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSHTTPCookie *cookieSession;
        
    UIScrollView *scroll;
    
    UIView *informacion;
    UIView *paso1;
    UIView *paso2;
    UIView *paso3;
    
    UIImageView *captcha;
    UITextField *codigoCaptcha;
    
    UITextField *TFtelefono;
    
    NSString *companiaActual;
    
    PantallaCarga *pantallaCarga;
}
@property (retain, nonatomic) IBOutlet UIImageView *imagenDelCaptcha;

@property (nonatomic, retain) IBOutlet UIImageView *captcha;

@property (nonatomic, retain) IBOutlet UIScrollView *scroll;

@property (nonatomic, retain) IBOutlet UIView *informacion;
@property (nonatomic, retain) IBOutlet UIView *paso1;
@property (nonatomic, retain) IBOutlet UIView *paso2;
@property (nonatomic, retain) IBOutlet UIView *paso3;

@property (nonatomic, retain) IBOutlet UITextField *codigoCaptcha;
@property (nonatomic, retain) IBOutlet UITextField *TFtelefono;


-(IBAction)desplazarScroll:(id)sender;

-(void)ocultarTeclado;
-(IBAction)ocultarTecladoYColocarScroll;

-(void)irAPagina:(int)pagina;
-(IBAction)mostrarPantallaInformacion;
-(IBAction)paginaSiguiente:(id)sender;

-(BOOL)analizarResultados:(NSString *)cadena;

-(void)cargarImagen;
-(void)mostrarAlertaConTitulo:(NSString *)titulo mensaje:(NSString *)mensaje;

-(void)hacerPeticionCompleta;



    
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