//
//  UILayer.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@protocol UILayerDelegate;
@interface UILayer : CCLayer

@property (strong) CCSprite *damageIndicator;
@property (strong) id<UILayerDelegate> delegate;
@property (strong) CCMenu *menu;
@property (assign) unsigned int moves;
@property (strong) CCLabelTTF *movesLabel;

// Constructors
+ (UILayer *)layer;

// Flash the damage indication
- (void)flashDamage;

// Update the UI elements
- (void)update;

@end

@protocol UILayerDelegate <NSObject>

@optional
// Show the pause menu
- (void)pauseAction;

// Reset the current level
- (void)resetAction;

@end
