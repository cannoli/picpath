//
//  ALAsset+PhotoLib.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/15/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAsset (PhotoLib)
- (NSComparisonResult) compareDate:(ALAsset*)secondAsset;
@end
