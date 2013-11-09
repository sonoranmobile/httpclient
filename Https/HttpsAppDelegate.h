//
//  HttpsAppDelegate.h
//  Https
//
//  Created by Michael Morris on 4/19/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HttpsViewController;

@interface HttpsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet HttpsViewController *viewController;

@end
