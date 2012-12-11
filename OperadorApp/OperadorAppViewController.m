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
@synthesize scroll, informacion, paso1, paso2, paso3, captcha, codigoCaptcha, TFtelefono;

- (void)dealloc{
    [informacion release];
    [paso1 release];
    [paso2 release];
    [paso3 release];
    
    [scroll release];
    
    [captcha release];
    [pantallaCarga release];
    
    [_companyView release];
    [_imagenDelCaptcha release];
    [_campoCaptcha release];
    [_captchaCompleto release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [scroll setContentSize:CGSizeMake(SCROLL_WIDTH, SCROLL_HEIGHT*4)];
    [scroll setFrame:CGRectMake(30, 65, SCROLL_WIDTH, SCROLL_HEIGHT)];

    [informacion setFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
    [paso1 setFrame:CGRectMake(0, SCROLL_HEIGHT, SCROLL_WIDTH, SCROLL_HEIGHT)];
    [paso2 setFrame:CGRectMake(0, SCROLL_HEIGHT*2, SCROLL_WIDTH, SCROLL_HEIGHT)];
    [paso3 setFrame:CGRectMake(0, SCROLL_HEIGHT*3, SCROLL_WIDTH, SCROLL_HEIGHT)];
    
    [scroll addSubview:informacion];
    [scroll addSubview:paso1];
    [scroll addSubview:paso2];
    [scroll addSubview:paso3];
    
    [scroll setContentOffset:CGPointMake(0, SCROLL_HEIGHT)];
    
    [self.view insertSubview:scroll atIndex:2];

    [super viewDidLoad];
    
#warning TMP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verCaptcha) name:TANOTIF_CAPTCHA_LOADED object:nil];
    kernel = [TOARequestKernel new];
    [kernel reloadCaptcha];
    
    pantallaCarga = [[PantallaCarga alloc] iniciarEnVista:self.view];

    #warning Cambiar este texto en futuras versiones
    if ([Contador primeraCarga]){
        [self mostrarAlertaConTitulo:[NSString stringWithFormat:@"OperadorApp %@", kVERSION] mensaje:[NSString stringWithFormat:@"Hola, bienvenido a OperadorApp %@. Ésta es la última versión de la aplicación compatible con iOS4, por lo que si tienes una versión anterior, aconsejamos actualizar tu dispositivo para poder seguir disfrutando de las mejoras de OperadorApp en futuras versiones.", kVERSION]];
        [self intentaIrAPagina:PANTALLA_INFORMACION];
    }
    
    TAPublicidadView *publicidad = [[TAPublicidadView alloc] initWithRootViewController:self];
    [self.view addSubview:publicidad];
    [publicidad release];

	if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        publicidad.hidden = TRUE;
	}
}


-(void)verCaptcha{
    self.captchaCompleto.image = kernel.recaptcha;
    self.imagenDelCaptcha.image = [kernel.recaptcha usefulRectangle];
    [kernel reloadCaptcha];
}

-(void)cargarImagen{
    NSURL *url = [NSURL URLWithString:CAPTCHA_URL];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [request startSynchronous];
    
    if ([[request responseCookies] count] > 0){
        cookieSession = [[request responseCookies] objectAtIndex:0];
        
        [request setRequestCookies:[NSMutableArray arrayWithObject:cookieSession]];
    }
    [request startSynchronous];
    
    [captcha setImage:[[UIImage imageWithData:[request responseData]] usefulRectangle]];
    
    [request release];
}

- (IBAction)enviar:(id)sender {
    [kernel doRequestForNumber:self.TFtelefono.text captcha:self.campoCaptcha.text];
}

-(IBAction)desplazarScroll:(id)sender{
    if ([sender tag] == PANTALLA_TELEFONO){
        //Al sacar el teclado en el paso 1, se desplaza el scroll hacia arriba para ver bien el botón
        // 20 es el margen por encima del botón
        int nuevoHeigth = (PANTALLA_TELEFONO * SCROLL_HEIGHT) + 20;
        [scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
    }
    if ([sender tag] == PANTALLA_CAPTCHA){
        //Al sacar el teclado en el paso 2, se desplaza el scroll hacia arriba para ver bien el texto
        // 62 = 20 de margen + 42 que ocupa el botón
        int nuevoHeigth = (PANTALLA_CAPTCHA * SCROLL_HEIGHT) + 82;
        [scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
    }
}





#pragma mark - Peticiones y análisis de los resultados

-(void)hacerPeticionCompleta{
    NSURL *url = [NSURL URLWithString:POST_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestCookies:[NSMutableArray arrayWithObject:cookieSession]];
   
    [request setPostValue:TFtelefono.text forKey:@"tb_numMov"];
    [request setPostValue:[codigoCaptcha text] forKey:@"jcaptcha"];
    [request setPostValue:@"Buscar" forKey:@"Submit"];
    [request setPostValue:@"1" forKey:@"validar"];
    [request setPostValue:@"buscar" forKey:@"tipo"];
    [request setDelegate:self];
    [request startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request{
    //Comprueba los resultados de analizar la cadena de la web
    if ([[request.url absoluteString] isEqualToString:POST_URL]){
        if ([self analizarResultados:[request responseString]]){
            [self irAPagina:PANTALLA_RESULTADOS];
        }else{
            [self irAPagina:PANTALLA_TELEFONO];
            [codigoCaptcha setText:@""];
        }
        [pantallaCarga hide];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    [self mostrarAlertaConTitulo:@"Ha ocurrido un error" mensaje:[error description]];

    NSDictionary *dictData = [NSDictionary dictionaryWithObject:[error description] forKey:@"Error"];
    [FlurryAnalytics logEvent:@"Request Failed" withParameters:dictData];
    
    [pantallaCarga hide];
    [self irAPagina:PANTALLA_TELEFONO];
    [codigoCaptcha setText:@""];
}


-(BOOL)analizarResultados:(NSString *)cadena{
    @try {
        companiaActual = [TAParserOperadorApp parsearStringWebCMT:cadena];   
    }@catch (NSException *exception) {
        if ([exception.name isEqualToString:keCaptchaTelefono]){
            [self mostrarAlertaConTitulo:@"Error en datos" mensaje:exception.description];
        }else if([exception.name isEqualToString:keDesconocido]){
            [self mostrarAlertaConTitulo:@"Error desconocido" mensaje:@"Se ha producido un error desconocido."];
        }else if([exception.name isEqualToString:keParseHTML]){
            [self mostrarAlertaConTitulo:@"Error al parsear datos" mensaje:@"Se ha producido un error al parsear los datos recibidos."];
        }
        return FALSE;
    }@finally {
    }
    
    
    NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"companies-color.plist"]];
    NSString *companyKey = @"Default";
    bool findFlag = false;
    
    for(NSString *key in plistData){
        NSArray *companyStrings = [[plistData objectForKey:key] objectForKey:@"strings"];
        for (NSString *companyTmp in companyStrings){
            if ([companiaActual isEqualToString:companyTmp]){
                companyKey = key;
                break;
            }
        }

        if (findFlag)
            break;
        else
            [FlurryAnalytics logEvent:@"New Company" withParameters:[NSDictionary dictionaryWithObject:companiaActual forKey:@"stringFromCMT"]];
    }
    UIColor *topColor = [UIColor colorWithHexString:[[plistData objectForKey:companyKey] objectForKey:@"top"]];
    UIColor *bottomColor = [UIColor colorWithHexString:[[plistData objectForKey:companyKey] objectForKey:@"bottom"]];
    if (findFlag)  companyKey = companiaActual;
    
    [_companyView removeFromSuperview];
    _companyView = [[TACompanyView alloc] initWithFrame:CGRectMake(0, 110, 261, 50) topColor:topColor bottomColor:bottomColor text:companyKey];
    [self.paso3 addSubview:_companyView];
    [_companyView release];
    
    return TRUE;
}


-(void)mostrarAlertaConTitulo:(NSString *)titulo mensaje:(NSString *)mensaje{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
    [alerta show];
    [alerta release];
}

#pragma mark - Controlador de navegacion
-(IBAction)mostrarPantallaInformacion{
    [self irAPagina:PANTALLA_INFORMACION];
}

-(IBAction)paginaSiguiente:(id)sender{
    if ([sender tag] == PANTALLA_INFORMACION){
        [self intentaIrAPagina:PANTALLA_TELEFONO];
    } else if ([sender tag] == PANTALLA_TELEFONO){
        [self intentaIrAPagina:PANTALLA_CAPTCHA];
    } else if ([sender tag] == PANTALLA_CAPTCHA){
        [self intentaIrAPagina:PANTALLA_RESULTADOS];
    } else if ([sender tag] == PANTALLA_RESULTADOS){
        [TFtelefono setText:@""];
        if ([Contador sugerirResena]){
            SugerirResena *resena = [[SugerirResena alloc] init];
            [resena sugerir];
        }else{
            [self intentaIrAPagina:PANTALLA_TELEFONO];
        }
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
            if ([TFtelefono.text length] != LONGITUD_TELEFONO){
                [self mostrarAlertaConTitulo:@"Error" mensaje:@"El teléfono introducido no es válido"];
                return FALSE;
            }

            [self cargarImagen];
            [codigoCaptcha setText:@""];
            
            [self irAPagina:PANTALLA_CAPTCHA];
            [codigoCaptcha becomeFirstResponder];
            [codigoCaptcha resignFirstResponder];
            [codigoCaptcha becomeFirstResponder];
            break;
            
        case PANTALLA_RESULTADOS:
            [pantallaCarga show];
            [self ocultarTecladoYColocarScroll];
            
            // Enviar la solicitud y esperar a la respuesta
            [self hacerPeticionCompleta];            
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
    [scroll setContentOffset:CGPointMake(0, nuevoHeigth) animated:YES];
}



-(void)ocultarTeclado{
    [TFtelefono resignFirstResponder];
    [codigoCaptcha resignFirstResponder];
    [TFtelefono resignFirstResponder];
}

-(IBAction)ocultarTecladoYColocarScroll{
    [self ocultarTeclado];
    
    double paginaActual = floor(scroll.contentOffset.y / SCROLL_HEIGHT);
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
    NSString *telefono = [NSString stringWithFormat:@"tel:%@", TFtelefono.text];
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
    [self setImagenDelCaptcha:nil];
    [self setCampoCaptcha:nil];
    [self setCaptchaCompleto:nil];
    [super viewDidUnload];
}
@end