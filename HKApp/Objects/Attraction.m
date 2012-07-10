//
//  Attraction.m
//  HKApp
//
//  Created by Casper Lee on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Attraction.h"

@implementation Attraction

@dynamic identifier;
@dynamic title;
@dynamic rank;
@dynamic caption;
@dynamic details;
@dynamic transportation;
@dynamic coverPhoto;
@dynamic coverPhotoUrl;
//@dynamic kmlFile;
@dynamic kmlFileUrl;
@dynamic spots;
@dynamic district;

#pragma mark -
#pragma mark Helpers

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary {
  NSLog(@"DICT: %@",aDictionary);
  NSString* title = [aDictionary objectForKey:@"title"];
  NSLog(@"%@", title);
}


@end
