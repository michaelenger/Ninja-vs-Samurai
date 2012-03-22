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

@class ActorLayer, BackgroundLayer, MapLayer, UILayer;
@interface GameScene : CCScene <ActorDelegate, FinishedMenuDelegate>

@property (strong) ActorLayer *actor;
@property (strong) BackgroundLayer *background;
@property (strong) MapLayer *map;
@property (strong) UILayer *ui;

// Constructor
+ (GameScene *)scene;

// Hide/show game elements
- (void)hide;
- (void)show;

@end
