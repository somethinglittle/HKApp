//
//  StorageRoom.h
//  StorageRoomCatalog
//
//  Created by Sascha Konietzke on 8/2/11.
//  Copyright 2011 Thriventures. All rights reserved.
//

extern NSString * const StorageRoomHost;
NSString *StorageRoomURLChangeMeta(NSString *path);
NSString *StorageRoomURL(NSString *path);

extern NSString *const kSRAccountID;
extern NSString *const kSRAuthenticationToken;
extern NSString *const kSRAuthenticationTokenWithWriteAccess;

extern NSString *const kSRCollectionAttractionID;
extern NSString *const kSRCollectionSpotID;
extern NSString *const kSRCollectionConfigID;
extern NSString *const kSRCollectionPartnersID;

id NilOrValue(id aValue);