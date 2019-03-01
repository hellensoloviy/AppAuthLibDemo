//
//  RequestsService.m
//  AppAuthLibDemo
//
//  Created by Hellen Soloviy on 3/1/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

#import <AppAuth/AppAuth.h>
#import "RequestsService.h"
#import "AppDelegate.h"
#import "Constants.h"

static NSString * const kClientID = @"3e1745f6-e090-49c0-ba86-a4053506c686";
static NSString * const KRedirectURI = @"https://login.microsoftonline.com/halsdev.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_SignUpInAPI";

@interface RequestsService()

// property of the containing class
@property (nonatomic, strong, nullable) OIDAuthState *authState;

@property (nonatomic, nullable) UIViewController *viewControllerToPresentOn;

@end

@implementation RequestsService

- (void) performAuthFlowOnViewController: (UIViewController *) viewControllerToPresentOn {
    self.viewControllerToPresentOn = viewControllerToPresentOn;
    NSURL *discoveryURL = [[NSURL alloc] initWithString: @"https://login.microsoftonline.com/halsdev.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_SignUpInAPI"];
    
    [OIDAuthorizationService discoverServiceConfigurationForDiscoveryURL: discoveryURL completion:^(OIDServiceConfiguration * _Nullable configuration, NSError * _Nullable error) {
        if (configuration != nil) {
            [self buildAndPerformAuthorizationRequestWithConfiguration: configuration];
        } else {
            [NSNotificationCenter.defaultCenter postNotificationName: RequestsServiceAutorizationDidFailNotification object: nil];
        }
    }];
    
}

- (void) buildAndPerformAuthorizationRequestWithConfiguration: (OIDServiceConfiguration *) configuration {
    NSURL* redirectURL = [[NSURL alloc] initWithString: @"authapplibdemo.app://oauth/redirect"];
    
    // builds authentication request
    OIDAuthorizationRequest *request =
    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                  clientId: kClientID
                                                    scopes:@[OIDScopeOpenID,
                                                             OIDScopeProfile]
                                               redirectURL: redirectURL
                                              responseType: OIDResponseTypeCode
                                      additionalParameters: @{@"p": @"B2C_1_SignUpInAPI"}];
    
    // performs authentication request
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                   presentingViewController: self.viewControllerToPresentOn
                                                   callback:^(OIDAuthState *_Nullable authState,
                                                              NSError *_Nullable error) {
                                                       if (authState) {
                                                           NSLog(@"Got authorization tokens. Access token: %@",
                                                                 authState.lastTokenResponse.accessToken);
                                                           [self setAuthState:authState];
                                                       } else {
                                                           NSLog(@"Authorization error: %@", [error localizedDescription]);
                                                           [self setAuthState:nil];
                                                       }
                                                       
                                                       [self processAuthorizationState];
                                                   }];
    
    
}


- (void) processAuthorizationState {
    if (self.authState == nil) {
        [NSNotificationCenter.defaultCenter postNotificationName: RequestsServiceAutorizationDidFailNotification object: nil];
        NSLog(@"_____ DidFail :(");
        
    } else {
        [NSNotificationCenter.defaultCenter postNotificationName: RequestsServiceAutorizationDidEndNotification object: @(YES)];
        NSLog(@"_____ DidSuccess :(");
    }
    
}

@end
