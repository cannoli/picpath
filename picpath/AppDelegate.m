//
//  AppDelegate.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "SecondViewController.h"
#import "PPModel.h"

@interface AppDelegate (PrivateMethods)
- (void) appInit;
- (void) appShutdown;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

// app variables
@synthesize dataModel = _dataModel;
@synthesize locationManager = _locationManager;

- (void)dealloc
{
    [self appShutdown];
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    [self appInit];

    MapViewController *viewController1; 
    UIViewController *viewController2;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController_iPhone" bundle:nil] autorelease];
        viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPhone" bundle:nil] autorelease];
    } else {
        viewController1 = [[[MapViewController alloc] initWithNibName:@"MapViewController_iPad" bundle:nil] autorelease];
        viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil] autorelease];
    }
    viewController1.dataModel = [self dataModel];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
    self.window.rootViewController = self.tabBarController;
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_dataModel saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [_dataModel saveContext];
    [self appShutdown];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

#pragma mark - app routines
- (void) appInit
{
    self.dataModel = [[PPModel alloc] init];
    
    
    // Start the location manager.
	[[self locationManager] startUpdatingLocation];
    
    // HACK
    /*
    CLLocation *location = [_locationManager location];
	if (location) 
    {
        [self.dataModel addEventWithDate:[NSDate date] location:location];
	}
     */
    // HACK
}

- (void) appShutdown
{
    self.locationManager = nil;
    self.dataModel = nil;
}


#pragma mark - Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager 
{	
    if (_locationManager != nil) 
    {
		return _locationManager;
	}
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager setDelegate:self];
	
	return _locationManager;
}


@end
