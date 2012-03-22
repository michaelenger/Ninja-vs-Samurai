//
//  GuardActor.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Actor.h"

typedef enum {
    GuardDirectionUp = 0,
	GuardDirectionDown,
	GuardDirectionLeft,
    GuardDirectionRight
} GuardDirection;

@interface GuardActor : Actor

@property (strong) CCSprite *cone;
@property (assign, readonly) GuardDirection direction;

// Constructors
+ (GuardActor *)actorWithDirection:(GuardDirection)direction position:(CGPoint)position map:(GameMap *)map;
+ (GuardActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map;

// Initialize
- (id)initWithDirection:(GuardDirection)direction position:(CGPoint)position map:(GameMap *)map;

// Check if the guard can see a specific map position
- (BOOL)canSee:(CGPoint)position;

// Guard patrolling action
- (void)patrol;

@end
