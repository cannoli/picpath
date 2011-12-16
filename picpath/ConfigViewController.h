//
//  ConfigViewController.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/15/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigSetDelegate.h"

@interface ConfigViewController : UIViewController
@property (nonatomic,retain) NSObject<ConfigSetDelegate>* delegate;

- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
