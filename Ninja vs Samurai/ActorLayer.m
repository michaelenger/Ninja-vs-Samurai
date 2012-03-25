//
//  ActorLayer.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ActorLayer.h"
#import "Actor.h"
#import "ExitActor.h"
#import "GameMap.h"
#import "GuardActor.h"
#import "PathNode.h"
#import "PlayerActor.h"
#import "ScrollActor.h"

@interface ActorLayer (Private)

// Trigger the next player turn
- (void)nextTurn;

@end

// Player moves
NSMutableArray *_moves;

@implementation ActorLayer
@synthesize delegate = _delegate,
            map = _map,
            player = _player,
            exit = _exit,
            guards = _guards,
            scrolls = _scrolls,
            playerScrolls = _playerScrolls,
            pause = _pause;

#pragma mark Class Methods

+ (ActorLayer *)layer {
    return [self node];
}

+ (ActorLayer *)layerWithMap:(GameMap *)map {
    return [[[self alloc] initWithMap:map] autorelease];
}

#pragma mark Initialize

- (id)initWithMap:(GameMap *)map {
    if ((self = [self init])) {
        self.map = map;
        [self reset];
    }
    return self;
}

#pragma mark Instance Methods

- (void)fail {
    self.pause = YES;

    // Delegate callback
    if ([self.delegate respondsToSelector:@selector(failed)])
        [self.delegate failed];
}

- (void)finish {
    self.pause = YES;

    // Delegate callback
    if ([self.delegate respondsToSelector:@selector(finished)])
        [self.delegate finished];
}

- (void)nextTurn {
    // Finish the level
    if (self.player && self.exit
        && self.player.mapPosition.x == self.exit.mapPosition.x
        && self.player.mapPosition.y == self.exit.mapPosition.y) {
        return [self finish];
    }

    // Pickup scrolls
    for (int i = 0; i < [self.scrolls count]; i++) {
        ScrollActor *scroll = (ScrollActor *)[self.scrolls objectAtIndex:i];
        if (self.player.mapPosition.x == scroll.mapPosition.x && self.player.mapPosition.y == scroll.mapPosition.y) {
            [self.scrolls removeObject:scroll];
            [self removeChild:scroll cleanup:YES];
            self.playerScrolls++;
            if ([self.delegate respondsToSelector:@selector(scrollPickup)])
                [self.delegate scrollPickup];
        }
    }

    // Get spotted by guards
    for (int i = 0; i < [self.guards count]; i++) {
        GuardActor *guard = (GuardActor *)[self.guards objectAtIndex:i];
        if ([guard canSee:self.player.mapPosition]) {
            // @todo: cut animation
            return [self fail];
        }
    }

    if (!_moves || [_moves count] == 0) {
        return; // we're done here
    }

    // Move the player
    PathNode *node = [_moves objectAtIndex:0];
    [self.player moveTo:node.position];

    [_moves removeObjectAtIndex:0];
    if ([_moves count] == 0) {
        NSLog(@"MOVES: %d", [_moves retainCount]);
        [_moves release];
        _moves = nil;
    }

    // Move the guards
    for (int i = 0; i < [self.guards count]; i++) {
        GuardActor *guard = [self.guards objectAtIndex:i];
        [guard patrol];
    }

    // Delegate callback
    if ([self.delegate respondsToSelector:@selector(nextTurn)])
        [self.delegate nextTurn];
}

