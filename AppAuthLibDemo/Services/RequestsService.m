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

static NSString * const kClientID = @"";
static NSString * const KRedirectURI = @"";

static NSString * const RequestsServiceAutorizationDidFailNotification = @"RequestsServiceAutorizationDidFailNotification";
static const NSString * const RequestsServiceAutorizationDidEndNotification = @"RequestsServiceAutorizationDidEndNotification";

@interface RequestsService()

// property of the containing class
@property (nonatomic, strong, nullable) OIDAuthState *authState;

@property (nonatomic, nullable) UIViewController *viewControllerToPresentOn;

@end

@implementation RequestsService

- (void) performAuthFlowOnViewController: (UIViewController *) viewControllerToPresentOn {
    self.viewControllerToPresentOn = viewControllerToPresentOn;
    NSURL *discoveryURL = [[NSURL alloc] initWithString: @""];
    
    [OIDAuthorizationService discoverServiceConfigurationForDiscoveryURL: discoveryURL completion:^(OIDServiceConfiguration * _Nullable configuration, NSError * _Nullable error) {
        if (configuration != nil) {
            [self buildAndPerformAuthorizationRequestWithConfiguration: configuration];
        } else {
            [NSNotificationCenter.defaultCenter postNotificationName: RequestsServiceAutorizationDidFailNotification object: nil];
        }
    }];
    
}

- (void) buildAndPerformAuthorizationRequestWithConfiguration: (OIDServiceConfiguration *) configuration {
    NSURL* redirectURL = [[NSURL alloc] initWithString: KRedirectURI];
    
    // builds authentication request
    OIDAuthorizationRequest *request =
    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                  clientId: kClientID
                                                    scopes:@[OIDScopeOpenID,
                                                             OIDScopeProfile]
                                               redirectURL: redirectURL
                                              responseType:OIDResponseTypeCode
                                      additionalParameters:nil];
    
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
                                                   }];
}

@end
