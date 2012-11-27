//
//  TOARequestKernel.m
//  operadorApp
//
//  Created by Jorge Maroto Garcia on 22/11/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TOARequestKernel.h"

#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

NSString * const cmt_iframe_URL              = @"http://www.cmt.es/pmovil/SelectOption.do";
NSString * const recaptcha_js_base_URL       = @"http://api.recaptcha.net/challenge?k=6LfgLNkSAAAAAMp-P85nbmpfAiIS6xDwWwYZSsux";
NSString * const recaptcha_image_base_URL    = @"http://www.google.com/recaptcha/api/image?c=";

@interface NSURLRequest(Helpers)

@end

@implementation NSURLRequest(Helpers)
+(NSURLRequest *)requestWithString:(NSString *)url_string{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
}
@end


@implementation TOARequestKernel
-(void)doRequestWithCaptcha:(UIImageView *)captchaImgView{
    // Obtenemos el cookie en la web de la CMT
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithString:cmt_iframe_URL]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {}
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Error WEB CMT: %@", error);
                                     }
    ];
    [operation start];

    
    // Cargamos la imagen a partir del JS de Google
    AFHTTPRequestOperation *javascriptOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithString:recaptcha_js_base_URL]];
    [javascriptOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strSource = operation.responseString;
        NSError *errRegex = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"challenge:'([A-Z0-9a-z._%+-]*)'"
                                      options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAllowCommentsAndWhitespace
                                      error:&errRegex];
        
        NSArray *coincidencias = [regex matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
        if (errRegex) {
            NSLog(@"%@", errRegex);
        }
        
        NSString *challenge = nil;
        if (coincidencias.count > 0){
            NSTextCheckingResult *resultado = (NSTextCheckingResult *)coincidencias[0];
            challenge = [[strSource substringWithRange:[resultado rangeAtIndex:1]] retain];
        }
        
        NSString *recaptcha_full_URL = [NSString stringWithFormat:@"%@%@", recaptcha_image_base_URL, challenge];
        
        AFHTTPRequestOperation *imagenRecaptcha = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithString:recaptcha_full_URL]];
        [imagenRecaptcha setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.recaptcha = [UIImage imageWithData:responseObject];
            captchaImgView.image = self.recaptcha;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [imagenRecaptcha start];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [javascriptOperation start];
}
@end