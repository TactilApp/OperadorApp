//
//  UIImage+CropCaptcha.m
//  operadorApp
//
//  Created by Jorge Maroto on 16/09/2012.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "UIImage+CropCaptcha.h"

@implementation UIImage (CropCaptcha)
-(UIImage *)usefulRectangle{
    CGImageRef image = self.CGImage;
    NSUInteger width = CGImageGetWidth(image);
    NSUInteger height = CGImageGetHeight(image);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    int x_min, x_max, y_min, y_max;
    x_min = y_min = INT_MAX;
    x_max = y_max = 0;
    for (int x = 0; x < CGImageGetWidth(image); x++){
        for (int y = 0; y < CGImageGetHeight(image); y++){
            int byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
            CGFloat red = rawData[byteIndex];
            CGFloat green = rawData[byteIndex + 1];
            CGFloat blue = rawData[byteIndex + 2];
            
            CGFloat sumRGBA = red + green + blue;
            if (sumRGBA < 725){    // (255 * 3) * 0.95 of accuracy
                if (x < x_min)  x_min = x;
                if (x > x_max)  x_max = x;
                if (y < y_min)  y_min = y;
                if (y > y_max)  y_max = y;
            }
        }
    }
    
    CGRect rectToCrop = CGRectMake(x_min, y_min, (x_max - x_min)+1, (y_max - y_min)+1);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image, rectToCrop);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    free(rawData);
    return result;
}
@end