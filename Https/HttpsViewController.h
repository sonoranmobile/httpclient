//
//  HttpsViewController.h
//  Https
//
//  Created by Michael Morris on 4/19/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPClient.h"

@interface HttpsViewController : UIViewController <HTTPClientProtocol>
{
    
	IBOutlet UITextField *urlEdit;
	IBOutlet UITextView *pageText;
	IBOutlet UILabel *statusLabel;
	
	HTTPClient*			client;
}

- (IBAction)doFetch:(id)sender;
@end
