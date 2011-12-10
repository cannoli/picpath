//
//  Event.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "Event.h"


@implementation Event

@dynamic date;
@dynamic latitude;
@dynamic longitude;

#pragma mark - MKAnnotation delegate
- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D result = CLLocationCoordinate2DMake([[self latitude] floatValue], [[self longitude] floatValue]);
    return result;
}


@end
