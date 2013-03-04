//
//  Agenda.h
//  OperadorApp
//
//  Created by Jorge Maroto García on 05/05/11.
//  Copyright (c) 2012 TactilApp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>

#import "OperadorAppViewController.h"
@class OperadorAppViewController;


@interface Agenda : NSObject <ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>

    @property (nonatomic, weak) OperadorAppViewController *viewController;

    -(void)mostrarAgenda;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
