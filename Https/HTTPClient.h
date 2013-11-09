//
//  HTTPClient.h
//  Https
//
//  Created by Michael Morris on 4/21/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//
// To do a post create a dictionary with the key/value pairs 
// needed for the form and use the post: or post:toUrl: methods.
//


/*  This class was originally written by me in 2011 and has been used and modified quite a bit over the years.
	I made a few changes to it for this exercise and noticed some things I would like to change but are not
	required for this exercise.  The main change I plan to make will be to support blocks or delegate. */

#import <Foundation/Foundation.h>

@class HTTPClient;

@protocol HTTPClientProtocol <NSObject>
@required
-(void)client:(HTTPClient*)client didReceiveError:(NSError*)err;
-(void)client:(HTTPClient*)client didcompleteRequestWithData:(NSData*)data;

@optional
-(void)client:(HTTPClient*)client didReceiveStatus:(NSString*)status;

@end


@interface HTTPClient : NSObject 
@property (nonatomic, strong, readonly) NSMutableData* data;
@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) id<HTTPClientProtocol> delegate;
@property (assign, nonatomic) NSInteger statusCode;
@property (strong, nonatomic) NSString* statusString;


+(HTTPClient*)client;
+(HTTPClient*)clientWithUrl:(NSURL*)u;

+(NSString*)baseURL;
+(NSString*)userString;

-(id)init;
-(id)initWithUrl:(NSURL*)u;

-(BOOL)run;
-(BOOL)runWithUrl:(NSURL*)u;
-(BOOL)post:(NSDictionary*)postData;
-(BOOL)post:(NSDictionary*)postData toUrl:(NSURL*)u;
-(BOOL)postJSONWithDictionary:(NSDictionary*)postData;

-(void)setAcceptableHosts:(NSArray*)hostArray;
-(NSArray*)acceptableHosts;
-(void)addHost:(NSString*)newHost;
-(void)addHosts:(NSArray*)hostArray;

-(NSString*)dataAsString;
-(NSDictionary*)jsonDataError:(NSError**)error;
@end
