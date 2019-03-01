//
//  LoginViewController.m
//  AppAuthLibDemo
//
//  Created by Hellen Soloviy on 3/1/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

#import "LoginViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Constants.h"
#import "RequestsService.h"

static NSString* const loginCompleteSegueIdentifier = @"loginCompleteSegue";

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector: @selector(handleRequestsDidFail:) name: RequestsServiceAutorizationDidFailNotification object: nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector: @selector(handleRequestsDidEnd:) name: RequestsServiceAutorizationDidEndNotification object: nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [NSNotificationCenter.defaultCenter removeObserver: self];
}

#pragma mark - Notifications
- (void) handleRequestsDidFail:(NSNotification *) notification {
    NSLog(@"handleRequestsDidFail");
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus: @"Authorization Did Fail :("];
    });
}

- (void) handleRequestsDidEnd:(NSNotification *) notification {
    NSLog(@"handleRequestsDidEnd");

    BOOL isSuccess = ((NSNumber *)notification.object).boolValue;
    if (isSuccess) {
        NSLog(@"handleRequestsDidEnd - Success");
        [self.navigationController performSegueWithIdentifier: loginCompleteSegueIdentifier sender: nil];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showErrorWithStatus: @"Authorization Did Fail :("];
        });
        NSLog(@"handleRequestsDidEnd - Fail");
    }
    
}

#pragma mark - IBActions
- (IBAction)loginButtonAction:(UIButton *)sender {
    NSLog(@"loginButtonTapped");
    [[RequestsService new] performAuthFlowOnViewController: self];

}


@end
