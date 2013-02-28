//
//  operadorAppGHViewController.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppViewController.h"

#import "UIColor+Hex.h"

#import "TAPublicidadView.h"
#import "TOARequestKernel.h"
#import "TACompanyView.h"
#import "UIImage+CropCaptcha.h"
#import "Contador.h"
#import "SugerirResena.h"
#import "Agenda.h"
#import "ControladorWeb.h"
#import "EnviarMail.h"


/*
   *************
   * CONSTANTS *
   *************
*/

// Screen tags
#define scrINFO         0
#define scrTELEPHONE    1
#define scrCAPTCHA      2
#define scrRESULT       3


// Layout constants
const float headHeight      = 58;
const float scrollMarginX   = 30;

// Info screen
#define BOTON_WEB_CMT       0
#define BOTON_SOPORTE       1
#define BOTON_WEB_TACTILAPP 2

// Misc constants
#define minPHONELength  9


@interface OperadorAppViewController (){
    TACompanyView *_companyView;
    TOARequestKernel *kernel;
    UIScrollView *_scroll;
    MBProgressHUD *HUD;
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
    // Init the scroll
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    _scroll = [[UIScrollView alloc] initWithFrame:
               CGRectMake(scrollMarginX, headHeight,
                          320 - 2 * scrollMarginX, screenHeight - 20 - headHeight - ADSHEIGHT)];
    _scroll.scrollEnabled = FALSE;
    _scroll.pagingEnabled = TRUE;
    _scroll.showsVerticalScrollIndicator = FALSE;
    [_scroll setContentSize:CGSizeMake(WIDTH(_scroll), HEIGHT(_scroll)*4)];
    [_scroll setContentOffset:CGPointMake(0, HEIGHT(_scroll))];    // (info = 0; first page = 1)
    [self.view addSubview:_scroll];
    
    // Add steps
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verCaptcha) name:TANOTIF_CAPTCHA_LOADED object:nil];
    kernel = [TOARequestKernel sharedRequestKernel];
    
    [self.paso1 setFrame:CGRectMake(0, HEIGHT(_scroll), WIDTH(_scroll), HEIGHT(_scroll))];
    [super viewDidLoad];

    [self.informacion setFrame:CGRectMake(0, 0, WIDTH(_scroll), HEIGHT(_scroll))];

    [self.paso2 setFrame:CGRectMake(0, HEIGHT(_scroll)*2, WIDTH(_scroll), HEIGHT(_scroll))];
    [self.paso3 setFrame:CGRectMake(0, HEIGHT(_scroll)*3, WIDTH(_scroll), HEIGHT(_scroll))];
    
    [_scroll addSubview:self.informacion];
    [_scroll addSubview:self.paso1];
    [_scroll addSubview:self.paso2];
    [_scroll addSubview:self.paso3];
    
    
    // Add ad view
    TAPublicidadView *publicidad = [[TAPublicidadView alloc] initWithFrame:CGRectMake(0, screenHeight - 20 - ADSHEIGHT, WIDTH(self.view), ADSHEIGHT)];
    publicidad.rootViewController = self;
    [publicidad loadAds];
    
    [self.view addSubview:publicidad];
    [publicidad release];


	if([MKStoreManager isFeaturePurchased:AGENDA_PRODUCT_ID]){
        publicidad.hidden = TRUE;
	}
    

    // Add HUD to the screen
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
    
    
    if ([Contador primeraCarga]){
    //  NSString *title = [NSString stringWithFormat:@"OperadorApp %@", kVERSION];
    //  NSString *description = [NSString stringWithFormat:@"Hola, bienvenido a OperadorApp %@. Ésta es la última versión de la aplicación compatible con iOS4, por lo que si tienes una versión anterior, aconsejamos actualizar tu dispositivo para poder seguir disfrutando de las mejoras de OperadorApp en futuras versiones.", kVERSION];
    //  [TAHelper mostrarAlertaConTitulo:title mensaje:description];
        [self intentaIrAPagina:scrINFO];
    }
}

- (IBAction)recargarCaptcha:(id)sender {
    #ifdef FLURRY
        NSDictionary *dictData = @{@"Tipo" : @"Manual"};
        [FlurryAnalytics logEvent:@"Recargar Captcha" withParameters:dictData];
    #endif

    self.codigoCaptcha.text = nil;
    [kernel reloadCaptcha];
}

-(void)verCaptcha{
    self.captcha.image = [kernel.recaptcha usefulRectangle];
}

