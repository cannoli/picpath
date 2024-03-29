//
//  PhotoLib.m
//  ;
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKMapView.h>
#import "NSNotificationCenter+MainThread.h"
#import "PhotoLib.h"
#import "PathPoint.h"

NSString* const kPhotoLibGroupsEnumDone = @"photoLibGroupsEnumDone";
NSString* const kPhotoLibAssetsEnumDone = @"photoLibAssetsEnumDone";
NSString* const kPhotoLibNewNoteAdded = @"photoLibNewNoteAdded";

@interface PhotoLib (PrivateMethods)
- (void) groupsEnumerationDone:(NSNotification*)note;
- (void) enumerateToMapView;
@end

@implementation PhotoLib
@synthesize library = _library;
@synthesize groups = _groups;
@synthesize groupEnumerationFlags = _groupEnumerationFlags;

@synthesize enumeratorTargetMapView = _enumeratorTargetMapView;
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;

@synthesize photoArray = _photoArray;

- (id) init
{
    self = [super init];
    if(self)
    {
        _library = [[ALAssetsLibrary alloc] init];
        _groups = [[NSMutableDictionary dictionary] retain];
        _groupEnumerationFlags = [[NSMutableDictionary dictionary] retain];
        _enumeratorTargetMapView = nil;
        _beginDate = nil;
        _endDate = nil;
        _photoArray = [[NSMutableArray array] retain];
        
        // register enumeration notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsEnumerationDone:) 
                                                     name:kPhotoLibGroupsEnumDone object:nil];

    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_photoArray release];
    [_endDate release];
    [_beginDate release];
    [_enumeratorTargetMapView release];
    [_groupEnumerationFlags release];
    [_groups release];
    [_library release];
    [super dealloc];
}

#pragma mark - operations

- (void) filterPhoto:(ALAsset*)photoAsset inDateRange:(NSDate*)beginDate:(NSDate*)endDate
{
    if(ALAssetTypePhoto == [photoAsset valueForProperty:ALAssetPropertyType])
    {
        NSDate* photoDate = [photoAsset valueForProperty:ALAssetPropertyDate];
        NSComparisonResult beginResult = [photoDate compare:beginDate];
        NSComparisonResult endResult = [photoDate compare:endDate];
        if(((NSOrderedSame == beginResult) || (NSOrderedDescending == beginResult)) &&
           ((NSOrderedSame == endResult) || (NSOrderedAscending == endResult)))
        {
            @synchronized(self)
            {
                [_photoArray addObject:photoAsset];
            }
            //            [self performSelectorOnMainThread:@selector(dropPathPointForPhotoAsset:) withObject:photoAsset waitUntilDone:NO];
        }
    }
}

- (void) enumeratePhotoLibraryForDateRange:(NSDate *)beginDate :(NSDate *)endDate
{
    @synchronized(self)
    {
        [_groups removeAllObjects];
        [_groupEnumerationFlags removeAllObjects];
        [_photoArray removeAllObjects];
    }
    self.beginDate = beginDate;
    self.endDate = endDate;
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll 
                            usingBlock:^(ALAssetsGroup* group, BOOL* stop){
                                if(group)
                                {
                                    if([group numberOfAssets])
                                    {
                                        @synchronized(self)
                                        {
                                            NSString* groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                            [_groups setObject:group forKey:groupName];
                                            [_groupEnumerationFlags setObject:[NSNumber numberWithBool:NO] forKey:groupName];
                                        }
                                    }
                                }
                                else
                                {
                                    // done enumeration, post a notification
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibGroupsEnumDone
                                                                                        object:self];
                                }
                            }
                          failureBlock:^(NSError* error){
                              NSLog(@"failed to enumerate photo library with %@", error);
                          }];
}

