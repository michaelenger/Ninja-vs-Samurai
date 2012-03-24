//
//  PlayMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "LevelMenu.h"
#import "Menu.h"

@protocol PlayMenuDelegate;
@class Level;
@interface PlayMenu : Menu <LevelMenuDelegate>

@property (assign, readonly) unsigned int currentMenu;
@property (strong) id<PlayMenuDelegate> delegate;
@property (strong) NSArray *levelMenus;
@property (strong) CCMenuItem *nextButton;
@property (strong) CCMenuItem *previousButton;

// Constructor
+ (PlayMenu *)menuWithDelegate:(id<PlayMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<PlayMenuDelegate>)delegate;

// Show the menu for a specific level
- (void)showMenuForLevel:(Level *)level;

// Set the current level menu
- (void)setCurrentMenu:(unsigned int)currentMenu;
- (void)setCurrentMenu:(unsigned int)currentMenu animated:(BOOL)animated;

@end

@protocol PlayMenuDelegate <NSObject>
@required

// Return from the menu
- (void)backAction;

// Play a specific level
- (void)playLevel:(Level *)level;

@end
