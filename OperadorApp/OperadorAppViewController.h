//
//  operadorAppGHViewController.h
//  operadorAppGH
//
//  Created by Jorge Maroto Garc√≠a on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Admob/GADBannerView.h>

#import "MBProgressHUD.h"

#define URL_TACTILAPP   @"http://tactilapp.com"
#define URL_CMT     @"http://www.cmt.es/estado-portabilidad-movil"

@interface OperadorAppViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, GADBannerViewDelegate>
@property (nonatomic, strong) IBOutlet UIView *informacion;
@property (nonatomic, strong) IBOutlet UIView *paso1;
@property (nonatomic, strong) IBOutlet UIView *paso2;
@property (nonatomic, strong) IBOutlet UIView *paso3;

@property (nonatomic, strong) IBOutlet UITextField *TFtelefono;
@property (nonatomic, strong) IBOutlet UIImageView *captcha;
@property (nonatomic, strong) IBOutlet UITextField *codigoCaptcha;


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