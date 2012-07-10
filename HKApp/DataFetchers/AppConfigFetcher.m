//
//  AppConfigFetcher.m
//  HKApp
//
//  Created by Casper Lee on 20/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataRequestDelegate.h"
#import "AppManager.h"
#import "AppConfigFetcher.h"
#import "AppConfig.h"

#import "CJSONDeserializer.h"

@interface AppConfigFetcher (private)

-(AppConfig*) getAppConfig;
-(void) checkPartnerDataDidFinish;

@end

@implementation AppConfigFetcher

-(id) init;
{
  if (self = [super init]) {
    _requestCount = 0;
    _responseCount = 0;
  }
  return self;
}

-(id) initWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;
{
  if (self = [self init]) {
    _delegate = delegate;
  }
  return self;
}

-(void) dealloc;
{
  if (_appConfig) {
   _appConfig = nil; 
  }
  
  if (_delegate) {
    _delegate = nil;
  }
}

-(AppConfig*) getAppConfig;
{
  if (!_appConfig) {
    _appConfig = [[AppConfig alloc] init];
  }
  return _appConfig;
}

-(void) fetchData;
{
  NSMutableString* urlFormat = [StorageRoomURL([NSMutableString stringWithFormat:@"/collections/%@/entries.json",kSRCollectionConfigID]) mutableCopy];
  [urlFormat appendFormat:@"&per_page=%d&sort=app_version&order=desc", 1];
  
  [self makeConnectionWithUrl:urlFormat];
}

-(void) partnerDataDidReceive:(UIImageView*)imageView;
{
  if (imageView) {
    [[[self getAppConfig] partnersArray] addObject:imageView];
  }
  _responseCount++;
  [self checkPartnerDataDidFinish];
}

-(void) partnerDataDidError:(NSError*)error;
{
  NSLog(@"Error when loading partner data: %@", [error description]);
  _responseCount++;
  [self checkPartnerDataDidFinish];
}

-(void) checkPartnerDataDidFinish;
{
  if (_responseCount >= _requestCount) {
    if (_delegate && [_delegate respondsToSelector:@selector(appConfigDidReceive:)]) {
      [_delegate appConfigDidReceive:[self getAppConfig]];
    }
    else {
      NSLog(@"Error: delegate does not exist or does not response to appConfigDidReceive:");
    }
  }
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
  NSLog(@"Error while downloading app config: %@", error);
  
  if (_delegate && [_delegate respondsToSelector:@selector(appConfigRequestFailed:)]) {
    [_delegate appConfigRequestFailed:error];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
  NSLog(@"Downloading app config successful");
  
//  NSLog(@"DEBUG: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
  
  @try {
    NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserialize:self.responseData error:nil];
    if ([jsonDict objectForKey:@"error"])
    {
      @throw [NSException exceptionWithName:@"AppConfigFetcher" reason:[NSString stringWithFormat:@"Server Connection Error with HTTP %d", [[[jsonDict objectForKey:@"error"] objectForKey:@"code"]intValue]] userInfo:jsonDict];
    }

    NSDictionary *resources = (NSDictionary *)[jsonDict objectForKey:@"array"];
    NSArray *arrayOfAppConfigDictionaries = (NSArray *)[resources objectForKey:@"resources"];

    NSDictionary* configDict = [arrayOfAppConfigDictionaries objectAtIndex:0];
    
    if ([configDict objectForKey:@"app_version"]) {
      [[self getAppConfig] setAppVersion:[configDict objectForKey:@"app_version"]];
    }
    
    if ([configDict objectForKey:@"featuring_number"]) {
      [[self getAppConfig] setFeaturingNumber:[configDict objectForKey:@"featuring_number"]];
    }
    
    if ([configDict objectForKey:@"partners"]) {
      NSDictionary* partnersDict = [configDict objectForKey:@"partners"];
      
      
      for (NSDictionary* dict in partnersDict) {
        if ([dict objectForKey:@"url"]) {
          NSString* resUrl = [dict objectForKey:@"url"];
          PartnersFetcher* partenersFetcher = [[PartnersFetcher alloc] initWithAppConfigFetcher:self andUrl:resUrl];
          [partenersFetcher fetchData];
          _requestCount++;
        }
      }
    } else {
      NSLog(@"Error: Partners array not exist");
      [self checkPartnerDataDidFinish];
    }
  
  }
  @catch (NSException *e) {
    NSLog(@"Error while parsing JSON and setting app config %@", [e description]);
    
    if (_delegate && [_delegate respondsToSelector:@selector(appConfigRequestFailed:)]) {
      [_delegate performSelector:@selector(appConfigRequestFailed:) withObject:[e description]];
    }
  }
}

@end







////////////////////////////////////////////////////////////////// Partners Fetcher //////////////////////////////////////////////////////////////////

@implementation PartnersFetcher

-(id) initWithAppConfigFetcher:(AppConfigFetcher*)appConfigFetcher andUrl:(NSString*)url;
{
  if (self = [self init]) {
    _appConfigFetcher = appConfigFetcher;
    _url = url;
  }
  return self;
}

-(void) fetchData;
{
  [self makeConnectionWithUrl:StorageRoomURLChangeMeta(_url)];
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error;
{
  NSLog(@"Error while downloading app config - parnter: %@", error);
  [_appConfigFetcher connection:aConnection didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
  NSLog(@"Downloading app config - parnter successful");
  
  @try {
    
    NSLog(@"DEBUG: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
  
    NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserialize:self.responseData error:nil];
    if ([jsonDict objectForKey:@"error"])
    {
      @throw [NSException exceptionWithName:@"AppConfigFetcher" reason:[NSString stringWithFormat:@"Server Connection Error with HTTP %d", [[[jsonDict objectForKey:@"error"] objectForKey:@"code"]intValue]] userInfo:jsonDict];
    }
    
    NSDictionary* resources = (NSDictionary *)[jsonDict objectForKey:@"entry"];
    NSDictionary* partnerLogoDict =  [resources objectForKey:@"partnerlogo"];
    NSString* imageUrl = [NSString string];
    
//    NSString* partnerType = [resources objectForKey:@"partnertype"];
//    NSString* partnerName = [resources objectForKey:@"partnername"];

    if ([AppManager isRetinaDisplay]) { 
      imageUrl = [partnerLogoDict objectForKey:@"meta_url"];
    } else {
      imageUrl = [[[partnerLogoDict objectForKey:@"meta_versions"] objectForKey:@"lowres"] objectForKey:@"meta_url"];
    }
    
    
    UIImageView* imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    [_appConfigFetcher partnerDataDidReceive:imageView];
    
  }
  @catch (NSException *e) {
    NSLog(@"Error while parsing JSON and setting app config - parnters %@", [e description]);
    [_appConfigFetcher connection:aConnection didFailWithError:[NSError errorWithDomain:@"PartnersFetcher" code:0 userInfo:[NSDictionary dictionaryWithObject:_url forKey:@"entryUrl"]]];
  }
}

@end
