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

// Constructor
+ (Level *)levelWithName:(NSString *)name;

// Initialize
- (id)initWithName:(NSString *)name;

// The level filename
- (NSString *)filename;

// The next level after this one
- (Level *)nextLevel;

@end
