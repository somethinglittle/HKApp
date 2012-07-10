//
//  StorageRoom.m
//  StorageRoomCatalog
//
//  Created by ; Konietzke on 8/2/11.
//  Copyright 2011 Thriventures. All rights reserved.
//

#import "StorageRoom.h"

// These are account credentials for the demo account on StorageRoom. 
// You can use these to play with the Catalog but you must change this for your own app.

NSString * const StorageRoomHost = @"api.storageroomapp.com"; 

NSString *const kSRAccountID = @"4fcf7829b9935e7458000002";
NSString *const kSRAuthenticationToken = @"NYQrfZJhHfpNe8tJnUFB";
NSString *const kSRAuthenticationTokenWithWriteAccess = @"";

NSString *const kSRCollectionAttractionID = @"4fcf7feeb9935e1f2c00002e";
NSString *const kSRCollectionSpotID = @"4fd010b9b9935e65e2000005";
NSString *const kSRCollectionConfigID = @"4fdb0793b9935e3ef3000015";
NSString *const kSRCollectionPartnersID = @"4fdb082ab9935e406e000012";

NSString *StorageRoomURLChangeMeta(NSString *path) {
  return [NSString stringWithFormat:@"%@?meta_prefix=meta_", path];
}

NSString *StorageRoomURL(NSString *path) {
  return StorageRoomURLChangeMeta([NSString stringWithFormat:@"http://%@/accounts/%@%@", StorageRoomHost, kSRAccountID, path]);
}

id NilOrValue(id aValue) {
  if ((NSNull *)aValue == [NSNull null]) {
    return nil;
  }
  else {
    return aValue;
  }
}