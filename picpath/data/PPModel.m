//
//  PPModel.m
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 GeoloPigs. All rights reserved.
//

#import <UIKit/UIManagedDocument.h>
#import "PPModel.h"
#import "Event.h"
#import "Photo.h"

static NSString* const PERSISTENTSTORE_NAME = @"PicPath.sqlite";

@interface PPModel (PrivateMethods)
+ (NSString *)applicationDocumentsDirectory;
@end

@implementation PPModel

- (id) init
{
    self = [super init];
    if(self)
    {
        // create the object-model and context (persistent-store created when context is created)
        [self managedObjectModel];
        [self managedObjectContext];
    }
    return self;
}

- (void) dealloc
{
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return _managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[PPModel applicationDocumentsDirectory] stringByAppendingPathComponent:PERSISTENTSTORE_NAME]];
	
	NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
	// Allow inferred migration from the original version of the application.
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
	
	if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
        // Handle the error.
    }    
	
    return _persistentStoreCoordinator;
}

#pragma mark - operations
- (void)saveContext {
    
    NSError *error = nil;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    

- (void) addEventWithDate:(NSDate*)eventDate location:(CLLocation*)eventLoc
{
	Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:_managedObjectContext];
	CLLocationCoordinate2D coordinate = [eventLoc coordinate];
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	[event setDate:eventDate];

    // Commit the change.
	NSError *error = nil;
	if (![_managedObjectContext save:&error]) 
    {
		// Handle the error.
	}
}

- (NSMutableArray*) fetchEvents
{
	/*
	 Fetch existing events.
	 Create a fetch request, add a sort descriptor, then execute the fetch.
	 */
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:_managedObjectContext];
	[request setEntity:entity];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	[request release];        
    return [mutableFetchResults autorelease];
}

- (void) addPhotoAsset:(ALAsset *)photoAsset
{
    Photo *photo = (Photo*)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:_managedObjectContext];
    NSDictionary* urls = [photoAsset valueForProperty:ALAssetPropertyURLs];
    [photo setUrl:[urls objectForKey:[[photoAsset defaultRepresentation] UTI]]];
    [photo setDate:[photoAsset valueForProperty:ALAssetPropertyDate]];
    
    // Commit the change.
	NSError *error = nil;
	if (![_managedObjectContext save:&error]) 
    {
		// Handle the error.
	}
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
+ (NSString *)applicationDocumentsDirectory 
{
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}



@end
