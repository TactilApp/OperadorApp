//
//  TAPublicidadView.m
//  OperadorApp
//
//  Created by Jorge Maroto García on 15/04/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import "TAPublicidadView.h"

@implementation TAPublicidadView
-(void)loadAds{
    CGRect frameBanner = CGRectMake(0, 0, WIDTH(self), HEIGHT(self));
    self.iAdBannerView = [[[ADBannerView alloc] initWithFrame:frameBanner] autorelease];
    self.iAdBannerView.delegate = self;
    self.iAdBannerView.backgroundColor = [UIColor clearColor];
    [self showTopBanner:self.iAdBannerView];
    [self addSubview:self.iAdBannerView];
    
//    self.gAdBannerView = [[[GADBannerView alloc] initWithFrame:frameBanner] autorelease];
//    self.gAdBannerView.adUnitID = OAadmobID;
//    [self hideTopBanner:self.gAdBannerView];
//    self.gAdBannerView.rootViewController = self.rootViewController;
//    self.gAdBannerView.backgroundColor = [UIColor clearColor];
//    [self addSubview:self.gAdBannerView];
}

#pragma mark - Delegados iAD
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
//    [self hideTopBanner:self.gAdBannerView];
    [self showTopBanner:banner];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
//    [self.gAdBannerView loadRequest:[GADRequest request]];
    [self hideTopBanner:self.iAdBannerView];
//    [self showTopBanner:self.gAdBannerView];
}

#pragma mark - Delegados AdMob
/*
 -(void)adViewDidReceiveAd:(GADBannerView *)banner{
    if ([self.iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
}
-(void)adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}
*/

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