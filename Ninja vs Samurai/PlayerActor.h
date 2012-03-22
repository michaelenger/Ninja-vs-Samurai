//
//  PlayerActor.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Actor.h"

@interface PlayerActor : Actor

// Constructor
+ (PlayerActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map;

@end
