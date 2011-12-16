//
//  PathPoint.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>

@interface PathPoint : NSObject<MKAnnotation>
{
    CLLocation* _location;
    unsigned int _index;
}
@property (nonatomic,retain) CLLocation* location;
@property (nonatomic,assign) unsigned int index;
- (id) initWithLocation:(CLLocation*)location;

@end
