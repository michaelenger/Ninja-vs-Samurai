//
//  MainScene.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "CreditsMenu.h"
#import "MainMenu.h"
#import "PlayMenu.h"
#import "SettingsMenu.h"

@interface MainScene : CCScene <CreditsMenuDelegate, MainMenuDelegate, PlayMenuDelegate, SettingsMenuDelegate>

@property (strong) CreditsMenu *creditsMenu;
@property (strong) MainMenu *mainMenu;
@property (strong) PlayMenu *playMenu;
@property (strong) SettingsMenu *settingsMenu;

// Constructors
+ (MainScene *)scene;
+ (MainScene *)sceneFromLevel:(Level *)level;

@end
