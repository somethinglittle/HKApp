//
//  AppConfigFetcher.m
//  HKApp
//
//  Created by Casper Lee on 20/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataRequestDelegate.h"
#import "AppConfigFetcher.h"
#import "AppConfig.h"

#import "CJSONDeserializer.h"

@interface AppConfigFetcher (private)

-(AppConfig*) getAppConfig;

@end

@implementation AppConfigFetcher

-(id) initWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;
{
  if (self = [self init]) {
    _delegate = delegate;
  }
  return self;
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

-(void) partnerImageDidReceive:(UIImage*)image;
{
  if (image) {
    
  } else {
    if (_delegate && [_delegate respondsToSelector:@selector(appConfigDidReceive:)]) {
      [_delegate appConfigDidReceive:_appConfig];
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
      NSMutableArray* partnersArray = [NSMutableArray array];
      
      for (NSDictionary* dict in partnersDict) {
        if ([dict objectForKey:@"url"]) {
          NSString* resUrl = [dict objectForKey:@"url"];
          [partnersArray addObject:resUrl];
        }
      }
      
      PartnersFetcher* partenersFetcher = [[PartnersFetcher alloc] initWithAppConfigFetcher:self andEntriesArray:partnersArray];
      [partenersFetcher fetchData];
      
    } else {
      NSLog(@"Error: Partners array not exist");
      [self partnerImageDidReceive:nil];
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

-(id) initWithAppConfigFetcher:(AppConfigFetcher*)appConfigFetcher andEntriesArray:(NSArray*)entriesArray;
{
  if (self = [self init]) {
    _appConfigFetcher = appConfigFetcher;
    _entriesArray = entriesArray;
  }
  return self;
}

-(void) fetchData;
{
  for (NSString* url in _entriesArray) {
    NSLog(@"%@", StorageRoomURLChangeMeta(url));
    [self makeConnectionWithUrl:StorageRoomURLChangeMeta(url)];
  }
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
    
    NSLog(@"%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    
    NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserialize:self.responseData error:nil];
    if ([jsonDict objectForKey:@"error"])
    {
      @throw [NSException exceptionWithName:@"AppConfigFetcher" reason:[NSString stringWithFormat:@"Server Connection Error with HTTP %d", [[[jsonDict objectForKey:@"error"] objectForKey:@"code"]intValue]] userInfo:jsonDict];
    }
    
    NSDictionary* resources = (NSDictionary *)[jsonDict objectForKey:@"entry"];
    NSDictionary* companylogoDict = [resources objectForKey:@"companylogo"];
    
    NSString* imageUrl = [companylogoDict objectForKey:@"meta_url"];
    
    
        
    //    self.announcements = [NSMutableArray array];
    //    
    //    for(NSDictionary *d in arrayOfAnnouncementDictionaries) {    
    //      Announcement *announcement = [[Announcement alloc] init];
    //      [announcement setWithJSONDictionary:d];
    //      [announcements addObject:announcement];
    //    }
    //    
    //    if ([delegate respondsToSelector:@selector(announcementFetcherDidFinishDownload:withAnnouncements:)]) {
    //      [delegate performSelector:@selector(announcementFetcherDidFinishDownload:withAnnouncements:) withObject:self withObject:announcements];
    //    }
  }
  @catch (NSException *e) {
    NSLog(@"Error while parsing JSON and setting app config - parnters %@", [e description]);
    [_appConfigFetcher connection:aConnection didFailWithError:[NSError errorWithDomain:@"PartnersFetcher" code:0 userInfo:[NSDictionary dictionaryWithObject:_entriesArray forKey:@"entryUrl"]]];
  }
}

@end