- (void)reset {
    // Remove moves
    if (_moves) {
        [_moves release];
    }
    _moves = nil;

    // Clear all children
    self.player = nil;
    self.exit = nil;
    [self.guards removeAllObjects];
    [self.scrolls removeAllObjects];
    [self removeAllChildrenWithCleanup:YES];
    self.playerScrolls = 0;

    // Get the actors
    CCTMXMapInfo *mapInfo = self.map.mapInfo;
    CCTMXLayer *actors = self.map.actors;
    CGSize s = [actors layerSize];
    for (int x = 0; x < s.width; x++) {
        for (int y = 0; y < s.height; y++) {
            // Determine actor type
            unsigned int gid = [actors tileGIDAt:ccp(x,y)];
            NSDictionary *info = [mapInfo.tileProperties objectForKey:[NSNumber numberWithInt:gid]];
            NSString *actorName = [info valueForKey:@"actor"];
            if (actorName) {
                Actor *actor = nil;
                if ([actorName compare:@"player"] == 0) {
                    // Player
                    actor = [PlayerActor actorWithPosition:ccp(x,y) map:self.map];
                    self.player = (PlayerActor *)actor;
                } else if ([actorName compare:@"guard"] == 0) {
                    // Guard
                    NSString *direction = [info valueForKey:@"direction"];
                    if (!direction) {
                        actor = [GuardActor actorWithPosition:ccp(x,y) map:self.map];
                    } else if ([direction compare:@"up"] == 0) {
                        actor = [GuardActor actorWithDirection:GuardDirectionUp position:ccp(x,y) map:self.map];
                    } else if ([direction compare:@"down"] == 0) {
                        actor = [GuardActor actorWithDirection:GuardDirectionDown position:ccp(x,y) map:self.map];
                    } else if ([direction compare:@"left"] == 0) {
                        actor = [GuardActor actorWithDirection:GuardDirectionLeft position:ccp(x,y) map:self.map];
                    } else if ([direction compare:@"right"] == 0) {
                        actor = [GuardActor actorWithDirection:GuardDirectionRight position:ccp(x,y) map:self.map];
                    }
                    [self.guards addObject:(GuardActor *)actor];
                } else if ([actorName compare:@"scroll"] == 0) {
                    // Scroll
                    actor = [ScrollActor actorWithPosition:ccp(x,y) map:self.map];
                    [self.scrolls addObject:(ScrollActor *)actor];
                } else if ([actorName compare:@"exit"] == 0) {
                    // Exit
                    actor = [ExitActor actorWithPosition:ccp(x,y) map:self.map];
                    self.exit = (ExitActor *)actor;
                } else {
                    NSLog(@"Unrecognized actor: \"%@\"", actorName);
                }
            }
        }
    }

    // Add actors (in the correct order)
    if (self.exit) {
        [self addChild:self.exit];
    }
    for (int i = 0; i < [self.scrolls count]; i++) {
        [self addChild:[self.scrolls objectAtIndex:i]];
    }
    if (self.player) {
        [self addChild:self.player];
    }
    for (int i = 0; i < [self.guards count]; i++) {
        [self addChild:[self.guards objectAtIndex:i]];
    }

    // Unpause
    self.pause = NO;
}

- (void)update:(ccTime)dt {
    if (self.pause) return;

    if (self.player.ready) {
        [self nextTurn];
    }
    
    // Player
    [self.player update:dt];
    
    // Guards
    for (int i = 0; i < [self.guards count]; i++) {
        GuardActor *guard = [self.guards objectAtIndex:i];
        [guard update:dt];
    }
}

#pragma mark CCTargetedTouchDelegate

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.pause) return NO;

    // Prevent touches when in the middle of moving
    if (_moves) {
        return NO;
    }

    // Only allow touches inside the map
    CGPoint location = [self convertTouchToNodeSpace: touch];
    return (location.x >= self.map.position.x
            && location.y >= self.map.position.y
            && location.x <= (self.map.position.x + self.map.contentSize.width)
            && location.y <= (self.map.position.y + self.map.contentSize.height));
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint origin = self.player.mapPosition;
    CGPoint destination = [self.map translatePosition:[self convertTouchToNodeSpace: touch]];

    if (![self.map isOpen:destination]) {
        return;
    }

    NSArray *nodes = [self.map pathFrom:origin to:destination];
    if (nodes) {
        _moves = [[NSMutableArray arrayWithArray:nodes] retain];
        [self nextTurn];
    }
}

#pragma mark CCLayer

- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

#pragma mark NSObject

- (id)init {
    if((self = [super init])) {
        // Grab touch events
        self.isTouchEnabled = YES;
        
        // Initialize guard and scroll arrays
        self.guards = [NSMutableArray arrayWithCapacity:0];
        self.scrolls = [NSMutableArray arrayWithCapacity:0];
        self.playerScrolls = 0;
        
        // Handle the update ourself
        [self schedule:@selector(update:)];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.map = nil;
    self.player = nil;
    self.exit = nil;
    self.guards = nil;
    self.scrolls = nil;
    [super dealloc];
}

@end
