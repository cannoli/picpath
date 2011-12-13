//
//  RouteConfig.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/11/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteConfig : NSObject
{
    NSDate* _beginDate;
    NSDate* _endDate;
}
@property (nonatomic,retain) NSDate* beginDate;
@property (nonatomic,retain) NSDate* endDate;

- (id) initWithBeginDate:(NSDate*)dateBegin endDate:(NSDate*)dateEnd;

@end
