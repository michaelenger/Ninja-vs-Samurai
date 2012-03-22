//
//  ScrollActor.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Actor.h"

@interface ScrollActor : Actor

// Constructor
+ (ScrollActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map;

@end
