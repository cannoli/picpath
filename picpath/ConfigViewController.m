//
//  ConfigViewController.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/15/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import "ConfigViewController.h"
#import "RouteConfig.h"

@implementation ConfigViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (void) dealloc
{
    [_delegate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_delegate release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveButtonPressed:(id)sender
{
    if(_delegate)
    {
        [_delegate configViewController:self newConfig:nil];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if(_delegate)
    {
        [_delegate configViewController:self newConfig:nil];
    }
}

@end
