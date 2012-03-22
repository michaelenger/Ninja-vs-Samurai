//
//  Path.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@interface Path : NSObject

@property (strong) NSArray *nodes;

// Constructor
+ (Path *)pathWithMap:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination;

// Initialize
- (id)initWithMap:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination;

@end
