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

@interface MainScene : CCScene <CreditsMenuDelegate, MainMenuDelegate>

@property (strong) CreditsMenu *creditsMenu;
@property (strong) MainMenu *mainMenu;

// Constructor
+ (MainScene *)scene;

@end
