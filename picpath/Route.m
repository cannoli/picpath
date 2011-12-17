//
//  Route.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/16/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "Route.h"
#import "PhotoPoint.h"
#import "PathPoint.h"
#import "ALAsset+PhotoLib.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

static const float MIN_DISTANCE = 50.0f;    // meters

@interface Route (PrivateMethods)
- (void) initTimelineWithPhotoArray:(NSArray*)photoArray;
- (void) refreshPathFromTimeline;
- (PathPoint*) closestPathPointToPhoto:(PhotoPoint*)photoAsset;
@end

@implementation Route
@synthesize timeline = _timeline;
@synthesize path = _path;

- (id) initWithPhotoArray:(NSArray*)photoArray
{
    self = [super init];
    if(self)
    {
        _timeline = [[NSMutableArray array] retain];
        _path = [[NSMutableArray array] retain];
        
        NSArray* sortedPhotos = [photoArray sortedArrayUsingSelector:@selector(compareDate:)];
        [self initTimelineWithPhotoArray:sortedPhotos];
        [self refreshPathFromTimeline];
    }
    return self;
}

- (void) dealloc
{
    [_path release];
    [_timeline release];
    [super dealloc];
}


#pragma mark - Private Methods
- (void) initTimelineWithPhotoArray:(NSArray *)photoArray
{
    for(ALAsset* cur in photoArray)
    {
        PhotoPoint* newPoint = [[PhotoPoint alloc] initWithPhotoAsset:cur];
        [_timeline addObject:newPoint];
        [newPoint release];
    }
}


- (void) refreshPathFromTimeline
{
    for(PathPoint* cur in _path)
    {
        [cur removeAllPhotoPoints];
    }
    
    for(PhotoPoint* curPhoto in _timeline)
    {
        PathPoint* closest = [self closestPathPointToPhoto:curPhoto];
        if(closest)
        {
            [closest addPhotoPoint:curPhoto];
        }
        else
        {
            PathPoint* newPoint = [[PathPoint alloc] initWithLocation:[curPhoto location]];
            [_path addObject:newPoint];
            [newPoint addPhotoPoint:curPhoto];
            [newPoint release];
        }
    }
}

- (PathPoint*) closestPathPointToPhoto:(PhotoPoint *)photo
{
    PathPoint* result = nil;
    CLLocation* curLoc = [photo location];
    if(curLoc)
    {
        for(PathPoint* cur in _path)
        {
            if([curLoc distanceFromLocation:[cur location]] <= MIN_DISTANCE)
            {
                result = cur;
                break;
            }
        }
    }
    return result;
}

@end
