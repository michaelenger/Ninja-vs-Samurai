//
//  ScrollActor.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ScrollActor.h"

@implementation ScrollActor

#pragma mark Class Methods

+ (ScrollActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map {
    return (ScrollActor *)[self actorWithSprite:@"scroll.png" position:position map:map];
}

@end
