//
//  AppConfig.h
//  HKApp
//
//  Created by Casper Lee on 18/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject {
  
}

@property (nonatomic, strong) NSString* appVersion;
@property (nonatomic, strong) NSNumber* featuringNumber;
@property (nonatomic, strong) NSMutableArray* credits;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;

@end
