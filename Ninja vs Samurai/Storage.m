//
//  Storage.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Storage.h"

@implementation Storage

#pragma mark Class Methods

+ (id)get:(NSString *)key {
    return [self get:key withDefault:nil];
}

+ (id)get:(NSString *)key withDefault:(id)defaultValue {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    id value = nil;
	
	if (standardUserDefaults) {
		value = [standardUserDefaults objectForKey:key];
    }
    
    if (!value) {
        value = defaultValue;
    }
	
	return value;
}

+ (void)set:(id)value forKey:(NSString *)key {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
	}
}

@end
