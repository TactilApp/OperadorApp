//
//  TAPublicidadView.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 15/04/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TAPublicidadView.h"

#import "OAprivate-configure.h"

#define kFRAMEBANNER    CGRectMake(0, 0, 320, 50)

@implementation TAPublicidadView
@synthesize rootViewController = _rootViewController;
@synthesize iAdBannerView, gAdBannerView;

-(id)initWithRootViewController:(UIViewController *)viewController{
    self = [super initWithFrame:CGRectMake(0, 410, 320, 50)];
    if (self){
        _rootViewController = viewController;
        [self cargarPublicidad];
    }
    return self;
}

-(void)cargarPublicidad{
    iAdBannerView = [[ADBannerView alloc] initWithFrame:kFRAMEBANNER];
    iAdBannerView.delegate = self;
    iAdBannerView.backgroundColor = [UIColor clearColor];
    [self showTopBanner:iAdBannerView];
    [self addSubview:iAdBannerView];
    [iAdBannerView release];
    
    gAdBannerView = [[GADBannerView alloc] initWithFrame:kFRAMEBANNER];
    gAdBannerView.adUnitID = OAadmobID;
    [self hideTopBanner:gAdBannerView];
    gAdBannerView.rootViewController = self.rootViewController;
    gAdBannerView.backgroundColor = [UIColor clearColor];
    [self addSubview:gAdBannerView];
    [gAdBannerView release];
}

#pragma mark - Delegados iAD
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self hideTopBanner:gAdBannerView];
    [self showTopBanner:banner];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [gAdBannerView loadRequest:[GADRequest request]];
    [self hideTopBanner:iAdBannerView];
    [self showTopBanner:gAdBannerView];
}

#pragma mark - Delegados AdMob
-(void)adViewDidReceiveAd:(GADBannerView *)banner{
    if ([iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
}
-(void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}

#pragma mark - Animaciones de los banners
- (void)hideTopBanner:(UIView *)banner{
    if (banner && ![banner isHidden]) {
        banner.hidden = YES;
    }
}

- (void)showTopBanner:(UIView *)banner{
    if (banner && [banner isHidden]) {
        banner.hidden = NO;
    }
}
@end