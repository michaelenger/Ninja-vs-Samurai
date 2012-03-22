//
//  MapLayer.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@class GameMap;

@interface MapLayer : CCLayer

@property (strong) GameMap *map;

// Constructors
+ (MapLayer *)layer;
+ (MapLayer *)layerWithMap:(GameMap *)map;

// Initialize
- (id)initWithMap:(GameMap *)map;

@end
