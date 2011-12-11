//
//  PhotoLib.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

extern NSString* const kPhotoLibGroupsEnumDone;
extern NSString* const kPhotoLibAssetsEnumDone;

@interface PhotoLib : NSObject
{
    // internal
    ALAssetsLibrary* _library;
    NSMutableDictionary* _groups;
    NSMutableDictionary* _groupEnumerationFlags;
    
    // external
    NSMutableArray* _photoArray;
}
@property (nonatomic,retain) ALAssetsLibrary* library;
@property (nonatomic,retain) NSMutableDictionary* groups;
@property (nonatomic,retain) NSMutableDictionary* groupEnumerationFlags;
@property (nonatomic,retain) NSMutableArray* photoArray;

// operations
- (void) enumeratePhotoLibrary;

// singleton
+ (PhotoLib*) getInstance;
+ (void) destroyInstance;
@end
