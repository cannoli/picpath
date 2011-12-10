//
//  AppDelegate.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPModel;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    PPModel* _dataModel;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) PPModel* dataModel;

@end
