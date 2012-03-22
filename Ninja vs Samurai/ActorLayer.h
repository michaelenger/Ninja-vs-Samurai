//
//  ActorLayer.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@class GameMap, PlayerActor, ExitActor;
@protocol ActorDelegate;
@interface ActorLayer : CCLayer

@property (strong) id<ActorDelegate> delegate;
@property (strong) GameMap *map;
@property (strong) PlayerActor *player;
@property (strong) ExitActor *exit;
@property (strong) NSMutableArray *guards;
@property (strong) NSMutableArray *scrolls;
@property (strong) NSMutableArray *playerScrolls;
@property (assign) BOOL pause;

// Constructors
+ (ActorLayer *)layer;
+ (ActorLayer *)layerWithMap:(GameMap *)map;

// Initialize
- (id)initWithMap:(GameMap *)map;

// Fail the level
- (void)fail;

// Finish the level
- (void)finish;

// Reset the level
- (void)reset;

// Update the layer
- (void)update:(ccTime)dt;

@end

@protocol ActorDelegate <NSObject>

@optional
// Called when the player has failed the level
- (void)failed;
// Called when the player has finished the level
- (void)finished;
// Called for every player turn
- (void)nextTurn;

@end
