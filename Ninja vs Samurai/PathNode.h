//
//  PathNode.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathNode : NSObject

@property (assign) CGPoint position;
@property (assign) unsigned int f;
@property (assign) unsigned int g;
@property (assign) unsigned int h;
@property (strong) PathNode *parent;
@property (assign) BOOL wall;

// Constructors
+ (PathNode *)floorWithPosition:(CGPoint)position;
+ (PathNode *)nodeWithPosition:(CGPoint)position;
+ (PathNode *)wallWithPosition:(CGPoint)position;

// Initialize
- (id)initWithPosition:(CGPoint)position;
- (id)initWithPosition:(CGPoint)position wall:(BOOL)wall;

@end
