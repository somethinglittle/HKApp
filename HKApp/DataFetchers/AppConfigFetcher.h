//
//  AppConfigFetcher.h
//  HKApp
//
//  Created by Casper Lee on 20/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractDataFetcher.h"
#import "DataRequestDelegate.h"

@interface AppConfigFetcher : AbstractDataFetcher {
  AppConfig* _appConfig;
  id<DataRequestConfigInfoDelegate> _delegate;
}

-(void) partnerImageDidReceive;
- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error;

@end



@interface PartnersFetcher : AbstractDataFetcher {
  AppConfigFetcher* _appConfigFetcher;
  NSArray* _entriesArray;
}

-(id) initWithAppConfigFetcher:(AppConfigFetcher*)appConfigFetcher andEntriesArray:(NSArray *)entriesArray;

@end