//
//  GameMap.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@interface GameMap : CCTMXTiledMap

@property (strong) CCTMXMapInfo *mapInfo;
@property (strong) CCTMXLayer *actors;
@property (strong) NSArray *walls;
@property (assign) unsigned int moves;
@property (assign) unsigned int scrolls;

// Check whether a position is open (not a wall)
- (BOOL)isOpen:(CGPoint)position;

// Build a path from one position to another
- (NSArray *)pathFrom:(CGPoint)origin to:(CGPoint)desination;

// Translate map coordinates to "real" coordinates
- (CGPoint)translateMapPosition:(CGPoint)position;

// Translate "real" coordinates to map coordinates
- (CGPoint)translatePosition:(CGPoint)position;

@end
