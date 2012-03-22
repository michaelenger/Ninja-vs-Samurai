//
//  Actor.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Actor.h"
#import "GameMap.h"

int const SPEED = 400;

@interface Actor (Private)

// Private setters
- (void)setDestination:(CGPoint)destination;
- (void)setReady:(BOOL)ready;

@end

@implementation Actor
@synthesize sprite = _sprite,
            map = _map,
            mapPosition = _mapPosition,
            destination = _destination,
            ready = _ready;

#pragma mark Class Methods

+ (Actor *)actorWithSprite:(NSString *)sprite position:(CGPoint)position {
    return [[[self alloc] initWithSprite:sprite position:position] autorelease];
}

+ (Actor *)actorWithSprite:(NSString *)sprite position:(CGPoint)position map:(GameMap *)map {
    return [[[self alloc] initWithSprite:sprite position:position map:map] autorelease];
}

#pragma mark Initialize

- (id)initWithSprite:(NSString *)sprite position:(CGPoint)position {
    if ((self = [self init])) {
        self.sprite = [CCSprite spriteWithSpriteFrameName:sprite];
        [self addChild:self.sprite];
        self.mapPosition = position;
    }
    return self;
}

- (id)initWithSprite:(NSString *)sprite position:(CGPoint)position map:(GameMap *)map {
    if ((self = [self initWithSprite:sprite position:position])) {
        self.map = map;
        [self updateSpritePosition];
    }
    return self;
}

#pragma mark Instance Methods

- (void)moveTo:(CGPoint)destination {
    self.ready = NO;
    self.destination = destination;
}

- (void)setDestination:(CGPoint)destination {
    _destination = destination;
}

- (void)setReady:(BOOL)ready {
    _ready = ready;
}

- (void)update:(ccTime)dt {
    if (self.destination.x != -1 && self.destination.y != -1) {
        CGPoint destination = [self.map translateMapPosition:self.destination];
        destination.x += self.sprite.contentSize.width / 2;
        destination.y += self.sprite.contentSize.height / 2;
        
        // Determine distance to travel
        CGPoint distance = ccp(0,0);
        if (self.destination.x > self.mapPosition.x) {
            distance.x = SPEED * dt;
            if (self.position.x + distance.x > destination.x) {
                distance.x = destination.x - self.position.x;
            }
        } else if (self.destination.x < self.mapPosition.x) {
            distance.x = -SPEED * dt;
            if (self.position.x + distance.x < destination.x) {
                distance.x = destination.x - self.position.x;
            }
        }
        if (self.destination.y < self.mapPosition.y) {
            distance.y = SPEED * dt;
            if (self.position.y + distance.y > destination.y) {
                distance.y = destination.y - self.position.y;
            }
        } else if (self.destination.y > self.mapPosition.y) {
            distance.y = -SPEED * dt;
            if (self.position.y + distance.y < destination.y) {
                distance.y = destination.y - self.position.y;
            }
        }
        
        if (distance.x < 0) {
            self.sprite.flipX = YES;
        } else if (distance.x > 0) {
            self.sprite.flipX = NO;
        }

        // Update position
        self.position = ccp(self.position.x + distance.x,
                            self.position.y + distance.y);

        // Done
        if (self.position.x == destination.x && self.position.y == destination.y) {
            self.mapPosition = self.destination;
            self.destination = ccp(-1,-1);
            self.ready = YES;
        }
    }
}

- (CGPoint)updatePosition {
    CGPoint position = [self.map translatePosition:self.position];
    self.mapPosition = position;
    return position;
}

- (CGPoint)updateSpritePosition {
    CGPoint position = (self.map ? [self.map translateMapPosition:self.mapPosition] : ccp(0,0));
    position.x += self.sprite.contentSize.width / 2;
    position.y += self.sprite.contentSize.height / 2;
    self.position = position;
    return position;
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.mapPosition = ccp(0,0);
        self.destination = ccp(-1,-1);
        self.ready = YES;
    }
    return self;
}

- (void)dealloc {
    self.sprite = nil;
    self.map = nil;
    [super dealloc];
}

@end
