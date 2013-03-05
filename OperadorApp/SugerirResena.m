//
//  SugerirResena.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "SugerirResena.h"

@implementation SugerirResena

-(void)sugerir{
    [TAHelper registrarEvento:@"Sugiere reseña"];
    
    UIAlertView *alerta = [[UIAlertView alloc]
                       initWithTitle:NSLocalizedString(@"RESENA_TIT", nil)
                       message:NSLocalizedString(@"RESENA_MSG", nil)
                       delegate:self
                       cancelButtonTitle:NSLocalizedString(@"BTN_CANCELAR", nil)
                       otherButtonTitles:NSLocalizedString(@"BTN_ACEPTAR", nil), nil];
    [alerta show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        [TAHelper registrarEvento:@"Reseña efectuada"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"SI" forKey:kHARESENADO];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=431750600"]];
    }
}
@end