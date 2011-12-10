//
//  MapViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView;
@class PPModel;
@interface MapViewController : UIViewController
{
    PPModel* _dataModel;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) PPModel* dataModel;
@end
