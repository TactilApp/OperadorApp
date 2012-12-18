//
//  operadorAppGHViewController.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppViewController.h"
#import "TAParserOperadorApp.h"
#import "UIImage+CropCaptcha.h"
#import "TACompanyView.h"
#import "UIColor+Hex.h"

#import "TOARequestKernel.h"

#import "OAprivate-configure.h"


#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface OperadorAppViewController (){
    TACompanyView *_companyView;
    TOARequestKernel *kernel;
}
@end

@implementation OperadorAppViewController
- (void)dealloc{
    [_informacion release];
    [_paso1 release];
    [_paso2 release];
    [_paso3 release];
    
    [_scroll release];
    [_captcha release];
    
    [_companyView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [self.scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT*4)];
    [self.scroll setFrame:CGRectMake(30, 65, SCROLL_WIDTH, SCROLL_HEIGHT)];

    [self.paso1 setFrame:CGRectMake(0, SCROLL_HEIGHT, SCROLL_WIDTH, SCROLL_HEIGHT)];
    [super viewDidLoad];

    [self.informacion setFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];

    [self.paso2 setFrame:CGRectMake(0, SCROLL_HEIGHT*2, SCROLL_WIDTH, SCROLL_HEIGHT)];
    [self.paso3 setFrame:CGRectMake(0, SCROLL_HEIGHT*3, SCROLL_WIDTH, SCROLL_HEIGHT)];
    
    [self.scroll addSubview:self.informacion];
    [self.scroll addSubview:self.paso1];
    [self.scroll addSubview:self.paso2];
    [self.scroll addSubview:self.paso3];
    
    [self.scroll setContentOffset:CGPointMake(0, SCROLL_HEIGHT)];
    
    [self.view insertSubview:self.scroll atIndex:2];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verCaptcha) name:TANOTIF_CAPTCHA_LOADED object:nil];
    kernel = [TOARequestKernel sharedRequestKernel];

    #warning Cambiar este texto en futuras versiones
    if ([Contador primeraCarga]){
        [TAHelper mostrarAlertaConTitulo:[NSString stringWithFormat:@"OperadorApp %@", kVERSION] mensaje:[NSString stringWithFormat:@"Hola, bienvenido a OperadorApp %@. Ésta es la última versión de la aplicación compatible con iOS4, por lo que si tienes una versión anterior, aconsejamos actualizar tu dispositivo para poder seguir disfrutando de las mejoras de OperadorApp en futuras versiones.", kVERSION]];
        [self intentaIrAPagina:PANTALLA_INFORMACION];
    }
    
    TAPublicidadView *publicidad = [[TAPublicidadView alloc] initWithRootViewController:self];
    [self.view addSubview:publicidad];
    [publicidad release];

	if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        publicidad.hidden = TRUE;
	}
}

- (IBAction)recargarCaptcha:(id)sender {
    [kernel reloadCaptcha];
}

-(void)verCaptcha{
    self.captcha.image = [kernel.recaptcha usefulRectangle];
}

- (void)enviarPeticionCompleta{
    [kernel doRequestForNumber:self.TFtelefono.text captcha:self.codigoCaptcha.text
                       success:^(NSString *companyString) {
                           [self loadCompanyView:companyString];
                           [self irAPagina:PANTALLA_RESULTADOS];
                           self.codigoCaptcha.text = nil;
                           [kernel reloadCaptcha];
                       } failure:^(NSError *error) {
                           self.codigoCaptcha.text = nil;
                           [kernel reloadCaptcha];
                           [TAHelper mostrarAlertaConTitulo:@"FAIL!" mensaje:error.localizedDescription];
                           NSLog(@"%@", error.localizedFailureReason);
                       }];
}

-(void)loadCompanyView:(NSString *)companyString{
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"companies-color.plist"]];
    NSString *companyKey = @"Default";
    bool findFlag = false;
    
    for(NSString *key in plistData){
        NSArray *companyStrings = [[plistData objectForKey:key] objectForKey:@"strings"];
        for (NSString *companyTmp in companyStrings){
            if ([companyString isEqualToString:companyTmp]){
                companyKey = key;
                break;
            }
        }
        
        if (findFlag)
            break;
        else{
            #ifdef FLURRY
                 [FlurryAnalytics logEvent:@"New Company" withParameters:[NSDictionary dictionaryWithObject:companyString forKey:@"stringFromCMT"]];
            #endif
        }
    
    }
    
    UIColor *topColor = [UIColor colorWithHexString:[[plistData objectForKey:companyKey] objectForKey:@"top"]];
    UIColor *bottomColor = [UIColor colorWithHexString:[[plistData objectForKey:companyKey] objectForKey:@"bottom"]];
    if (findFlag)  companyKey = companyString;
    
    [_companyView removeFromSuperview];
    _companyView = [[TACompanyView alloc] initWithFrame:CGRectMake(0, 110, 261, 50) topColor:topColor bottomColor:bottomColor text:companyKey];
    [self.paso3 addSubview:_companyView];
    [_companyView release];
}


