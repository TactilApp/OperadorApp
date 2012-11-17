//
//  TAPublicidadView.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 15/04/12.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GADBannerView.h"
#import <iAd/iAd.h>

@interface TAPublicidadView : UIView<ADBannerViewDelegate, GADBannerViewDelegate>{
    UIViewController *_rootViewController;
    ADBannerView *iAdBannerView;
    GADBannerView *gAdBannerView;
}
@property (nonatomic, assign) UIViewController *rootViewController;

@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

-(id)initWithRootViewController:(UIViewController *)viewController;
@end