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

@interface MapViewController (PrivateMethods)
- (void) photoLibEnumerationDone:(NSNotification*)note;
@end

@implementation MapViewController
@synthesize mapView = _mapView;
@synthesize dataModel = _dataModel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)dealloc 
{
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
    for(ALAsset* curPhoto in photos)
    {
        CLLocation* curLoc = [curPhoto valueForProperty:ALAssetPropertyLocation];
        NSLog(@"curLoc %@", curLoc);
        if(curLoc)
        {
            PathPoint* curPoint = [[PathPoint alloc] initWithLocation:curLoc];
            //MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance([[curPoint location] coordinate], 100.0f, 100.0f);
            //[_mapView setRegion:newRegion animated:YES];
            [_mapView addAnnotation:curPoint];

            [curPoint release];
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
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([[curEvent latitude] floatValue], [[curEvent longitude] floatValue]), 100.0f, 100.0f);
        [_mapView setRegion:newRegion animated:YES];
        [_mapView addAnnotation:curEvent];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoLibEnumerationDone:) 
                                                 name:kPhotoLibAssetsEnumDone object:nil];
    [[PhotoLib getInstance] enumeratePhotoLibrary];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setDataModel:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


@end
