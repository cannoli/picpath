//
//  RouteConfig.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/11/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "RouteConfig.h"

static const float kSecondsPerDay = 60.0f * 60.0f * 24.0f;

@implementation RouteConfig
@synthesize beginDate = _beginDate;
@synthesize endDate = _endDate;

- (id) init
{
    self = [super init];
    if(self)
    {
        self.endDate = [NSDate date];
        self.beginDate = [_endDate dateByAddingTimeInterval:-(kSecondsPerDay * 150.0f)];
        NSLog(@"begin %@; end %@", _beginDate, _endDate);
    }
    return self;
}

- (id) initWithBeginDate:(NSDate*)dateBegin endDate:(NSDate*)dateEnd
{
    self = [super init];
    if(self)
    {
        self.beginDate = dateBegin;
        self.endDate = dateEnd;
    }
    return self;
}


- (void) dealloc
{
    [_endDate release];
    [_beginDate release];
    [super dealloc];
}
@end
