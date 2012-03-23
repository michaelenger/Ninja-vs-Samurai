//
//  Settings.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

// Get instance of this class
+ (Settings *)instance;

// Basic getters/setters
- (id)get:(NSString *)key;
- (void)set:(id)value forKey:(NSString *)key;

// Helper getters/setters for specific settings
- (BOOL)effects;
- (void)setEffects:(BOOL)effects;
- (BOOL)music;
- (void)setMusic:(BOOL)music;

@end
