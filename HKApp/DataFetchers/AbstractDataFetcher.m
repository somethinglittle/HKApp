//
//  AbstractDataFetcher.m
//  HKApp
//
//  Created by Casper Lee on 20/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbstractDataFetcher.h"

@implementation AbstractDataFetcher

@synthesize urlConnection, responseData;

#pragma mark -
#pragma mark NSObject

-(void) dealloc;
{
  [[self urlConnection] cancel];
}


#pragma mark -
#pragma mark Helpers

-(id) init;
{
  if (self = [super init]) {
    [self setResponseData:[[NSMutableData alloc] init]];
  }
  return self;
}

-(void) fetchData;
{
  NSLog(@"AbstractDataFetcher: *** ERROR: Method 'fetchData' should be overridden");
}

-(void) makeConnectionWithUrl:(NSString*)url;
{
  if ([self urlConnection]) {
    [[self urlConnection] cancel];
  }
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
  NSMutableDictionary *headers = [NSMutableDictionary dictionary];
  [headers setObject:@"application/json" forKey:@"Accept"];
  [headers setObject:@"application/json" forKey:@"Content-Type"];
  
  [request setAllHTTPHeaderFields:headers];
  
  [self setUrlConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)response {
  [[self responseData] setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data {
  [[self responseData] appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
  NSLog(@"AbstractDataFetcher: *** ERROR: Method 'didFailWithError' should be overridden");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
  NSLog(@"AbstractDataFetcher: *** ERROR: Method 'connectionDidFinishLoading' should be overridden");
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
  if (challenge.previousFailureCount == 0) {
    NSLog(@"Received authentication challenge");
    
    NSURLCredential *newCredential =[NSURLCredential credentialWithUser:kSRAuthenticationToken password:@"X" persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
  }
  else {
    [self connection:connection didFailWithError:[NSError errorWithDomain:@"AbstractDataFetcher" code:0 userInfo:nil]];
  }
}

@end
