//
//  AppDelegate.h
//  AppAuthLibDemo
//
//  Created by Hellen Soloviy on 3/1/19.
//  Copyright © 2019 HellySolovii. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

// property of the app's AppDelegate
@property(nonatomic, strong, nullable) id<OIDExternalUserAgentSession> currentAuthorizationFlow;

@end

