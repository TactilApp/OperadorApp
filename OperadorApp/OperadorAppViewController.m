//
//  operadorAppGHViewController.m
//  operadorAppGH
//
//  Created by Jorge Maroto García on 31/03/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OperadorAppViewController.h"

#import <MKStoreKit/MKStoreManager.h>
#import "UIColor+Hex.h"

#import "TOARequestKernel.h"
#import "TACompanyView.h"
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
    UIScrollView *_scroll;
    MBProgressHUD *HUD;
}

// Properties temporales (deberían manejarse únicamente cuando se vayan a crear)
@property (nonatomic, strong) EnviarMail *pantallaMail;
@property (nonatomic, strong) Agenda *agenda;
@property (nonatomic, strong) SugerirResena *sugerir;
@end

@implementation OperadorAppViewController

#pragma mark - View lifecycle
- (void)viewDidLoad{
    // Init the scroll
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    _scroll = [[UIScrollView alloc] initWithFrame:
               CGRectMake(scrollMarginX, headHeight,
                          320 - 2 * scrollMarginX, screenHeight - 20 - headHeight - 50)];
    _scroll.scrollEnabled = FALSE;
    _scroll.pagingEnabled = TRUE;
    _scroll.showsVerticalScrollIndicator = FALSE;
    [_scroll setContentSize:CGSizeMake(WIDTH(_scroll), HEIGHT(_scroll)*4)];
    [_scroll setContentOffset:CGPointMake(0, HEIGHT(_scroll))];    // (info = 0; first page = 1)
    [self.view addSubview:_scroll];
    
    // Add steps
    [self.paso1 setFrame:CGRectMake(0, HEIGHT(_scroll), WIDTH(_scroll), HEIGHT(_scroll))];
    [super viewDidLoad];

    [self.informacion setFrame:CGRectMake(0, 0, WIDTH(_scroll), HEIGHT(_scroll))];

    [self.paso2 setFrame:CGRectMake(0, HEIGHT(_scroll)*2, WIDTH(_scroll), HEIGHT(_scroll))];
    [self.paso3 setFrame:CGRectMake(0, HEIGHT(_scroll)*3, WIDTH(_scroll), HEIGHT(_scroll))];
    
    [_scroll addSubview:self.informacion];
    [_scroll addSubview:self.paso1];
    [_scroll addSubview:self.paso2];
    [_scroll addSubview:self.paso3];
    
    [[TOARequestKernel sharedRequestKernel] setCaptcha:self.captcha];
    [[TOARequestKernel sharedRequestKernel] reloadCaptcha];
    
    // Add ad view

    GADBannerView *_bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    CGFloat y = [TAHelper isIphone4] ? 480-20-50 : 568-20-50;
    _bannerView.frame = CGRectMake(0, y, 320, 50);
    
    _bannerView.adUnitID = OAadmobID;
    _bannerView.delegate = self;

    _bannerView.rootViewController = self;
    _bannerView.backgroundColor = [UIColor clearColor];
    
    [_bannerView loadRequest:[GADRequest request]];
    
    
    UIImageView *tactilapp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_tactilapp.png"]];
    tactilapp.frame = _bannerView.frame;
    [self.view addSubview:tactilapp];
    
    [self.view addSubview:_bannerView];

    // Add HUD to the screen
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
	HUD.delegate = self;
    
    
    if ([Contador primeraCarga]){
        NSString *title = [NSString
            stringWithFormat:NSLocalizedString(@"VC_PRIMERA_CARGA_TIT", nil), kVERSION];
        NSString *description = [NSString
            stringWithFormat:NSLocalizedString(@"VC_PRIMERA_CARGA_MSG", nil), kVERSION];
        
        [TAHelper mostrarAlertaConTitulo:title mensaje:description];
        
        [self intentaIrAPagina:scrINFO];
    }
}



- (IBAction)recargarCaptcha:(id)sender {
    [TAHelper registrarEvento:@"Recargar Captcha" parametros:@{@"Tipo" : @"Manual"}];
    self.codigoCaptcha.text = nil;
    [[TOARequestKernel sharedRequestKernel] reloadCaptcha];
}

