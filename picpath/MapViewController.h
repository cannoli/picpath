//
//  MapViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>
#import "ConfigSetDelegate.h"

@class MKMapView;
@class PPModel;
@class RouteConfig;
@class Route;
@interface MapViewController : UIViewController<MKMapViewDelegate,ConfigSetDelegate>
{
    PPModel* _dataModel;
    RouteConfig* _curRouteConfig;
    Route* _curRoute;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) PPModel* dataModel;
@property (nonatomic,retain) RouteConfig* curRouteConfig;
@property (nonatomic,retain) Route* curRoute;

- (IBAction)configNewPath:(id)sender;
- (IBAction)refreshCurRoute:(id)sender;
@end
