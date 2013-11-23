//
//  SMHTTPClient.m
//  Https
//
//  Created by Michael Morris on 4/21/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

// NSJSONSerialization

#import "SMHTTPClient.h"
#import <Foundation/NSJSONSerialization.h>


@interface SMHTTPClient ()
@property (strong, nonatomic) NSURLConnection*	connection;
@property (strong, nonatomic) NSMutableArray*	acceptHosts;

@end

@implementation SMHTTPClient


+(SMHTTPClient*)client;
{
	SMHTTPClient* client = [[SMHTTPClient alloc] init];
	return client;
}

+(SMHTTPClient*)clientWithUrl:(NSURL*)u
{
	SMHTTPClient* client = [[SMHTTPClient alloc] initWithUrl:u];
	return client;
}

-(id)init
{
	self = [super init];
	if(self) {
		_data = [[NSMutableData alloc] init];
		_acceptHosts = [[NSMutableArray alloc] init];
	}
	
	return self;
}

-(id)initWithUrl:(NSURL*)u
{
	self = [self init];
	if(self) {
		[self setUrl:u];
	}
	return self;
}

-(BOOL)run
{
	BOOL result = NO;
	
	if(_url)
	{
		[_data setLength:0];
		NSURLRequest* request = [NSURLRequest requestWithURL:_url];
		_connection =
			[[NSURLConnection alloc] initWithRequest:request delegate:self];
		result = YES;
	}
	
	return result;
}


-(BOOL)runWithUrl:(NSURL*)u
{
	[self setUrl:u];
	return [self run];
}

-(BOOL)runCompletion:(void(^)(NSError**))completion {
	_completionHandler = completion;
	BOOL success = [self run];
	return success;
}

-(BOOL)runWithUrl:(NSURL*)u completion:(void(^)(NSError**))completion {
	_url = u;
	BOOL success = [self runCompletion:completion];
	return success;
}

-(NSString*)postDataFromDictionary:(NSDictionary*)input
{
	NSMutableString* body = [NSMutableString string];
	NSEnumerator* en = [input keyEnumerator];
	NSString* key;
	while((key = [en nextObject]))
	{
		NSString* value = [input objectForKey:key];
		if([body length] > 0)
			[body appendString:@"&"];
		[body appendFormat:@"%@=%@", key, value];
	}
	
	return body;
}

-(BOOL)post:(NSDictionary*)postData
{
	BOOL result = NO;
	
	if(_url)
	{
		[_data setLength:0];
		NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:_url];
		[request setHTTPMethod:@"POST"];
		NSString* body = [self postDataFromDictionary:postData];
		const char* bodyString = [body cStringUsingEncoding:NSUTF8StringEncoding];
		NSData* bodyData = [NSData dataWithBytes:bodyString length:strlen(bodyString)];
		[request setHTTPBody:bodyData];
		_connection =
		[[NSURLConnection alloc] initWithRequest:request delegate:self];
		result = YES;
	}
	
	return result;
}

-(BOOL)post:(NSDictionary*)postData toUrl:(NSURL*)u
{
	[self setUrl:u];
	return [self post:postData];
}

/* Takes an NSDictionary and creates a JSON object containing the 
   items in the dictionary and uses that as the body in the post
*/
-(BOOL)postJSONWithDictionary:(NSDictionary*)postData {
	BOOL success = NO;
	NSError* error = nil;
	if([NSJSONSerialization isValidJSONObject:postData]) {
		NSData* json = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&error];
		
		if(_url) {
			[_data setLength:0];
			NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:_url];
			[request setHTTPMethod:@"POST"];
			[request setHTTPBody:json];
			[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
			_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
			success = YES;
		}
		
	}
	return success;
}


-(void)setAcceptableHosts:(NSArray*)hostArray
{
	_acceptHosts = [[NSMutableArray alloc] initWithArray:hostArray];
}

-(NSArray*)acceptableHosts
{
	return _acceptHosts;
}

-(void)addHost:(NSString*)newHost
{
	[_acceptHosts addObject:newHost];
}

-(void)addHosts:(NSArray*)hostArray
{
	[_acceptHosts addObjectsFromArray:hostArray];
}


-(void)sendStatus:(NSString*)status
{
	if([_delegate respondsToSelector:@selector(client:didReceiveStatus:)])
		[_delegate client:self didReceiveStatus:status];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	NSString* statusText = @"connection:canAuthenticateAgainstProtectionSpace:";
	[self sendStatus:statusText];
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSString* statusText = @"connection:didCancelAuthenticationChallenge:";
	[self sendStatus:statusText];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod
		 isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
		// we only trust our own domain
		if([_acceptHosts containsObject:challenge.protectionSpace.host])
		{
			NSURLCredential *credential =
			[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
		}
	}
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	
	NSString* statusText = @"connection:didReceiveAuthenticationChallenge:";
	[self sendStatus:statusText];
	/*	NSInteger failurecount = [challenge previousFailureCount];
	 if(failurecount == 0)
	 {
	 NSURLCredential* propCred = [challenge proposedCredential];
	 if(propCred == nil)
	 {
	 //			propCred = [NSURLCredential credentialForTrust:
	 
	 }
	 }
	 //	SecTrustResultType result;
	 //	SecTrustEvaluate(result
	 */
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
	NSString* statusText = @"connectionShouldUseCredentialStorage:";
	[self sendStatus:statusText];
	return NO;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
	NSString* statusText = @"connection:willCacheResponse:";
	[self sendStatus:statusText];
	return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSString* statusText = @"connection:didReceiveResponse:";
	NSHTTPURLResponse* urlResponse = (NSHTTPURLResponse*)response;
	_statusCode = urlResponse.statusCode;
	_statusString = [NSHTTPURLResponse localizedStringForStatusCode:_statusCode];
	[self sendStatus:statusText];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)value
{
	NSString* statusText = @"connection:didReceiveData:";
	[self sendStatus:statusText];
	[_data appendData:value];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	NSString* statusText = @"connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:";
	[self sendStatus:statusText];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
	NSString* statusText = @"connection:willSendRequest:redirectResponse:";
	return request;
	[self sendStatus:statusText];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
	NSString* statusText = @"connection:didFailWithError:";
	[self sendStatus:statusText];
	_connection = nil;
	if(_completionHandler) {
		_completionHandler(&error);
	}else if(_delegate) {
		[_delegate client:self didReceiveError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
	NSString* statusText = @"connectionDidFinishLoading:";
	[self sendStatus:statusText];
	NSError* error = nil;
	if(_completionHandler) {
		_completionHandler(&error);
	}else if(_delegate) {
		[_delegate client:self didcompleteRequestWithData:_data];
	}
	_connection = nil;
}

-(NSString*)dataAsString
{
	NSString* pageText = [[NSString alloc]
						   initWithBytes:[_data bytes] length:[_data length] encoding:NSUTF8StringEncoding];
	return pageText;
}

-(NSDictionary*)jsonDataError:(NSError**)error {
	NSDictionary* dictionary = nil;
	*error = nil;
	dictionary = [NSJSONSerialization JSONObjectWithData:_data options:0 error:error];
	if(*error) {
		NSLog(@"jsonData found error %@", *error);
		dictionary = nil;
	}
	
	return dictionary;
}

@end
