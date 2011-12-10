//
//  PPModel.h
//  picpath
//
//  Created by Shu Chiun Cheah on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PPModel : NSObject
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;	    
}
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) saveContext;
- (void) addEventWithDate:(NSDate*)eventDate location:(CLLocation*)eventLoc;
- (NSMutableArray*) fetchEvents;
@end
