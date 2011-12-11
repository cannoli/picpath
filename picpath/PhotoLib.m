//
//  PhotoLib.m
//  ;
//
//  Created by Shu Chiun Cheah on 12/10/11.
//  Copyright (c) 2011 GeoloPigs Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoLib.h"

NSString* const kPhotoLibGroupsEnumDone = @"photoLibGroupsEnumDone";
NSString* const kPhotoLibAssetsEnumDone = @"photoLibAssetsEnumDone";

@interface PhotoLib (PrivateMethods)
- (void) groupsEnumerationDone:(NSNotification*)note;
@end

@implementation PhotoLib
@synthesize library = _library;
@synthesize groups = _groups;
@synthesize groupEnumerationFlags = _groupEnumerationFlags;
@synthesize photoArray = _photoArray;

- (id) init
{
    self = [super init];
    if(self)
    {
        _library = [[ALAssetsLibrary alloc] init];
        _groups = [[NSMutableDictionary dictionary] retain];
        _groupEnumerationFlags = [[NSMutableDictionary dictionary] retain];
        _photoArray = [[NSMutableArray array] retain];
        
        // register enumeration notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupsEnumerationDone:) 
                                                     name:kPhotoLibGroupsEnumDone object:nil];

    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_photoArray release];
    [_groupEnumerationFlags release];
    [_groups release];
    [_library release];
    [super dealloc];
}

#pragma mark - operations
- (void) enumeratePhotoLibrary
{
    @synchronized(self)
    {
        [_groups removeAllObjects];
        [_groupEnumerationFlags removeAllObjects];
        [_photoArray removeAllObjects];
    }
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll 
                            usingBlock:^(ALAssetsGroup* group, BOOL* stop){
                                if(group)
                                {
                                    if([group numberOfAssets])
                                    {
                                        @synchronized(self)
                                        {
                                            NSString* groupName = [group valueForProperty:ALAssetsGroupPropertyName];
                                            [_groups setObject:group forKey:groupName];
                                            [_groupEnumerationFlags setObject:[NSNumber numberWithBool:NO] forKey:groupName];
                                        }
                                    }
                                }
                                else
                                {
                                    // done enumeration, post a notification
                                    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibGroupsEnumDone
                                                                                        object:self];
                                }
                            }
                          failureBlock:^(NSError* error){
                              NSLog(@"failed to enumerate photo library with %@", error);
                          }];

    /*
                                        [group enumerateAssetsUsingBlock:^(ALAsset* result, NSUInteger index, BOOL *stop){
                                            if(result)
                                            {
                                                @synchronized(self)
                                                {
                                                    [_photoArray addObject:result];
                                                }
                                                NSLog(@"type %@", [result valueForProperty:ALAssetPropertyType]);
                                                NSLog(@"location %@", [result valueForProperty:ALAssetPropertyLocation]);
                                                NSLog(@"duration %@", [result valueForProperty:ALAssetPropertyDuration]);
                                                NSLog(@"orientation %@", [result valueForProperty:ALAssetPropertyOrientation]);
                                                NSLog(@"date %@", [result valueForProperty:ALAssetPropertyDate]);
                                                NSLog(@"representations %@", [result valueForProperty:ALAssetPropertyRepresentations]);
                                                NSLog(@"urls %@", [result valueForProperty:ALAssetPropertyURLs]);
                                            }
                                        }];
                                    }
                                }
                            }
     */
}

- (void) groupsEnumerationDone:(NSNotification*)note
{
    for(NSString* groupName in _groups)
    {
        ALAssetsGroup* group = [_groups objectForKey:groupName];
        NSLog(@"num assets %d", [group numberOfAssets]);
        NSLog(@"name %@", [group valueForProperty:ALAssetsGroupPropertyName]);
        NSLog(@"type %@", [group valueForProperty:ALAssetsGroupPropertyType]);
        NSLog(@"id %@", [group valueForProperty:ALAssetsGroupPropertyPersistentID]);
        NSLog(@"url %@", [group valueForProperty:ALAssetsGroupPropertyURL]);
    }
    for(NSString* groupName in _groups)
    {
        ALAssetsGroup* group = [_groups objectForKey:groupName];
        if(group)
        {
            [group enumerateAssetsUsingBlock:^(ALAsset* result, NSUInteger index, BOOL *stop){
                if(result)
                {
                    @synchronized(self)
                    {
                        [_photoArray addObject:result];
                    }
                    NSLog(@"type %@", [result valueForProperty:ALAssetPropertyType]);
                    NSLog(@"location %@", [result valueForProperty:ALAssetPropertyLocation]);
                    NSLog(@"duration %@", [result valueForProperty:ALAssetPropertyDuration]);
                    NSLog(@"orientation %@", [result valueForProperty:ALAssetPropertyOrientation]);
                    NSLog(@"date %@", [result valueForProperty:ALAssetPropertyDate]);
                    NSLog(@"representations %@", [result valueForProperty:ALAssetPropertyRepresentations]);
                    NSLog(@"urls %@", [result valueForProperty:ALAssetPropertyURLs]);
                }
                else
                {
                    @synchronized(self)
                    {
                        // end of enum, set flag to YES
                        [_groupEnumerationFlags setObject:[NSNumber numberWithBool:YES] forKey:groupName];
                    }

                    // if all enum done, post notification
                    BOOL postNote = YES;
                    for(NSString* curFlagName in _groupEnumerationFlags)
                    {
                        NSNumber* curFlag = [_groupEnumerationFlags objectForKey:curFlagName];
                        if(![curFlag boolValue])
                        {
                            postNote = NO;
                        }
                    }
                    if(postNote)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibAssetsEnumDone
                                                                        object:self];
                    }
                }
            }];
        }
        else
        {
            @synchronized(self)
            {
                // end of enum, set flag to YES
                [_groupEnumerationFlags setObject:[NSNumber numberWithBool:YES] forKey:groupName];
            }
            
            // if all enum done, post notification
            BOOL postNote = YES;
            for(NSString* curFlagName in _groupEnumerationFlags)
            {
                NSNumber* curFlag = [_groupEnumerationFlags objectForKey:curFlagName];
                if(![curFlag boolValue])
                {
                    postNote = NO;
                }
            }
            if(postNote)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoLibAssetsEnumDone
                                                                    object:self];
            }
        }
    }
}

#pragma mark - singleton
static PhotoLib* singletonInstance = nil;
+ (PhotoLib*) getInstance
{
    @synchronized(self)
	{
		if (!singletonInstance)
		{
			singletonInstance = [[[PhotoLib alloc] init] retain];
		}
	}
	return singletonInstance;
}

+ (void) destroyInstance
{
	@synchronized(self)
	{
		[singletonInstance release];
		singletonInstance = nil;
	}
}

@end
