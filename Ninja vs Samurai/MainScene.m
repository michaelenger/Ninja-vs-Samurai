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
@synthesize creditsMenu = _creditsMenu,
mainMenu = _mainMenu;

#pragma mark Class Methods

+ (MainScene *)scene {
    return [self node];
}

#pragma mark CreditsMenuDelegate

- (void)backAction {
    self.creditsMenu.visible = NO;
    self.mainMenu.visible = YES;
}

#pragma mark MainMenuDelegate

- (void)creditsAction {
    [[SimpleAudioEngine sharedEngine] playEffect:@"startgame.mp3"];
    self.mainMenu.visible = NO;
    self.creditsMenu.visible = YES;
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
        [self addChild:self.mainMenu];

        // Credits menu
        self.creditsMenu = [CreditsMenu menuWithDelegate:self];
        self.creditsMenu.visible = NO;
        [self addChild:self.creditsMenu];

        // Audio
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"startgame.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music-menu.mp3" loop:YES];
    }
    return self;
}

- (void)dealloc {
    self.creditsMenu = nil;
    self.mainMenu = nil;
    [super dealloc];
}

@end
