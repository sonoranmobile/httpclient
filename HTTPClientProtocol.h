//
//  HTTPClientProtocol.h
//  Https
//
//  Created by Michael Morris on 4/21/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HTTPClient;

@protocol HTTPClientProtocol <NSObject>
-(void)client:(HTTPClient*)client didReceiveError:(NSError*)err;
-(void)client:(HTTPClient*)client didcompleteRequestWithString:(NSString*)body;

@optional
-(void)client:(HTTPClient*)client didReceiveStatus:(NSString*)status;

@end
