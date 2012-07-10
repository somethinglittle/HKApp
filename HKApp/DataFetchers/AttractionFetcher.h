//
//  AttractionFetcher.h
//  HKApp
//
//  Created by Casper Lee on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractDataFetcher.h"
#import "DataRequestDelegate.h"

@interface AttractionFetcher : AbstractDataFetcher

@property (nonatomic, weak) id<DataRequestByAttractionDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSNumber* pageNumber;

-(id) initWithDelegate:(id<DataRequestByAttractionDelegate>)delegate withManagedObjectContext:(NSManagedObjectContext *)aManagedObjectContext;
- (void)removeAllAttractionsFromManagedObjectContext;

@end
