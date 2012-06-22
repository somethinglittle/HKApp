//
//  HKAppDataRequestDelegate.h
//  HKApp
//
//  Created by Casper Lee on 15/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppConfig;

@protocol DataRequestByAttractionDelegate <NSObject>

@required
- (void)spotsDidReceive:(NSArray*)spotsArray forAttractionID:(NSString*)attractionID;
- (void)mapDidReceive:(UIView*)mapView forAttractionID:(NSString*)attractionID;
- (void)attractionsDidReceive;

- (void)spotsRequestFailedforAttractionID:(NSString*)attractionID:(NSError*)error;
- (void)mapRequestFailedforAttractionID:(NSString*)attractionID:(NSError*)error;
- (void)attractionsRequestFailed:(NSError*)error;
@end



@protocol DataRequestBySpotDelegate <NSObject>

@required
- (void)infoRequestFailedforSpotID:(NSString*)spotID;
- (void)imageRequestFailedforSpotID:(NSString*)spotID;
- (void)mapRequestFailedforSpotID:(NSString*)spotID;

- (void)infoRequestFailedforSpotID:(NSString*)spotID:(NSError*)error;
- (void)imageRequestFailedforSpotID:(NSString*)spotID:(NSError*)error;
- (void)mapRequestFailedforSpotID:(NSString*)spotID:(NSError*)error;
@end



@protocol DataRequestConfigInfoDelegate <NSObject>

@required
- (void)appConfigDidReceive:(AppConfig*)appConfig;

- (void)appConfigRequestFailed:(NSError*)error;

@optional
- (void)attractionImagePreloaded:(UIImage*)image;
@end
