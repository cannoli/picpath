//
//  MapViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView;

@interface MapViewController : UIViewController
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@end
