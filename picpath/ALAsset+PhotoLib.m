//
//  ALAsset+PhotoLib.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/15/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "ALAsset+PhotoLib.h"

@implementation ALAsset (PhotoLib)
- (NSComparisonResult) compareDate:(ALAsset*)secondAsset
{
    NSDate* myDate = [self valueForProperty:ALAssetPropertyDate];
    NSDate* theirDate = [secondAsset valueForProperty:ALAssetPropertyDate];
    NSComparisonResult result = [myDate compare:theirDate];
    return result;
}

@end
