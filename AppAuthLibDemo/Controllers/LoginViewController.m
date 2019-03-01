//
//  LoginViewController.m
//  AppAuthLibDemo
//
//  Created by Hellen Soloviy on 3/1/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

#import "LoginViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

const NSString* segueIdentifier = @"loginCompleteSegue";

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    
}

#pragma mark - IBActions
- (IBAction)loginButtonAction:(UIButton *)sender {
    NSLog(@"loginButtonTapped");
    
    SVpro
}


@end
