//
//  MainScene.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "MainScene.h"
#import "BackgroundLayer.h"
#import "Constants.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"

@implementation MainScene
@synthesize mainMenu = _mainMenu;

#pragma mark Class Methods

+ (MainScene *)scene {
    return [self node];
}

#pragma mark MainMenuDelegate

- (void)creditsAction {
    // @todo
    [[SimpleAudioEngine sharedEngine] playEffect:@"startgame.mp3"];
}

- (void)playAction {
    // @todo: show a level chooser
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:@"testmap.tmx"]];
}

- (void)settingsAction {
    // @todo
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Background
        [self addChild:[BackgroundLayer layer]];

        // Main menu
        self.mainMenu = [MainMenu menuWithDelegate:self];
        self.mainMenu.position = ccp(0, 0);
        [self addChild:self.mainMenu];

        // Audio
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"startgame.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music-menu.mp3" loop:YES];
    }
    return self;
}

- (void)dealloc {
    self.mainMenu = nil;
    [super dealloc];
}

@end
