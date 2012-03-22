//
//  ExitActor.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ExitActor.h"

@implementation ExitActor

#pragma mark Class Methods

+ (ExitActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map {
    return (ExitActor *)[self actorWithSprite:@"exit.png" position:position map:map];
}

@end
