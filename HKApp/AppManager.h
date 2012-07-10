//
//  AppManager.h
//  HKApp
//
//  Created by Casper Lee on 23/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRequestDelegate.h"

@interface AppManager : NSObject

+(AppManager*) sharedManager;


// Get and save more attractions for count number
- (void)updateAttractionsForCount:(int)count WithDelegate:(id<DataRequestByAttractionDelegate>)delegate;
- (void)requestSpotsForAttractionID:(NSString*)identifier withDelegate:(id<DataRequestByAttractionDelegate>)delegate;
- (void)requestMapForAttractionID:(NSString*)identifier withDelegate:(id<DataRequestByAttractionDelegate>)delegate;

- (void)requestInfoForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;
- (void)requestImageForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;
- (void)requestMapForSpotID:(NSString*)identifier withDelegate:(id<DataRequestBySpotDelegate>)delegate;


- (void)checkAppVersionWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;
- (void)getCreditsImagesWithDelegate:(id<DataRequestConfigInfoDelegate>)delegate;

+ (BOOL)isRetinaDisplay;

@end
