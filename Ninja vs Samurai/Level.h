//
//  Level.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

@property (strong) NSString *name;

// Constructors
+ (Level *)levelWithName:(NSString *)name;
+ (Level *)firstLevelForGroup:(int)group;

// Initialize
- (id)initWithName:(NSString *)name;

// Check if this level belongs to a specific group
- (BOOL)belongsToGroup:(int)group;

// The level filename
- (NSString *)filename;

// The next level after this one
- (Level *)nextLevel;
- (Level *)nextLevelForGroup:(int)group;

@end
