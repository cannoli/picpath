//
//  PathPoint.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "PathPoint.h"

@implementation PathPoint
@synthesize location = _location;

- (id) initWithLocation:(CLLocation*)location
{
    self = [super init];
    if(self)
    {
        _location = [location retain];
    }
    return self;
}

- (void) dealloc
{
    [_location release];
    [super dealloc];
}

#pragma mark - MKAnnotation delegate
- (CLLocationCoordinate2D) coordinate
{
    return [_location coordinate];
}

@end
