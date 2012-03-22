//
//  Storage.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Storage : NSObject

// Get a value from the storage
+ (id)get:(NSString *)key;
+ (id)get:(NSString *)key withDefault:(id)defaultValue;

// Set a value in the storage
+ (void)set:(id)value forKey:(NSString *)key;

@end
