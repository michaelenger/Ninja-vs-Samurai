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
#import "Level.h"
#import "MainScene.h"
#import "MapLayer.h"
#import "PauseMenu.h"
#import "Scores.h"
#import "Settings.h"
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

+ (GameScene *)sceneWithLevel:(Level *)level {
    return [[[self alloc] initWithLevel:level] autorelease];
}

#pragma mark Initialize

- (id)initWithLevel:(Level *)level {
    if ((self = [self init])) {
        self.level = level;
        GameMap *map = [GameMap tiledMapWithTMXFile:level.filename];
        
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
        if ([Settings instance].music) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music-game.mp3" loop:YES];
        }

        // Preload audio effects
        if ([Settings instance].effects) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"attack.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"kungfu.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"scroll.mp3"];
        }

        // Player score
        self.playerScore = [Scores scoresForLevel:level];
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
    if ([Settings instance].effects) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"attack.mp3"];
    }

    // Reset moves count
    self.ui.moves = 0;
    [self.ui update];

    // Reset level
    [self.actor reset];
}

- (void)finished {
    // Play sound effect
    if ([Settings instance].effects) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"kungfu.mp3"];
    }

    // Show finished menu
    FinishedMenu *finish = [FinishedMenu menuWithDelegate:self completed:self.playerScore.completed moves:self.playerScore.moves scrolls:self.playerScore.scrolls];
    [self addChild:finish];

    // Hide others
    [self hide];

    // Completed
    if (!self.playerScore.completed) {
        self.playerScore.completed = YES;
        [finish toggleCompletedStarAnimated:YES];
    }

    // Moves
    if (!self.playerScore.moves) {
        self.playerScore.moves = (self.ui.moves <= self.actor.map.moves);
        if (self.playerScore.moves) {
            [finish toggleMovesStarAnimated:YES];
        }
    }

    // Scrolls
    if (!self.playerScore.scrolls) {
        self.playerScore.scrolls = (self.actor.playerScrolls == self.actor.map.scrolls);
        if (self.playerScore.scrolls) {
            [finish toggleScrollsStarAnimated:YES];
        }
    }

    // Save score
    [self.playerScore save];
}

- (void)scrollPickup {
    // Play sound effect
    if ([Settings instance].effects) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"scroll.mp3"];
    }
}

#pragma mark FinishedMenuDelegate/PauseMenuDelegate

- (void)nextAction {
    [[CCDirector sharedDirector] replaceScene: [GameScene sceneWithLevel:[self.level nextLevel]]];
}

- (void)quitAction {
    [[CCDirector sharedDirector] replaceScene: [MainScene sceneFromLevel:self.level]];
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
    PauseMenu *menu = [PauseMenu menuWithDelegate:self completed:self.playerScore.completed moves:self.playerScore.moves scrolls:self.playerScore.scrolls];
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
