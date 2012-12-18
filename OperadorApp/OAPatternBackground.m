//
//  OAPatternBackground.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 18/12/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "OAPatternBackground.h"

@implementation OAPatternBackground

- (void)drawRect:(CGRect)rect{
    UIColor *tileColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_bgglobal.png"]];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGColorRef tileCGColor = [tileColor CGColor];
    CGColorSpaceRef colorSpace = CGColorGetColorSpace(tileCGColor);
    CGContextSetFillColorSpace(ctx, colorSpace);
    
    if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelPattern){
        CGFloat alpha = 1.0f;
        CGContextSetFillPattern(ctx, CGColorGetPattern(tileCGColor), &alpha);
    }else{
        CGContextSetFillColor(ctx, CGColorGetComponents(tileCGColor));
    }
    
    CGContextFillRect(ctx, rect);
}

@end
