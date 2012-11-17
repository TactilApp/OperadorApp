//
//  PantallaCarga.h
//  operadorAppGH
//
//  Created by Jorge Maroto García on 10/04/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PantallaCarga : UIView {
    UIView *vistaContenedora;
    UIView *publicidad;

}

@property (nonatomic, assign) UIView *publicidad;

-(id)iniciarEnVista:(UIView *)vista;
-(void)show;
-(void)hide;

@end
