//
//  AppConfig.m
//  HKApp
//
//  Created by Casper Lee on 18/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

@synthesize appVersion, featuringNumber, credits;

-(id) init;
{
  if (self = [super init]) {
    self.featuringNumber = [NSNumber numberWithInt:5];
  }
  return self;
}

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;
{
  self.appVersion = NilOrValue([aDictionary objectForKey:@"app_version"]);
  self.featuringNumber = NilOrValue([aDictionary objectForKey:@"featuring_number"]);
  
  NSDictionary* creditsDict = [aDictionary objectForKey:@"credits"];
  NSLog(@"DEBUG LOGGER - creditsDict: %@", creditsDict);
}

@end
