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
#import "FinishedMenu.h"
#import "GameMap.h"
#import "MapLayer.h"
#import "Storage.h"
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

#pragma mark Instance Methods

- (void)hide {
    [self removeChild:self.actor cleanup:NO];
    [self removeChild:self.map cleanup:NO];
    [self removeChild:self.ui cleanup:NO];
}

- (void)show {
    [self addChild:self.map];
    [self addChild:self.actor];
    [self addChild:self.ui];
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
    // Get score
    NSMutableDictionary *score = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:1], @"completed",
                                    [NSNumber numberWithInt:self.ui.moves], @"moves",
                                    [NSNumber numberWithInt:self.actor.playerScrolls], @"scrolls",
                                    [NSNumber numberWithInt:0], @"100%",nil];
    NSMutableDictionary *savedScore = [Storage get:@"testmap.tmx"];
    BOOL complete = YES;

    // Show finished menu
    FinishedMenu *finish = [FinishedMenu menuWithDelegate:self];
    [self addChild:finish];
    
    // Completed star
    if (savedScore && [((NSNumber *)[savedScore objectForKey:@"completed"]) intValue] == 1) {
        [finish toggleCompletedStarAnimated:NO];
    } else {
        [finish toggleCompletedStarAnimated:YES];
    }
    
    // Moves star
    unsigned int moves = self.actor.map.moves;
    if (savedScore && [((NSNumber *)[savedScore objectForKey:@"moves"]) intValue] <= moves) {
        [finish toggleMovesStarAnimated:NO];
    } else if ([((NSNumber *)[score objectForKey:@"moves"]) intValue] <= moves) {
        [finish toggleMovesStarAnimated:YES];
    } else {
        complete = NO;
    }
    
    // Scrolls star
    unsigned int scrolls = self.actor.map.scrolls;
    if (savedScore && [((NSNumber *)[savedScore objectForKey:@"scrolls"]) intValue] == scrolls) {
        [finish toggleScrollsStarAnimated:NO];
    } else if ([((NSNumber *)[score objectForKey:@"scrolls"]) intValue] == scrolls) {
        [finish toggleScrollsStarAnimated:YES];
    } else {
        complete = NO;
    }

    // Save score
    if (savedScore) {
        // Moves
        if ([((NSNumber *)[savedScore objectForKey:@"moves"]) intValue] < [((NSNumber *)[score objectForKey:@"moves"]) intValue]) {
            [score setObject:[savedScore objectForKey:@"moves"] forKey:@"moves"];
        }
        // Scrolls
        if ([((NSNumber *)[savedScore objectForKey:@"scrolls"]) intValue] > [((NSNumber *)[score objectForKey:@"scrolls"]) intValue]) {
            [score setObject:[savedScore objectForKey:@"scrolls"] forKey:@"scrolls"];
        }
    }
    if (complete) {
        [score setObject:[NSNumber numberWithInt:1] forKey:@"100%"];
    }
    [Storage set:score forKey:@"testmap.tmx"];

    // Hide others
    [self hide];
}

#pragma mark FinishedMenuDelegate

- (void)replayAction {
    [self show];

    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];
    
    // Reset level
    [self.actor reset];
}

- (void)nextAction {
    // @todo
    [self replayAction];
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