- (void)enviarPeticionCompleta{
    [self ocultarTecladoYColocarScroll];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Cargando";
	HUD.detailsLabelText = @"Realizando consulta a la CMT";
	HUD.square = NO;
    [HUD show:YES];

    [kernel doRequestForNumber:self.TFtelefono.text captcha:self.codigoCaptcha.text
                       success:^(NSString *companyString) {
                           [HUD hide:YES];

                           [self loadCompanyView:companyString];
                           [self goToPage:scrRESULT];
                           self.codigoCaptcha.text = nil;
                           [kernel reloadCaptcha];
                            #ifdef FLURRY
                               NSDictionary *dictData = @{@"Tipo" : @"Automática"};
                               [FlurryAnalytics logEvent:@"Recargar Captcha" withParameters:dictData];
                            #endif

                       } failure:^(NSError *error) {
                           HUD.mode = MBProgressHUDModeText;
                           HUD.labelText = @"Error";
                           HUD.detailsLabelText = error.localizedDescription;
                           
                           [HUD hide:YES afterDelay:1];
                           [self performSelector:@selector(captchaBecomeFirstResponder) withObject:nil afterDelay:1];
                           
                           self.codigoCaptcha.text = nil;
                           [kernel reloadCaptcha];
                            #ifdef FLURRY
                               NSDictionary *dictData = @{@"Tipo" : @"Errónea"};
                               [FlurryAnalytics logEvent:@"Recargar Captcha" withParameters:dictData];
                            #endif
                       }];
}

-(void)captchaBecomeFirstResponder{
   [self.codigoCaptcha becomeFirstResponder];
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


-(IBAction)desplazarScroll:(UIButton *)sender{
    // On iPhone 5 isn't necessary to move the scroll because keyboard never hide the fields.
    if ([TAHelper isIphone4]){
        // When keyboard is showed in step 1, scroll is moved to up to show well top-button.
        int newHeight = (sender.tag * HEIGHT(_scroll)) + 14;
        
        // If is the captcha-screen, we move up a little bit for show correctly all the captcha (on this screen, keyboar cover the next-button but user can press on the background to hide it).
        if (sender.tag == scrCAPTCHA) newHeight += 62;
        
        [_scroll setContentOffset:CGPointMake(0, newHeight) animated:YES];
    }
}



#pragma mark - Controlador de navegacion
-(IBAction)mostrarPantallaInformacion{
    [self goToPage:scrINFO];
}

-(IBAction)paginaSiguiente:(UIButton *)sender{
    if (sender.tag == scrINFO)
        [self intentaIrAPagina:scrTELEPHONE];
    else if (sender.tag == scrTELEPHONE)
        [self intentaIrAPagina:scrCAPTCHA];
    else if (sender.tag == scrCAPTCHA)
        [self intentaIrAPagina:scrRESULT];
    else if (sender.tag == scrRESULT){
        self.TFtelefono.text = nil;
        if ([Contador sugerirResena]){
            SugerirResena *resena = [[SugerirResena alloc] init];
            [resena sugerir];
        }else
            [self intentaIrAPagina:scrTELEPHONE];
    }
}


/*
    Se intenta ir a la página indicada, comprobando los requisitos para llegar hasta ella.
    En caso de que deje ir a dicha página, devuelve TRUE. FALSE en el resto de casos. 
*/
-(BOOL)intentaIrAPagina:(int)pagina{
    switch (pagina) {
        case scrTELEPHONE:
            [self goToPage:scrTELEPHONE];
            break;
            
        case scrCAPTCHA:
            // Comprobar longitud del teléfono
            if ([self.TFtelefono.text length] != minPHONELength){
                HUD.mode = MBProgressHUDModeText;
                HUD.labelText = @"Error";
                HUD.detailsLabelText = @"El teléfono introducido no es válido";
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                return FALSE;
            }
            
            [kernel reloadCaptcha];
            self.codigoCaptcha.text = nil;
            
            [self goToPage:scrCAPTCHA];
            [self captchaBecomeFirstResponder];
            break;
            
        case scrRESULT:
            [self enviarPeticionCompleta];
            break;
            
        case scrINFO:
            [self goToPage:scrINFO];
            break;
    }    
    return TRUE;
}


/*
    Cambia el scroll a la página indicada.
 */
-(void)goToPage:(int)page{
    int newHeight = page * HEIGHT(_scroll);
    
    if (page == scrINFO || page == scrRESULT)
        [self hideKeyboard];
    
    [_scroll setContentOffset:CGPointMake(0, newHeight) animated:YES];
}



-(void)hideKeyboard{
    [self.TFtelefono resignFirstResponder];
    [self.codigoCaptcha resignFirstResponder];
    [self.TFtelefono resignFirstResponder];
}

-(IBAction)ocultarTecladoYColocarScroll{
    [self hideKeyboard];
    
    double currentPage = floor(_scroll.contentOffset.y / HEIGHT(_scroll));
    
    [self goToPage:(int)currentPage];
}


#pragma mark - Delegados para los UITextField
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField tag] == scrCAPTCHA) {
        [self intentaIrAPagina:scrRESULT];
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
    [webACargar release];
}

-(IBAction)mandarMailAlSoporte{
    EnviarMail *pantallaMail = [[EnviarMail alloc] init];

    [pantallaMail setDelegate:self];
    [pantallaMail setAsunto:[NSString stringWithFormat:@"[operadorApp iOS%@] Soporte", kVERSION]];
    [pantallaMail setMensaje:@"Hola,<br />quiero sugerir para operadorApp..."];

    [pantallaMail mostrarPanelDelEmail];
}
@end