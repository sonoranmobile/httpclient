//
//  HttpsViewController.h
//  Https
//
//  Created by Michael Morris on 4/19/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHTTPClient.h"

@interface HttpsViewController : UIViewController <SMHTTPClientProtocol>
{
    
	IBOutlet UITextField *urlEdit;
	IBOutlet UITextView *pageText;
	IBOutlet UILabel *statusLabel;
	
	SMHTTPClient*			client;
}

- (IBAction)doFetch:(id)sender;
@end
