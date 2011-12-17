//
//  Route.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/16/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PathPoint;
@interface Route : NSObject
{
    NSMutableArray* _timeline;
    NSMutableArray* _path;
}
@property (nonatomic,retain) NSMutableArray* timeline;
@property (nonatomic,retain) NSMutableArray* path;
- (id) initWithPhotoArray:(NSArray*)photoArray;

@end
