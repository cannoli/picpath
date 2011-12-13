//
//  MapViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKMapView.h>

@class MKMapView;
@class PPModel;
@class RouteConfig;
@interface MapViewController : UIViewController<MKMapViewDelegate>
{
    PPModel* _dataModel;
    RouteConfig* _curRouteConfig;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) PPModel* dataModel;
@property (nonatomic,retain) RouteConfig* curRouteConfig;

@end
