//
//  PathPoint.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "PathPoint.h"
#import "PhotoPoint.h"

@implementation PathPoint
@synthesize location = _location;
@synthesize index = _index;
@synthesize photos = _photos;

- (id) initWithLocation:(CLLocation*)location
{
    self = [super init];
    if(self)
    {
        _location = [location retain];
        _index = 0;
        _photos = [[NSMutableArray array] retain];
    }
    return self;
}

- (void) dealloc
{
    [_photos release];
    [_location release];
    [super dealloc];
}

- (void) addPhotoPoint:(PhotoPoint *)photoPoint
{
    [_photos addObject:photoPoint];
}

- (void) removePhotoPoints:(PhotoPoint*)photoPoint
{
    [_photos removeObject:photoPoint];
}

- (void) removeAllPhotoPoints
{
    [_photos removeAllObjects];
}

#pragma mark - MKAnnotation delegate
- (CLLocationCoordinate2D) coordinate
{
    return [_location coordinate];
}

- (NSString*) title
{
    return [NSString stringWithFormat:@"%d",_index];
}

@end
