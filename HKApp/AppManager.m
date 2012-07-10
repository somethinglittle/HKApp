//
//  AppManager.m
//  HKApp
//
//  Created by Casper Lee on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"

#pragma mark - Private Interface

@interface AppManager (private)

+(id) sharedManager;
- (NSString*) getServerVersion;

@end

@implementation AppManager

static AppManager* _sharedInstance;

+(AppManager*) sharedManager;
{
  if (!_sharedInstance) {
    @synchronized (self)
    {
      _sharedInstance = [[self alloc] init];
    } 
  }
  return _sharedInstance;
}

#pragma mark Request By Attraction

- (void)updateAttractionsForCount:(int)count WithDelegate:(id<DataRequestByAttractionDelegate>)delegate;
{
  
}

- (void)requestSpotsForAttractionID:(NSString*)identifier withDelegate:(id<DataRequestByAttractionDelegate>)delegate;
{
  
}

- (void)requestMapForAttractionID:(NSString*)identifier withDelegate:(id<DataRequestByAttractionDelegate>)delegate;
{
  
}


#pragma mark Request By Spot

- (void)requestInfoForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;
{
}

- (void)requestImageForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;
{
  
}
- (void)requestMapForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;
{
  
}

#pragma mark Request Config Info

- (void)checkAppVersionWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;
{
  
}

- (void)getCreditsImagesWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;
{
  
}


+(BOOL)isRetinaDisplay{
  return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
}

@end
