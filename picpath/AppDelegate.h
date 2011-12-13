//
//  AppDelegate.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class PPModel;
@class RouteConfig;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>
{
    PPModel* _dataModel;
    CLLocationManager *_locationManager;
    
    // app state
    RouteConfig* _curRouteConfig;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) PPModel* dataModel;
@property (nonatomic,retain) CLLocationManager* locationManager;
@property (nonatomic,retain) RouteConfig* curRouteConfig;

@end
