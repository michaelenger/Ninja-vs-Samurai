//
//  GameScene.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "GameScene.h"
#import "ActorLayer.h"
#import "BackgroundLayer.h"
#import "GameMap.h"
#import "MapLayer.h"
#import "UILayer.h"

@implementation GameScene
@synthesize actor = _actor,
            background = _background,
            map = _map,
            ui = _ui;

#pragma mark Class Methods

+ (GameScene *)scene {
    return [self node];
}

#pragma mark ActorDelegate

- (void)nextTurn {
    self.ui.moves++;
    [self.ui update];
}

- (void)failed {
    // Flash damange indicator
    [self.ui flashDamage];

    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];

    // Reset level
    [self.actor reset];
}

- (void)finished {
    // @todo: show finish screen

    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];
    
    // Reset level
    [self.actor reset];
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        GameMap *map = [[GameMap tiledMapWithTMXFile:@"testmap.tmx"] retain];
        
        // Background
        self.background = [BackgroundLayer layer];
        [self addChild:self.background];
        
        // Map
        self.map = [MapLayer layerWithMap:map];
        [self addChild:self.map];
        
        // Actors
        self.actor = [ActorLayer layerWithMap:map];
        self.actor.delegate = self;
        [self addChild:self.actor];
        
        // UI
        self.ui = [UILayer layer];
        [self addChild:self.ui];
        
        [map release];
    }
    return self;
}

- (void)dealloc {
    self.actor = nil;
    self.background = nil;
    self.map = nil;
    self.ui = nil;
    [super dealloc];
}

@end