- (void) groupsEnumerationDone:(NSNotification*)note
{
    for(NSString* groupName in _groups)
    {
        ALAssetsGroup* group = [_groups objectForKey:groupName];
        if(group)
        {
            [group enumerateAssetsUsingBlock:^(ALAsset* result, NSUInteger index, BOOL *stop){
                if(result)
                {
                    [self filterPhoto:result inDateRange:[self beginDate] :[self endDate]];
                }
                else
                {
                    @synchronized(self)
                    {
                        // end of enum, set flag to YES
                        [_groupEnumerationFlags setObject:[NSNumber numberWithBool:YES] forKey:groupName];
                    }

                    // if all enum done, post notification
                    BOOL postNote = YES;
                    for(NSString* curFlagName in _groupEnumerationFlags)
                    {
                        NSNumber* curFlag = [_groupEnumerationFlags objectForKey:curFlagName];
                        if(![curFlag boolValue])
                        {
                            postNote = NO;
                        }
                    }
                    if(postNote)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibAssetsEnumDone
                                                                        object:self];
                    }
                }
            }];
        }
        else
        {
            @synchronized(self)
            {
                // end of enum, set flag to YES
                [_groupEnumerationFlags setObject:[NSNumber numberWithBool:YES] forKey:groupName];
            }
            
            // if all enum done, post notification
            BOOL postNote = YES;
            for(NSString* curFlagName in _groupEnumerationFlags)
            {
                NSNumber* curFlag = [_groupEnumerationFlags objectForKey:curFlagName];
                if(![curFlag boolValue])
                {
                    postNote = NO;
                }
            }
            if(postNote)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibAssetsEnumDone
                                                                    object:self];
            }
        }
    }
}

- (void) dropPathPointForPhotoAsset:(ALAsset*)photoAsset
{
    if(ALAssetTypePhoto == [photoAsset valueForProperty:ALAssetPropertyType])
    {/*
        NSLog(@"type %@", [photoAsset valueForProperty:ALAssetPropertyType]);
        NSLog(@"location %@", [photoAsset valueForProperty:ALAssetPropertyLocation]);
        NSLog(@"duration %@", [photoAsset valueForProperty:ALAssetPropertyDuration]);
        NSLog(@"orientation %@", [photoAsset valueForProperty:ALAssetPropertyOrientation]);
        NSLog(@"date %@", [photoAsset valueForProperty:ALAssetPropertyDate]);
        NSLog(@"representations %@", [photoAsset valueForProperty:ALAssetPropertyRepresentations]);*/
       // NSLog(@"urls %@", [photoAsset valueForProperty:ALAssetPropertyURLs]);
       
        CLLocation* curLoc = [photoAsset valueForProperty:ALAssetPropertyLocation];
        //NSLog(@"curLoc %@", curLoc);
        if(curLoc)
        {
            PathPoint* curPoint = [[PathPoint alloc] initWithLocation:curLoc];
            //MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance([[curPoint location] coordinate], 100.0f, 100.0f);
            //[_mapView setRegion:newRegion animated:YES];
            
            //@synchronized(_enumeratorTargetMapView)
            {
                [_enumeratorTargetMapView addAnnotation:curPoint];
                //[[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibAssetsEnumDone
                //                                                    object:self];
            }
            
            [curPoint release];
        }
    }
}

- (void) enumerateToMapView
{
    @autoreleasepool {
        [_library enumerateGroupsWithTypes:ALAssetsGroupAll 
                                usingBlock:^(ALAssetsGroup* group, BOOL* stop){
                                    if(group && [group numberOfAssets])
                                    {
                                        [group enumerateAssetsUsingBlock:^(ALAsset* result, NSUInteger index, BOOL *stop){
                                            if(result)
                                            {
                                                [self filterPhoto:result inDateRange:[self beginDate] :[self endDate]];
                                            }
                                        }];
                                    }
                                }
                              failureBlock:^(NSError* error){
                                  NSLog(@"failed to enumerate photo library with %@", error);
                              }];
    }
}

- (void) mapView:(MKMapView*)mapView performEnumForDateRange:(NSDate*)beginDate:(NSDate*)endDate
{
    [_photoArray removeAllObjects];
    self.enumeratorTargetMapView = mapView;
    self.beginDate = beginDate;
    self.endDate = endDate;
//    [self performSelectorInBackground:@selector(enumerateToMapView) withObject:nil];
    [self enumerateToMapView];
}

#pragma mark - singleton
static PhotoLib* singletonInstance = nil;
+ (PhotoLib*) getInstance
{
    @synchronized(self)
	{
		if (!singletonInstance)
		{
			singletonInstance = [[[PhotoLib alloc] init] retain];
		}
	}
	return singletonInstance;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		[singletonInstance release];
		singletonInstance = nil;
	}
}

@end
