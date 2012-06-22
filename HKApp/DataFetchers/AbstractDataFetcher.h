//
//  AbstractDataFetcher.h
//  HKApp
//
//  Created by Casper Lee on 20/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractDataFetcher : NSObject

@property (nonatomic, strong) NSURLConnection* urlConnection;
@property (nonatomic, strong) NSMutableData* responseData;

-(void) fetchData;
-(void) makeConnectionWithUrl:(NSString*)url;

@end
