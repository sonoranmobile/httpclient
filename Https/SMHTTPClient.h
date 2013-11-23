//
//  SMHTTPClient.h
//  Https
//
//  Created by Michael Morris on 4/21/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//
// To do a post create a dictionary with the key/value pairs 
// needed for the form and use the post: or post:toUrl: methods.
//



#import <Foundation/Foundation.h>

@class SMHTTPClient;

@protocol SMHTTPClientProtocol <NSObject>
@required
-(void)client:(SMHTTPClient*)client didReceiveError:(NSError*)err;
-(void)client:(SMHTTPClient*)client didcompleteRequestWithData:(NSData*)data;

@optional
-(void)client:(SMHTTPClient*)client didReceiveStatus:(NSString*)status;

@end


@interface SMHTTPClient : NSObject 
@property (nonatomic, strong, readonly) NSMutableData* data;
@property (strong, nonatomic) NSURL* url;
@property (strong, nonatomic) id<SMHTTPClientProtocol> delegate;
@property (assign, nonatomic) NSInteger statusCode;
@property (strong, nonatomic) NSString* statusString;
@property (strong, nonatomic) void (^completionHandler)(NSError**);

+(SMHTTPClient*)client;
+(SMHTTPClient*)clientWithUrl:(NSURL*)u;

-(id)init;
-(id)initWithUrl:(NSURL*)u;

-(BOOL)run;
-(BOOL)runWithUrl:(NSURL*)u;
-(BOOL)runCompletion:(void(^)(NSError**))completion;
-(BOOL)runWithUrl:(NSURL*)u completion:(void(^)(NSError**))completion;
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
