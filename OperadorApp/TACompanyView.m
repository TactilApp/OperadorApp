//
//  TACompanyView.m
//  operadorApp
//
//  Created by Jorge Maroto García on 10/10/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TACompanyView.h"

#define MAXIMUM_FONT_SIZE   30
#define MINIMUM_FONT_SIZE   15
#define COLOR_TEXT          [UIColor whiteColor]

@implementation TACompanyView

-(id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (!self)  return nil;
    
    self.topColor = topColor;
    self.bottomColor = bottomColor;
    self.text = text;
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    float rWIDTH = rect.size.width;
    float rHEIGHT = rect.size.height;
    
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Middle top
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, 0);                  // Top left
    CGContextAddLineToPoint(ctx, rWIDTH, 0);          // Top rigth
    CGContextAddLineToPoint(ctx, rWIDTH, rHEIGHT/2);  // Middle rigth
    CGContextAddLineToPoint(ctx, 0, rHEIGHT/2);       // Middle left
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.topColor.CGColor);
    CGContextFillPath(ctx);
    
    // Middle bottom
    CGContextMoveToPoint(ctx, 0, rHEIGHT/2);          // Middle left
    CGContextAddLineToPoint(ctx, rWIDTH, rHEIGHT/2);  // Middle rigth
    CGContextAddLineToPoint(ctx, rWIDTH, rHEIGHT);    // Bottom rigth
    CGContextAddLineToPoint(ctx, 0, rHEIGHT);         // Bottom left
    CGContextClosePath(ctx);
    CGContextSetFillColorWithColor(ctx, self.bottomColor.CGColor);
    CGContextFillPath(ctx);
    
    //  Ensure that text fit on the view
    int sizeFont = MAXIMUM_FONT_SIZE;
    UIFont *font = [UIFont systemFontOfSize:sizeFont];
    while ([self.text sizeWithFont:font].width >= rWIDTH & sizeFont > MINIMUM_FONT_SIZE) {
        sizeFont--;
        font = [UIFont systemFontOfSize:sizeFont];
    }
    
    CGSize final_size = [self.text sizeWithFont:font constrainedToSize:rect.size lineBreakMode:UILineBreakModeWordWrap];
    CGRect final_rect = CGRectMake((rWIDTH-final_size.width)/2, (rHEIGHT-final_size.height)/2, final_size.width, final_size.height);
    CGContextSetShadow(ctx, CGSizeMake(1, 1), 1);
    [COLOR_TEXT set];
    [self.text drawInRect:final_rect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
}

-(void)dealloc{
    [_topColor release];
    [_bottomColor release];
    [_text release];
    [super dealloc];
}

@end
