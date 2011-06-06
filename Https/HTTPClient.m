//
//  HTTPClient.m
//  Https
//
//  Created by Michael Morris on 4/21/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import "HTTPClient.h"


@implementation HTTPClient
@synthesize data;
@synthesize url;
@synthesize delegate;

+(HTTPClient*)client;
{
	HTTPClient* client = [[[HTTPClient alloc] init] autorelease];
	return client;
}

+(HTTPClient*)clientWithUrl:(NSURL*)u
{
	HTTPClient* client = [[[HTTPClient alloc] initWithUrl:u] autorelease];
	return client;
}

-(id)init
{
	[super init];
	data = [[NSMutableData alloc] init];
	acceptHosts = [[NSMutableArray alloc] init];
	return self;
}

-(id)initWithUrl:(NSURL*)u
{
	[self init];
	[self setUrl:u];
	return self;
}

-(void)dealloc
{
	[connection release];
	[data release];
	[url release];
	[delegate release];
	[acceptHosts release];
	[super dealloc];
}

-(BOOL)run
{
	BOOL result = NO;
	
	if(url)
	{
		[data setLength:0];
		NSURLRequest* request = [NSURLRequest requestWithURL:url];
		connection = 
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

+(NSString*)postDataFromDictionary:(NSDictionary*)input
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
	
	if(url)
	{
		[data setLength:0];
		NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
		[request setHTTPMethod:@"POST"];
		NSString* body = [HTTPClient postDataFromDictionary:postData];
		const char* bodyString = [body cStringUsingEncoding:NSUTF8StringEncoding];
		NSData* bodyData = [NSData dataWithBytes:bodyString length:strlen(bodyString)];
		[request setHTTPBody:bodyData];
		connection = 
		[[NSURLConnection alloc] initWithRequest:request delegate:self];
		result = YES;
	}
	
	return result;
}

+(NSData*)postSynchronousRequest:(NSDictionary*)postData
						   toUrl:(NSURL*)url
			   returningResponse:(NSURLResponse **)response 
						   error:(NSError **)error
{
	NSData* resultBody;
	
	if(url)
	{
		NSMutableURLRequest* request = 
			[NSMutableURLRequest requestWithURL:url];
		[request setHTTPMethod:@"POST"];
		
		NSString* body = [HTTPClient postDataFromDictionary:postData];
		const char* bodyString = 
			[body cStringUsingEncoding:NSUTF8StringEncoding];
		NSData* bodyData = 
			[NSData dataWithBytes:bodyString length:strlen(bodyString)];
		[request setHTTPBody:bodyData];
		resultBody = [NSURLConnection sendSynchronousRequest:request
										   returningResponse:response
													   error:error];
	}
	
	return resultBody;
}

-(BOOL)post:(NSDictionary*)postData toUrl:(NSURL*)u
{
	[self setUrl:u];
	return [self post:postData];
}


-(void)setAcceptableHosts:(NSArray*)hostArray
{
	NSMutableArray* temp = acceptHosts;
	acceptHosts = [[NSMutableArray alloc] initWithArray:hostArray];
	[temp release];
}

-(NSArray*)acceptableHosts
{
	return acceptHosts;
}

-(void)addHost:(NSString*)newHost
{
	[acceptHosts addObject:newHost];
}

-(void)addHosts:(NSArray*)hostArray
{
	[acceptHosts addObjectsFromArray:hostArray];
}


-(void)sendStatus:(NSString*)status
{
	if([delegate respondsToSelector:@selector(client:didReceiveStatus:)])
		[delegate client:self didReceiveStatus:status];
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
		if([acceptHosts containsObject:challenge.protectionSpace.host])
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
	[self sendStatus:statusText];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)value
{
	NSString* statusText = @"connection:didReceiveData:";
	[self sendStatus:statusText];
	[data appendData:value];
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSString* statusText = @"connection:didFailWithError:";
	[self sendStatus:statusText];
	[delegate client:self didReceiveError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString* statusText = @"connectionDidFinishLoading:";
	[self sendStatus:statusText];
	[data appendData:[NSData dataWithBytes:"\0" length:1]];
	NSString* body = [NSString stringWithUTF8String:[data bytes]];
	[delegate client:self didcompleteRequestWithString:body];
}



@end
