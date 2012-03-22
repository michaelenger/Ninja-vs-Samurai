//
//  PlayerActor.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "PlayerActor.h"

@implementation PlayerActor

#pragma mark Class Methods

+ (PlayerActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map {
    return (PlayerActor *)[self actorWithSprite:@"player.png" position:position map:map];
}

@end
