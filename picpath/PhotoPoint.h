//
//  PhotoPoint.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/16/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@class CLLocation;
@interface PhotoPoint : NSObject
{
    NSString* const _assetUrl;
    NSDate* _creationDate;
    CLLocation* _location;
}
@property (nonatomic,retain) NSString* const assetUrl;
@property (nonatomic,retain) NSDate* creationDate;
@property (nonatomic,retain) CLLocation* location;

- (id) initWithPhotoAsset:(ALAsset*)photoAsset;

@end
