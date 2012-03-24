//
//  MainMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@protocol MainMenuDelegate;
@interface MainMenu : Menu

@property (assign) float animationDelay;
@property (strong) id<MainMenuDelegate> delegate;
@property (strong) CCSprite *ninja;

// Constructor
+ (MainMenu *)menuWithDelegate:(id<MainMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<MainMenuDelegate>)delegate;

@end

@protocol MainMenuDelegate <NSObject>
@required

// Show the credits
- (void)creditsAction;

// Play the game
- (void)playAction;

// Show the settings menu
- (void)settingsAction;

@end
