//
//  UILayer.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@interface UILayer : CCLayer

@property (strong) CCSprite *damageIndicator;
@property (assign) unsigned int moves;
@property (strong) CCLabelTTF *movesLabel;

// Constructors
+ (UILayer *)layer;

// Flash the damage indication
- (void)flashDamage;

// Update the UI elements
- (void)update;

@end
