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
#import "MainScene.h"
#import "MapLayer.h"
#import "PauseMenu.h"
#import "SimpleAudioEngine.h"
#import "Storage.h"
#import "UILayer.h"

@implementation GameScene
@synthesize actor = _actor,
            background = _background,
            map = _map,
            ui = _ui,
            level = _level,
            playerScore = _playerScore;

#pragma mark Class Methods

+ (GameScene *)sceneWithLevel:(NSString *)level {
    return [[[self alloc] initWithLevel:level] autorelease];
}

#pragma mark Initialize

- (id)initWithLevel:(NSString *)level {
    if ((self = [self init])) {
        self.level = level;
        GameMap *map = [GameMap tiledMapWithTMXFile:level];
        
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
        self.ui.delegate = self;
        [self addChild:self.ui];

        // Play music
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music-game.mp3" loop:YES];

        // Preload audio effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"kungfu.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"scroll.mp3"];

        // Player score
        NSDictionary *score = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithBool:NO], @"completed",
                               [NSNumber numberWithBool:NO], @"moves",
                               [NSNumber numberWithBool:NO], @"scrolls",
                               nil];
        self.playerScore = [NSMutableDictionary dictionaryWithDictionary:[Storage get:self.level withDefault:score]];
    }
    return self;
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

#pragma mark ActorLayerDelegate

- (void)nextTurn {
    self.ui.moves++;
    [self.ui update];
}

- (void)failed {
    // Flash damange indicator
    [self.ui flashDamage];

    // Play sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"attack.mp3"];

    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];

    // Reset level
    [self.actor reset];
}

- (void)finished {
    // Play sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"kungfu.mp3"];

    // Get score
    BOOL completed = [((NSNumber *)[self.playerScore objectForKey:@"completed"]) boolValue];
    BOOL moves = [((NSNumber *)[self.playerScore objectForKey:@"moves"]) boolValue];
    BOOL scrolls = [((NSNumber *)[self.playerScore objectForKey:@"scrolls"]) boolValue];

    // Show finished menu
    FinishedMenu *finish = [FinishedMenu menuWithDelegate:self completed:completed moves:moves scrolls:scrolls];
    [self addChild:finish];

    // Hide others
    [self hide];

    // Completed
    if (!completed) {
        completed = YES;
        [finish toggleCompletedStarAnimated:YES];
        [self.playerScore setObject:[NSNumber numberWithBool:completed] forKey:@"completed"];
    }

    // Moves
    if (!moves) {
        moves = (self.ui.moves <= self.actor.map.moves);
        if (moves) {
            [finish toggleMovesStarAnimated:YES];
            [self.playerScore setObject:[NSNumber numberWithBool:moves] forKey:@"moves"];
        }
    }

    // Scrolls
    if (!scrolls) {
        scrolls = (self.actor.playerScrolls == self.actor.map.scrolls);
        if (scrolls) {
            [finish toggleScrollsStarAnimated:YES];
            [self.playerScore setObject:[NSNumber numberWithBool:scrolls] forKey:@"scrolls"];
        }
    }

    // Save score
    [Storage set:[NSDictionary dictionaryWithDictionary:self.playerScore] forKey:self.level];
}

- (void)scrollPickup {
    // Play sound effect
    [[SimpleAudioEngine sharedEngine] playEffect:@"scroll.mp3"];
}

#pragma mark FinishedMenuDelegate/PauseMenuDelegate

- (void)nextAction {
    NSString *level = @"testmap.tmx";
    if ([self.level compare:level] == 0) {
        level = @"tinymap.tmx";
    }
    [[CCDirector sharedDirector] replaceScene: [GameScene sceneWithLevel:level]];
}

- (void)quitAction {
    [[CCDirector sharedDirector] replaceScene: [MainScene scene]];
}

- (void)retryAction {
    [self show];
    [self resetAction];
}

- (void)resumeAction {
    self.actor.pause = NO;
    [self show];
}

#pragma mark UILayerDelegate

- (void)pauseAction {
    // Pause game
    self.actor.pause = YES;
    [self hide];

    // Show pause menu
    BOOL completed = [((NSNumber *)[self.playerScore objectForKey:@"completed"]) boolValue];
    BOOL moves = [((NSNumber *)[self.playerScore objectForKey:@"moves"]) boolValue];
    BOOL scrolls = [((NSNumber *)[self.playerScore objectForKey:@"scrolls"]) boolValue];
    PauseMenu *menu = [PauseMenu menuWithDelegate:self completed:completed moves:moves scrolls:scrolls];
    [self addChild:menu];
}

- (void)resetAction {
    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];
    
    // Reset level
    [self.actor reset];
}

#pragma mark NSObject

- (void)dealloc {
    self.actor = nil;
    self.background = nil;
    self.map = nil;
    self.ui = nil;
    self.level = nil;
    self.playerScore = nil;
    [super dealloc];
}

@end
