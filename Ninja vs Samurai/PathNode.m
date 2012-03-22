//
//  PathNode.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "PathNode.h"

@implementation PathNode
@synthesize position = _position,
            f = _f,
            g = _g,
            h = _h,
            parent = _parent,
            wall = _wall;

#pragma mark Class Methods

+ (PathNode *)floorWithPosition:(CGPoint)position {
    return [[[self alloc] initWithPosition:position wall:NO] autorelease];
}

+ (PathNode *)nodeWithPosition:(CGPoint)position {
    return [[[self alloc] initWithPosition:position] autorelease];
}

+ (PathNode *)wallWithPosition:(CGPoint)position {
    return [[[self alloc] initWithPosition:position wall:YES] autorelease];
}

#pragma mark Initialize

- (id)initWithPosition:(CGPoint)position {
    if ((self = [self init])) {
        self.position = position;
    }
    return self;
}

- (id)initWithPosition:(CGPoint)position wall:(BOOL)wall {
    if ((self = [self initWithPosition:position])) {
        self.wall = wall;
    }
    return self;
}

#pragma mark NSObject

- (void)dealloc {
    self.parent = nil;
    [super dealloc];
}

- (id)init {
    if ((self = [super init])) {
        self.position = CGPointMake(-1,-1);
        self.f = 0;
        self.g = 0;
        self.h = 0;
        self.parent = nil;
        self.wall = NO;
    }
    return self;
}

@end
