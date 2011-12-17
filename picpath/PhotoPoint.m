//
//  PhotoPoint.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/16/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "PhotoPoint.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoPoint
@synthesize assetUrl = _assetUrl;
@synthesize creationDate = _creationDate;
@synthesize location = _location;

- (id) initWithPhotoAsset:(ALAsset*)photoAsset
{
    self = [super init];
    if(self)
    {
        NSDictionary* urls = [photoAsset valueForProperty:ALAssetPropertyURLs];
        self.assetUrl = [urls objectForKey:[[photoAsset defaultRepresentation] UTI]];
        self.creationDate = [photoAsset valueForProperty:ALAssetPropertyDate];
        self.location = [photoAsset valueForProperty:ALAssetPropertyLocation];
    }
    return self;
}

- (void) dealloc
{
    self.location = nil;
    self.creationDate = nil;
    self.assetUrl = nil;
    [super dealloc];
}
@end
