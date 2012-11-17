//
//  TACompanyView.h
//  operadorApp
//
//  Created by Jorge Maroto García on 10/10/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TACompanyView : UIView
@property (nonatomic, retain) UIColor *topColor;
@property (nonatomic, retain) UIColor *bottomColor;
@property (nonatomic, retain) NSString *text;

-(id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor text:(NSString *)text;
@end