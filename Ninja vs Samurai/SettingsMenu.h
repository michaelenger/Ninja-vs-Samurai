//
//  SettingsMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@protocol SettingsMenuDelegate;
@interface SettingsMenu : Menu

@property (strong) id<SettingsMenuDelegate> delegate;
@property (strong) CCMenuItemLabel *effectsButton;
@property (strong) CCMenuItemLabel *musicButton;

// Constructor
+ (SettingsMenu *)menuWithDelegate:(id<SettingsMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<SettingsMenuDelegate>)delegate;

// Toggle the settings
- (void)toggleEffects;
- (void)toggleMusic;

@end

@protocol SettingsMenuDelegate <NSObject>
@required

// Go back from the credits
- (void)backAction;

@end
