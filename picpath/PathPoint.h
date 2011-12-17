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

@class PhotoPoint;
@interface PathPoint : NSObject<MKAnnotation>
{
    CLLocation* _location;
    unsigned int _index;
    NSMutableArray* _photos;
}
@property (nonatomic,retain) CLLocation* location;
@property (nonatomic,assign) unsigned int index;
@property (nonatomic,retain) NSMutableArray* photos;

- (id) initWithLocation:(CLLocation*)location;
- (void) addPhotoPoint:(PhotoPoint*)photoPoint;
- (void) removePhotoPoints:(PhotoPoint*)photoPoint;
- (void) removeAllPhotoPoints;
@end