-(IBAction)desplazarScroll:(id)sender{
    if ([sender tag] == PANTALLA_TELEFONO){
        //Al sacar el teclado en el paso 1, se desplaza el scroll hacia arriba para ver bien el botón
        // 20 es el margen por encima del botón
        int nuevoHeigth = (PANTALLA_TELEFONO * SCROLL_HEIGHT) + 20;
        [self.scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
    }
    if ([sender tag] == PANTALLA_CAPTCHA){
        //Al sacar el teclado en el paso 2, se desplaza el scroll hacia arriba para ver bien el texto
        // 62 = 20 de margen + 42 que ocupa el botón
        int nuevoHeigth = (PANTALLA_CAPTCHA * SCROLL_HEIGHT) + 82;
        [self.scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
    }
}



#pragma mark - Controlador de navegacion
-(IBAction)mostrarPantallaInformacion{
    [self irAPagina:PANTALLA_INFORMACION];
}

-(IBAction)paginaSiguiente:(id)sender{
    if ([sender tag] == PANTALLA_INFORMACION)
        [self intentaIrAPagina:PANTALLA_TELEFONO];
    else if ([sender tag] == PANTALLA_TELEFONO)
        [self intentaIrAPagina:PANTALLA_CAPTCHA];
    else if ([sender tag] == PANTALLA_CAPTCHA)
        [self intentaIrAPagina:PANTALLA_RESULTADOS];
    else if ([sender tag] == PANTALLA_RESULTADOS){
        self.TFtelefono.text = nil;
        if ([Contador sugerirResena]){
            SugerirResena *resena = [[SugerirResena alloc] init];
            [resena sugerir];
        }else
            [self intentaIrAPagina:PANTALLA_TELEFONO];
    }
}


/*
    Se intenta ir a la página indicada, comprobando los requisitos para llegar hasta ella.
    En caso de que deje ir a dicha página, devuelve TRUE. FALSE en el resto de casos. 
*/
-(BOOL)intentaIrAPagina:(int)pagina{
    switch (pagina) {
        case PANTALLA_TELEFONO:
            [self irAPagina:PANTALLA_TELEFONO];
            break;
            
        case PANTALLA_CAPTCHA:
            // Comprobar longitud del teléfono
            if ([self.TFtelefono.text length] != LONGITUD_TELEFONO){
                [TAHelper mostrarAlertaConTitulo:@"Error" mensaje:@"El teléfono introducido no es válido"];
                return FALSE;
            }
            
            [kernel reloadCaptcha];
            self.codigoCaptcha.text = nil;
            
            [self irAPagina:PANTALLA_CAPTCHA];
            [self.codigoCaptcha becomeFirstResponder];
            [self.codigoCaptcha resignFirstResponder];
            [self.codigoCaptcha becomeFirstResponder];
            break;
            
        case PANTALLA_RESULTADOS:
            [self ocultarTecladoYColocarScroll];
            
            // Enviar la solicitud y esperar a la respuesta
            [self enviarPeticionCompleta];
            break;
            
        case PANTALLA_INFORMACION:
            [self irAPagina:PANTALLA_INFORMACION];
            break;
    }    
    return TRUE;
}


/*
    Cambia el scroll a la página indicada.
 */
-(void)irAPagina:(int)pagina{
    int nuevoHeigth = pagina * SCROLL_HEIGHT;
    [self ocultarTeclado];
    [self.scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
}



-(void)ocultarTeclado{
    [self.TFtelefono resignFirstResponder];
    [self.codigoCaptcha resignFirstResponder];
    [self.TFtelefono resignFirstResponder];
}

-(IBAction)ocultarTecladoYColocarScroll{
    [self ocultarTeclado];
    
    double paginaActual = floor(self.scroll.contentOffset.y / SCROLL_HEIGHT);
    [self irAPagina:(int)paginaActual];
}


#pragma mark - Delegados para los UITextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField tag] == PANTALLA_CAPTCHA) {
        [self intentaIrAPagina:PANTALLA_RESULTADOS];
    }
    return YES; 
}


#pragma - Agenda de contactos
-(IBAction)cargarAgendaDeContactos{
    Agenda *contactos = [[Agenda alloc] init];
    contactos.viewController = self;
    [contactos mostrarAgenda];
}


#pragma mark - Llamar
-(IBAction)llamarAlTelefono{
    NSString *telefono = [NSString stringWithFormat:@"tel:%@", self.TFtelefono.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefono]];
}


#pragma mark - Parafernalia de la pantalla de info

-(IBAction)cargarWeb:(id)sender{
    ControladorWeb *webACargar = [[ControladorWeb alloc] initWithNibName:@"ControladorWeb" bundle:nil];
    if ([sender tag] == BOTON_WEB_CMT){
        webACargar.url = URL_CMT;
    }else if ([sender tag] == BOTON_WEB_TACTILAPP){
        webACargar.url = URL_TACTILAPP;        
    }else{
        [webACargar release];
        return ;
    }
    [self presentModalViewController:webACargar animated:YES];
}

-(IBAction)mandarMailAlSoporte{
    EnviarMail *pantallaMail = [[EnviarMail alloc] init];

    [pantallaMail setDelegate:self];
    [pantallaMail setAsunto:[NSString stringWithFormat:@"[operadorApp iOS%@] Soporte", kVERSION]];
    [pantallaMail setMensaje:@"Hola,<br />quiero sugerir para operadorApp..."];

    [pantallaMail mostrarPanelDelEmail];
}


#pragma mark - Ciclo de vida

- (void)viewDidUnload{
    [super viewDidUnload];
}
@end