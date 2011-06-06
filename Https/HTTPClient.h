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

#import <Foundation/Foundation.h>
#import "HTTPClientProtocol.h"


@interface HTTPClient : NSObject 
{
    NSURLConnection*	connection;
	NSMutableData*		data;
	NSURL*				url;
	
	id<HTTPClientProtocol> delegate;
	NSMutableArray*		acceptHosts;
}
@property (nonatomic, retain, readonly) NSMutableData* data;
@property (retain, nonatomic) NSURL* url;
@property (retain, nonatomic) id<HTTPClientProtocol> delegate;


+(HTTPClient*)client;
+(HTTPClient*)clientWithUrl:(NSURL*)u;

-(id)init;
-(id)initWithUrl:(NSURL*)u;

-(BOOL)run;
-(BOOL)runWithUrl:(NSURL*)u;
-(BOOL)post:(NSDictionary*)postData;
-(BOOL)post:(NSDictionary*)postData toUrl:(NSURL*)u;

-(void)setAcceptableHosts:(NSArray*)hostArray;
-(NSArray*)acceptableHosts;
-(void)addHost:(NSString*)newHost;
-(void)addHosts:(NSArray*)hostArray;

+(NSData*)postSynchronousRequest:(NSDictionary*)postData
						   toUrl:(NSURL*)url
			   returningResponse:(NSURLResponse **)response 
						   error:(NSError **)error;

@end