- (void)enviarPeticionCompleta{
    [self ocultarTecladoYColocarScroll];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = NSLocalizedString(@"HUD_CARGANDO_TIT", nil);
	HUD.detailsLabelText = NSLocalizedString(@"HUD_CARGANDO_MSG", nil);
	HUD.square = NO;
    [HUD show:YES];

    [[TOARequestKernel sharedRequestKernel]
        doRequestForNumber:self.TFtelefono.text
        captcha:self.codigoCaptcha.text
        success:^(NSString *companyString, NSString *topColor, NSString *bottomColor) {
    
            [TAHelper registrarEvento:@"Recargar Captcha"
                           parametros:@{@"Tipo" : @"Automático"}];

            [HUD hide:YES];

            [self loadCompanyView:companyString
                         topColor:[UIColor colorWithHexString:topColor]
                      bottomColor:[UIColor colorWithHexString:bottomColor]];

            [self goToPage:scrRESULT];
            self.codigoCaptcha.text = nil;
           
            [[TOARequestKernel sharedRequestKernel] reloadCaptcha];
           
       } failure:^(NSError *error) {
           
            [TAHelper registrarEvento:@"Recargar Captcha"
                           parametros:@{@"Tipo" : @"Erróneo"}];
           
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"Error";
            HUD.detailsLabelText = error.localizedDescription;
            [HUD hide:YES afterDelay:1];
           
            [self performSelector:@selector(captchaBecomeFirstResponder)
                       withObject:nil afterDelay:1];

            self.codigoCaptcha.text = nil;
           
            [[TOARequestKernel sharedRequestKernel] reloadCaptcha];
          
       }];
}

-(void)captchaBecomeFirstResponder{
   [self.codigoCaptcha becomeFirstResponder];
}

-(void)loadCompanyView:(NSString *)companyString topColor:(UIColor*)topColor bottomColor:(UIColor*)bottomColor{
    [_companyView removeFromSuperview];
    _companyView = [[TACompanyView alloc] initWithFrame:CGRectMake(0, 110, 261, 50) topColor:topColor bottomColor:bottomColor text:companyString];
    
    [self.paso3 addSubview:_companyView];
}


-(IBAction)desplazarScroll:(UIButton *)sender{
    // En el iPhone 5 no es necesario mover el scroll, ya que nunca se tapan los campos.
    if ([TAHelper isIphone4]){
        // Cuando se muestra el teclado en el paso 1, el scroll se mueve para mostrar el botón superior.
        int newHeight = (sender.tag * HEIGHT(_scroll)) + 14;

        // En caso de estar en la pantalla del captcha, se mueve un poco más hacia arriba para mostrar correctamente el captcha en mitad de la pantalla.
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
            self.sugerir = [[SugerirResena alloc] init];
            [self.sugerir sugerir];
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
                HUD.detailsLabelText = NSLocalizedString(@"HUD_TELEFONO_INCORRECTO", nil);
                [HUD show:YES];
                [HUD hide:YES afterDelay:1];
                return FALSE;
            }
            
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
    self.agenda = [[Agenda alloc] init];
    self.agenda.viewController = self;
    [self.agenda mostrarAgenda];
}


#pragma mark - Llamar
-(IBAction)llamarAlTelefono{
    NSString *telefono = [NSString stringWithFormat:@"tel:%@", self.TFtelefono.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefono]];
}


#pragma mark - Parafernalia de la pantalla de info

-(IBAction)cargarWeb:(UIButton *)sender{
    ControladorWeb *webACargar = [[ControladorWeb alloc] initWithNibName:@"ControladorWeb" bundle:nil];
    if ([sender tag] == BOTON_WEB_CMT){
        webACargar.url = URL_CMT;
    }else if ([sender tag] == BOTON_WEB_TACTILAPP){
        webACargar.url = URL_TACTILAPP;        
    }else{
        return ;
    }
    [self presentModalViewController:webACargar animated:YES];
}

-(IBAction)mandarMailAlSoporte{
    self.pantallaMail = [EnviarMail mailASoporteConDelegado:self];
    [self.pantallaMail mostrarPanelDelEmail];
}


#pragma mark - Delegados de la publicidad
-(void)adViewDidReceiveAd:(GADBannerView *)banner{
    [TAHelper registrarEvento:@"Publicidad"
                   parametros:@{@"cargada" : @"si", @"clase" : [banner class]}];
}

-(void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [TAHelper registrarEvento:@"Publicidad"
                   parametros:@{@"cargada" : @"no"}];
    
    for (UIView *subview in banner.subviews)
        [subview removeFromSuperview];
}
@end