//
//  GameScene.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "ActorLayer.h"
#import "FinishedMenu.h"
#import "PauseMenu.h"
#import "UILayer.h"

@class ActorLayer, BackgroundLayer, Level, MapLayer, UILayer, Scores;
@interface GameScene : CCScene <ActorLayerDelegate, FinishedMenuDelegate, PauseMenuDelegate, UILayerDelegate>

@property (strong) ActorLayer *actor;
@property (strong) BackgroundLayer *background;
@property (strong) MapLayer *map;
@property (strong) UILayer *ui;
@property (strong) Level *level;
@property (strong) Scores *playerScore;

// Constructor
+ (GameScene *)sceneWithLevel:(Level *)level;

// Initialize
- (id)initWithLevel:(Level *)level;

// Hide/show game elements
- (void)hide;
- (void)show;

@end
