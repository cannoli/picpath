//
//  MapViewController.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Event.h"
#import "PPModel.h"
#import "PhotoLib.h"
#import "PathPoint.h"
#import "RouteConfig.h"
#import "ConfigViewController.h"
#import "ALAsset+PhotoLib.h"

@interface MapViewController (PrivateMethods)
- (void) photoLibEnumerationDone:(NSNotification*)note;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize dataModel = _dataModel;
@synthesize curRouteConfig = _curRouteConfig;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        _dataModel = nil;
        _curRouteConfig = [[RouteConfig alloc] init];
    }
    return self;
}

- (void)dealloc 
{
    [_curRouteConfig release];
    [_dataModel release];
    [_mapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - photo library operations
- (void) photoLibEnumerationDone:(NSNotification*)note
{   
    NSMutableArray* photos = [[PhotoLib getInstance] photoArray];
    [photos sortUsingSelector:@selector(compareDate:)];
    unsigned int index = 0;
    for(ALAsset* curPhoto in photos)
    {
        CLLocation* curLoc = [curPhoto valueForProperty:ALAssetPropertyLocation];
        if(curLoc)
        {
            PathPoint* curPoint = [[PathPoint alloc] initWithLocation:curLoc];
            curPoint.index = index;
            //MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance([[curPoint location] coordinate], 100.0f, 100.0f);
            //[_mapView setRegion:newRegion animated:YES];
            [_mapView addAnnotation:curPoint];

            [curPoint release];
            ++index;
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray* events = [_dataModel fetchEvents];
    if([events count])
    {
        Event* curEvent = [events objectAtIndex:0];
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[curEvent latitude] floatValue], [[curEvent longitude] floatValue]), 5000.0f, 5000.0f);
        [_mapView setRegion:newRegion animated:YES];
        [_mapView addAnnotation:curEvent];
    }
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mapView setDelegate:nil];
    [self setDataModel:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_mapView setDelegate:nil];
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - button actions
- (IBAction)configNewPath:(id)sender
{
    ConfigViewController* newController = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
    newController.delegate = self;
    [self presentModalViewController:newController animated:YES];
    [newController release];
}

- (IBAction)refreshCurRoute:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoLibEnumerationDone:) 
                                                 name:kPhotoLibAssetsEnumDone object:nil];
    [[PhotoLib getInstance] enumeratePhotoLibraryForDateRange:[_curRouteConfig beginDate] :[_curRouteConfig endDate]];

//    [[PhotoLib getInstance] mapView:_mapView performEnumForDateRange:[_curRouteConfig beginDate]:[_curRouteConfig endDate]];
//    NSMutableArray* photoArray = [[PhotoLib getInstance] photoArray];
//    [photoArray sortUsingSelector:@selector(compareDate:)];
//    for(ALAsset* cur in photoArray)
//    {
//        [[PhotoLib getInstance] dropPathPointForPhotoAsset:cur];
//    }
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    /*
    if(USERLOCATEDCOUNT_MAX > userLocatedCount)
    {
        // move the map to user's location
        CLLocation* userLoc = mapView.userLocation.location;
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(userLoc.coordinate, 100.0f, 100.0f);
        [mapView setRegion:newRegion animated:YES]; 
        self.parkedLocation = userLoc;
        ++userLocatedCount;
    }
     */
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    /*
    if((userLocatedCount) || (mapView.userLocationVisible))
    {
        // drop the pin
        [mapView addAnnotation:self];
        NSLog(@"drop pin");
    } 
     */
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView* result = nil;
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        result = nil;
    }
    else
    {
        // Handle any custom annotations.
        if ([annotation isKindOfClass:[PathPoint class]])
        {
            result = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PathPoint"];
            if(nil == result)
            {
                MKPinAnnotationView* newPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PathPoint"];
                newPin.animatesDrop = YES;
                newPin.canShowCallout = YES;
                result = newPin;
                //NSLog(@"new pin");
            }
            else
            {
                //NSLog(@"reused");
            }
        }
    }
    return result;
}


#pragma mark - ConfigSetDelegate
- (void) configViewController:(ConfigViewController *)configViewController newConfig:(RouteConfig *)newConfig
{
    if(newConfig)
    {
        // process new config
    }
    else
    {
        RouteConfig* defaultRouteConfig = [[RouteConfig alloc] init];
        self.curRouteConfig = defaultRouteConfig;
        [defaultRouteConfig release];
    }
    [self dismissModalViewControllerAnimated:YES];
}



@end
