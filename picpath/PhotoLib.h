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
extern NSString* const kPhotoLibNewNoteAdded;

@class MKMapView;
@interface PhotoLib : NSObject
{
    // internal
    ALAssetsLibrary* _library;
    NSMutableDictionary* _groups;
    NSMutableDictionary* _groupEnumerationFlags;
    
    // enumerator internals
    MKMapView* _enumeratorTargetMapView;
    NSDate* _beginDate;
    NSDate* _endDate;
    
    // external
    NSMutableArray* _photoArray;
}
@property (nonatomic,retain) ALAssetsLibrary* library;
@property (nonatomic,retain) NSMutableDictionary* groups;
@property (nonatomic,retain) NSMutableDictionary* groupEnumerationFlags;

@property (nonatomic,retain) MKMapView* enumeratorTargetMapView;
@property (nonatomic,retain) NSDate* beginDate;
@property (nonatomic,retain) NSDate* endDate;
@property (nonatomic,retain) NSMutableArray* photoArray;

// operations
- (void) enumeratePhotoLibraryForDateRange:(NSDate*)beginDate:(NSDate*)endDate;
- (void) mapView:(MKMapView*)mapView performEnumForDateRange:(NSDate*)beginDate:(NSDate*)endDate;
- (void) dropPathPointForPhotoAsset:(ALAsset*)photoAsset;


// singleton
+ (PhotoLib*) getInstance;
+ (void) destroyInstance;
@end
