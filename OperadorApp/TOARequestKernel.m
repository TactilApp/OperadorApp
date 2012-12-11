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


@interface TOARequestKernel()
    @property (nonatomic, retain) NSString *codigoJS;
@end

@implementation TOARequestKernel
-(void)reloadCaptcha{
    // Cargamos la imagen a partir del JS de Google
    AFHTTPRequestOperation *javascriptOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithString:recaptcha_js_base_URL]];
    [javascriptOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *strSource = [operation.responseString stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSError *errRegex = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:@"challenge:'([A-Z0-9a-z._%+-]*)'"
                                      options:NSRegularExpressionAllowCommentsAndWhitespace |  NSRegularExpressionUseUnixLineSeparators
                                      error:&errRegex];
        
        NSArray *coincidencias = [regex matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
        if (errRegex) {
            NSLog(@"Error regex: %@", errRegex);
        }
        
        if (coincidencias.count > 0){
            NSTextCheckingResult *resultado = (NSTextCheckingResult *)coincidencias[0];
            self.codigoJS = [strSource substringWithRange:[resultado rangeAtIndex:1]];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:TANOTIF_CAPTCHA_ERROR_LOAD object:nil];
            return ;
        }
        
        NSString *recaptcha_full_URL = [NSString stringWithFormat:@"%@%@", recaptcha_image_base_URL, self.codigoJS];
        
        AFHTTPRequestOperation *imagenRecaptcha = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithString:recaptcha_full_URL]];
        [imagenRecaptcha setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.recaptcha = [UIImage imageWithData:responseObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:TANOTIF_CAPTCHA_LOADED object:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Se ha liado parda con el captcha: %@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:TANOTIF_CAPTCHA_ERROR_LOAD object:nil];
            return ;
        }];
        [imagenRecaptcha start];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:TANOTIF_CAPTCHA_ERROR_LOAD object:nil];
        return ;
    }];
    [javascriptOperation start];
}



-(void)doRequestForNumber:(NSString *)mobileNumber captcha:(NSString *)captchaStr{
    /**
         tb_numMov : <telefono>
         recaptcha_challenge_field: <codigo>
         recaptcha_response_field: <valor_del_captcha>
         submit : Buscar
         validar : 1
         tipo : buscar
     */
    
    NSURL *url = [NSURL URLWithString:@"http://www.cmt.es"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *params = @{@"tb_numMov" : mobileNumber, @"recaptcha_challenge_field" : self.codigoJS, @"recaptcha_response_field" : captchaStr, @"submit" : @"Buscar", @"validar" : @1, @"tipo" : @"buscar"};
    
    NSLog(@"Enviando: \n%@", params);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/pmovil/SelectOption.do" parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"OK: \n%@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL! %@", error.description);
    }];
    [operation start];
}
@end