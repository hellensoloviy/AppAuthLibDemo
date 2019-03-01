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


const NSString *kClientID = @"";
const NSString *KRedirectURI = @"";

@interface RequestsService()

// property of the containing class
@property(nonatomic, strong, nullable) OIDAuthState *authState;

@end

@implementation RequestsService



- (void) performAuthFlow {
    
    
    
}

- (void) buildAndPerformAuthorizationRequestWithConfiguration: (OIDServiceConfiguration *) configuration {
    // builds authentication request
    OIDAuthorizationRequest *request =
    [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                  clientId: kClientID
                                                    scopes:@[OIDScopeOpenID,
                                                             OIDScopeProfile]
                                               redirectURL:KRedirectURI
                                              responseType:OIDResponseTypeCode
                                      additionalParameters:nil];
    
    // performs authentication request
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                   presentingViewController:self
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
