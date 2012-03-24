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
#import "Settings.h"
#import "SimpleAudioEngine.h"

@implementation MainScene
@synthesize creditsMenu = _creditsMenu,
            mainMenu = _mainMenu,
            playMenu = _playMenu,
            settingsMenu = _settingsMenu;

#pragma mark Class Methods

+ (MainScene *)scene {
    return [self node];
}

+ (MainScene *)sceneFromLevel:(Level *)level {
    MainScene *scene = [self scene];
    [scene.playMenu showMenuForLevel:level];
    [scene playAction];
    return scene;
}

#pragma mark CreditsMenuDelegate/PlayMenuDelegate/SettingsMenuDelegate

- (void)backAction {
    self.creditsMenu.visible = NO;
    self.playMenu.visible = NO;
    self.settingsMenu.visible = NO;
    self.mainMenu.visible = YES;
}

#pragma mark PlayMenuDelegate

- (void)playLevel:(Level *)level {
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithLevel:level]];
}

#pragma mark MainMenuDelegate

- (void)creditsAction {
    if ([Settings instance].effects) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"startgame.mp3"];
    }
    self.mainMenu.visible = NO;
    self.creditsMenu.visible = YES;
}

- (void)playAction {
    self.playMenu.visible = YES;
    self.mainMenu.visible = NO;
}

- (void)settingsAction {
    self.mainMenu.visible = NO;
    self.settingsMenu.visible = YES;
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Background
        [self addChild:[BackgroundLayer layer]];

        // Main menu
        self.mainMenu = [MainMenu menuWithDelegate:self];
        [self addChild:self.mainMenu];

        // Play menu
        self.playMenu = [PlayMenu menuWithDelegate:self];
        self.playMenu.visible = NO;
        [self addChild:self.playMenu];

        // Settings menu
        self.settingsMenu = [SettingsMenu menuWithDelegate:self];
        self.settingsMenu.visible = NO;
        [self addChild:self.settingsMenu];

        // Credits menu
        self.creditsMenu = [CreditsMenu menuWithDelegate:self];
        self.creditsMenu.visible = NO;
        [self addChild:self.creditsMenu];

        // Audio
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"startgame.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music-menu.mp3" loop:YES];
        if (![Settings instance].music) {
            [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        }
    }
    return self;
}

- (void)dealloc {
    self.creditsMenu = nil;
    self.mainMenu = nil;
    self.playMenu = nil;
    self.settingsMenu = nil;
    [super dealloc];
}

@end
