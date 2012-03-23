//
//  PlayMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "LevelMenu.h"

@protocol PlayMenuDelegate;
@interface PlayMenu : CCNode <LevelMenuDelegate>

@property (assign) unsigned int currentMenu;
@property (strong) id<PlayMenuDelegate> delegate;
@property (strong) NSArray *levelMenus;
@property (strong) CCMenu *menu;
@property (strong) CCMenuItem *nextButton;
@property (strong) CCMenuItem *previousButton;

// Constructor
+ (PlayMenu *)menuWithDelegate:(id<PlayMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<PlayMenuDelegate>)delegate;

@end

@protocol PlayMenuDelegate <NSObject>
@required

// Return from the menu
- (void)backAction;

// Play a specific level
- (void)playLevel:(NSString *)level;

@end
