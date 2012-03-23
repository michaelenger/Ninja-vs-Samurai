//
//  Settings.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Settings.h"
#import "Storage.h"

@interface Settings (Private)

// Store the settings
- (void)store;

@end

@implementation Settings

static Settings *_instance = nil;
NSMutableDictionary *_settings = nil;

#pragma mark Class Methods

+ (Settings *)instance {
    @synchronized(self)
    {
        if (_instance == nil)
            _instance = [[self alloc] init];
    }
    
    return(_instance);
}

#pragma mark Instance Methods

- (id)get:(NSString *)key {
    return [_settings objectForKey:key];
}

- (void)set:(id)value forKey:(NSString *)key {
    [_settings setObject:value forKey:key];
    [self store];
}

- (void)store {
    [Storage set:[NSDictionary dictionaryWithDictionary:_settings] forKey:@"settings"];
}

#pragma mark Getters & Setters

- (BOOL)effects {
    NSNumber *effects = (NSNumber *)[self get:@"effects"];
    return [effects boolValue];
}

- (void)setEffects:(BOOL)effects {
    [self set:[NSNumber numberWithBool:effects] forKey:@"effects"];
}

- (BOOL)music {
    NSNumber *music = (NSNumber *)[self get:@"music"];
    return [music boolValue];
}

- (void)setMusic:(BOOL)music {
    [self set:[NSNumber numberWithBool:music] forKey:@"music"];
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Setup defaults
        _settings = [[NSMutableDictionary dictionaryWithDictionary:[Storage get:@"settings" withDefault:[NSDictionary dictionary]]] retain];
        if (![_settings objectForKey:@"effects"]) {
            [_settings setObject:[NSNumber numberWithBool:YES] forKey:@"effects"];
        }
        if (![_settings objectForKey:@"music"]) {
            [_settings setObject:[NSNumber numberWithBool:YES] forKey:@"music"];
        }
        [self store];
    }
    return self;
}

- (void)dealloc {
    [_instance release];
    [_settings release];
    [super dealloc];
}

@end
