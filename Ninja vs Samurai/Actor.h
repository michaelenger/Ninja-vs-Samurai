//
//  Actor.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@class GameMap;
@interface Actor : CCNode

@property (strong) CCSprite *sprite;
@property (strong) GameMap *map;
@property (assign) CGPoint mapPosition;
@property (assign, readonly) CGPoint destination;
@property (assign, readonly) BOOL ready;

// Constructors
+ (Actor *)actorWithSprite:(NSString *)sprite position:(CGPoint)position;
+ (Actor *)actorWithSprite:(NSString *)sprite  position:(CGPoint)position map:(GameMap *)map;

// Initialize
- (id)initWithSprite:(NSString *)sprite position:(CGPoint)position;
- (id)initWithSprite:(NSString *)sprite position:(CGPoint)position map:(GameMap *)map;

// Move the actor
- (void)moveTo:(CGPoint)destination;

// Update the actor
- (void)update:(ccTime)dt;

// Update the position of the actor/sprite
- (CGPoint)updatePosition;
- (CGPoint)updateSpritePosition;

@end
