//
//  ConfigSetDelegate.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/15/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConfigViewController;
@class RouteConfig;
@protocol ConfigSetDelegate <NSObject>
- (void) configViewController:(ConfigViewController*)configViewController newConfig:(RouteConfig*)newConfig;
@end
