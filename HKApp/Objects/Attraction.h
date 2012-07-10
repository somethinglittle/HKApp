//
//  Attraction.h
//  HKApp
//
//  Created by Casper Lee on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Attraction : NSManagedObject

@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* rank;
@property (nonatomic, strong) NSString* caption;
@property (nonatomic, strong) NSString* details;
@property (nonatomic, strong) NSString* transportation;
@property (nonatomic, strong) NSString* coverPhotoUrl;
@property (nonatomic, strong) UIImageView* coverPhoto;
//@property (nonatomic, strong) NS??* kmlFile;
@property (nonatomic, strong) NSString* kmlFileUrl;
@property (nonatomic, strong) NSMutableArray* spots;
@property (nonatomic, strong) NSString* district;

- (void)setWithJSONDictionary:(NSDictionary *)aDictionary;

@end
