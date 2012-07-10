//
//  AttractionFetcher.m
//  HKApp
//
//  Created by Casper Lee on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttractionFetcher.h"
#import "Attraction.h"

#import "CJSONDeserializer.h"

@implementation AttractionFetcher

@synthesize managedObjectContext, pageNumber, delegate;

#pragma mark -
#pragma mark NSObject

-(id) init;
{
  if (self = [super init]) {
    [self setPageNumber:[NSNumber numberWithInt:1]];
  }
  return self;
}

-(id) initWithDelegate:(id<DataRequestByAttractionDelegate>)aDelegate withManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext;
{
  if (self = [self init]) {
    self.delegate = aDelegate;
    self.managedObjectContext = aManagedObjectContext;
  }
  return self;
}

-(void) dealloc;
{
  if ([self delegate]) {
    [self setDelegate:nil];
  }
}


#pragma mark -
#pragma mark Helpers

-(void) fetchData;
{
  NSMutableString* urlFormat = [StorageRoomURL([NSMutableString stringWithFormat:@"/collections/%@/entries.json",kSRCollectionAttractionID]) mutableCopy];
  [urlFormat appendFormat:@"&per_page=%d&page=%d&sort=rank&order=asc", 10, [[self pageNumber] intValue]];
  
  NSLog(@"%@", urlFormat);
  
  [self makeConnectionWithUrl:urlFormat];
}

-(void) removeAllAttractionsFromManagedObjectContext;
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = [NSEntityDescription entityForName:@"Attraction" inManagedObjectContext:managedObjectContext];
	
	NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
  NSLog(@"Removing %d existing attractions", [results count]);
  
	for (Attraction *attraction in results) {
		[managedObjectContext deleteObject:attraction];
	}
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error {
  NSLog(@"Error while downloading app config: %@", error);
  
  if ([self delegate] && [[self delegate] respondsToSelector:@selector(attractionsRequestFailed:)]) {
    [[self delegate] attractionsRequestFailed:error];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
  NSLog(@"Downloading attractions successful");
  
  NSLog(@"DEBUG: %@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
  
  @try {
    NSDictionary *jsonDict = [[CJSONDeserializer deserializer] deserialize:self.responseData error:nil];
    if ([jsonDict objectForKey:@"error"])
    {
      @throw [NSException exceptionWithName:@"AttractionFetcher" reason:[NSString stringWithFormat:@"Server Connection Error with HTTP %d", [[[jsonDict objectForKey:@"error"] objectForKey:@"code"]intValue]] userInfo:jsonDict];
    }
    
    NSDictionary *resources = (NSDictionary *)[jsonDict objectForKey:@"array"];
    NSArray *arrayOfAttractionDictionaries = (NSArray *)[resources objectForKey:@"resources"];
    
    for (NSDictionary* d in arrayOfAttractionDictionaries) {
      Attraction* attraction = (Attraction*)[NSEntityDescription insertNewObjectForEntityForName:@"Attraction" inManagedObjectContext:managedObjectContext];
      [attraction setWithJSONDictionary:d];
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    if ([delegate respondsToSelector:@selector(attractionsDidReceive)]) {
      [delegate performSelector:@selector(attractionsDidReceive)];
    }

  }
  @catch (NSException *e) {
    NSLog(@"Error while parsing JSON and setting attractions: %@", [e reason]);
    
    if ([delegate respondsToSelector:@selector(attractionsRequestFailed:)]) {
      NSError *error = [NSError errorWithDomain:@"AttractionFetcher" code:2 userInfo:nil];
      [delegate attractionsRequestFailed:error];
    } 
  }
  @finally {
    self.responseData = nil;
  }
}

@end
