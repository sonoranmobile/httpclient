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

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet HttpsViewController *viewController;

@end
