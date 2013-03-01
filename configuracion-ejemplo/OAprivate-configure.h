//
//  OAprivate-configure.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 17/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#error You must to change these fields.


// Identificadores de esta versión para controlar las reseñas
#define kHARESENADO @"identificadorDeHaberReseñado"
#define kVERSION    @"versionActualDeOperadorApp"

// Token de distintos servicios
#define OAadmobID       @"TokenDeAdMob"      // Admob
#define FLURRY_TOKEN    @"TokenDeFlurry" // Flurry analytics

#ifdef DEBUG
    #define kUrbanAirshipApplicationKey     @"APP_KEY_DEV"
    #define kUrbanAirshipApplicationSecret  @"APP_SEC_DEV"
#else
    #define kUrbanAirshipApplicationKey     @"APP_KEY_PRO"
    #define kUrbanAirshipApplicationSecret  @"APP_SEC_PRO"
#endif


// Información de soporte
#define MAIL_SOPORTE    @"soporte@mail.com"

// Identificadores de las in-app purchases
#define AGENDA_PRODUCT_ID       @"Identificador.In.App.Purchase"




//
//  OAprivate-configure.h
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 17/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//


// Identificadores de esta versión para controlar las reseñas
#define kHARESENADO @"resenaOkv16"
#define kVERSION    @"v1.6"

// Token de distintos servicios
#define OAadmobID           @"a14da3710222f9c"      // Admob
#define FLURRY_TOKEN        @"4U316P2A44NXGLERLVVR" // Flurry analytics
#define TESTFLIGHT_TOKEN    @"1f07d713009e4534bf4aaac6e9a95d78_NzMxOTQyMDEyLTA0LTExIDEzOjAwOjA3LjMzNjIxNw"  // TestFlight

#ifdef DEBUG
    #define kUrbanAirshipApplicationKey     @"8j-DR5piSQqF9RtTAhSP6g"
    #define kUrbanAirshipApplicationSecret  @"QPo68QJxSI6RYYdE5EMH0g"
#else
    #define kUrbanAirshipApplicationKey     @"pjewShcKSDyUEkQ17oKdmA"
    #define kUrbanAirshipApplicationSecret  @"lUIy3Xp8RzinZnuAXEiB3g"
#endif

// Información de soporte
#define MAIL_SOPORTE        @"support@tactilapp.com"

// Identificadores de las in-app purchases
#define AGENDA_PRODUCT_ID   @"com.tactilapp.operadorApp.contactos"