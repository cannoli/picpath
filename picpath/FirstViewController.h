//
//  FirstViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKMapView;

@interface FirstViewController : UIViewController
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@end
