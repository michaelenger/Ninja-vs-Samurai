//
//  MapLayer.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "MapLayer.h"
#import "GameMap.h"

@implementation MapLayer
@synthesize map = _map;

#pragma mark Class Methods

+ (MapLayer *)layer {
    return [self node];
}

+ (MapLayer *)layerWithMap:(GameMap *)map {
    return [[[self alloc] initWithMap:map] autorelease];
}

#pragma mark Initialize

- (id)initWithMap:(GameMap *)map {
    if ((self = [self init])) {
        self.map = map;

        // Position in the center
        self.map.position = ccp((self.contentSize.width - self.map.contentSize.width) / 2,
                                (self.contentSize.height - self.map.contentSize.height) / 2);

        [self addChild:self.map];
    }
    return self;
}

#pragma mark NSObject

- (void)dealloc {
    self.map = nil;
    [super dealloc];
}

@end
