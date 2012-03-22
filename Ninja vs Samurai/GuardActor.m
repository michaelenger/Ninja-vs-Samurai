//
//  GuardActor.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "GuardActor.h"
#import "GameMap.h"

@interface GuardActor (Private)

// Private setters
- (void)setDirection:(GuardDirection)direction;

// Update the cone position/rotation based on the direction of the guard
- (void)updateCone;

@end

@implementation GuardActor
@synthesize cone = _cone,
            direction = _direction;

#pragma mark Class Methods

+ (GuardActor *)actorWithDirection:(GuardDirection)direction position:(CGPoint)position map:(GameMap *)map {
    return [[[self alloc] initWithDirection:direction position:position map:map] autorelease];
}

+ (GuardActor *)actorWithPosition:(CGPoint)position map:(GameMap *)map {
    return [self actorWithDirection:GuardDirectionUp position:position map:map];
}

#pragma mark Initialize

- (id)initWithDirection:(GuardDirection)direction position:(CGPoint)position map:(GameMap *)map {
    if ((self = [self initWithSprite:@"guard.png" position:position map:map])) {
        self.direction = direction;
        [self updateCone];
    }
    return self;
}

#pragma mark Instance Methods

- (BOOL)canSee:(CGPoint)position {
    BOOL see = (self.mapPosition.x == position.x && self.mapPosition.y == position.y);
    float gx = self.mapPosition.x;
    float gy = self.mapPosition.y;
    float px = position.x;
    float py = position.y;

    switch (self.direction) {
        case GuardDirectionUp:
            see = see || ([self.map isOpen:ccp(gx,gy-1)]
                          && px > gx - 2 && px < gx + 2
                          && py > gy - 3 && py < gy
                          && [self.map isOpen:ccp(px,py+1)]);
            break;
        case GuardDirectionDown:
            see = see || ([self.map isOpen:ccp(gx,gy+1)]
                          && px > gx - 2 && px < gx + 2
                          && py > gy && py < gy + 3
                          && [self.map isOpen:ccp(px,py-1)]);
            break;
        case GuardDirectionLeft:
            see = see || ([self.map isOpen:ccp(gx-1,gy)]
                          && px > gx - 3 && px < gx
                          && py > gy - 2 && py < gy + 2
                          && [self.map isOpen:ccp(px+1,py)]);
            break;
        case GuardDirectionRight:
            see = see || ([self.map isOpen:ccp(gx+1,gy)]
                          && px > gx && px < gx + 3
                          && py > gy - 2 && py < gy + 2
                          && [self.map isOpen:ccp(px-1,py)]);
            break;
    }

    return see;
}

- (void)patrol {
    CGPoint position;
    switch (self.direction) {
        case GuardDirectionUp:
            position = ccp(self.mapPosition.x, self.mapPosition.y - 1);
            break;
        case GuardDirectionDown:
            position = ccp(self.mapPosition.x, self.mapPosition.y + 1);
            break;
        case GuardDirectionLeft:
            position = ccp(self.mapPosition.x - 1, self.mapPosition.y);
            break;
        case GuardDirectionRight:
            position = ccp(self.mapPosition.x + 1, self.mapPosition.y);
            break;
    }

    if ([self.map isOpen:position]) {
        [self moveTo:position];
    } else {
        switch (self.direction) {
            case GuardDirectionUp:
                self.direction = GuardDirectionDown;
                break;
            case GuardDirectionDown:
                self.direction = GuardDirectionUp;
                break;
            case GuardDirectionLeft:
                self.direction = GuardDirectionRight;
                break;
            case GuardDirectionRight:
                self.direction = GuardDirectionLeft;
                break;
        }
        [self updateCone];
        [self patrol];
    }
}

- (void)setDirection:(GuardDirection)direction {
    _direction = direction;
}

- (void)updateCone {
    switch (self.direction) {
        case GuardDirectionUp:
            self.cone.rotation = 0;
            self.cone.position = ccp(0, self.sprite.contentSize.height);
            break;
        case GuardDirectionDown:
            self.cone.rotation = 180;
            self.cone.position = ccp(0, -(self.cone.contentSize.height - self.sprite.contentSize.height));
            break;
        case GuardDirectionLeft:
            self.cone.rotation = 270;
            self.cone.position = ccp(-self.cone.contentSize.height / 2, 0);
            break;
        case GuardDirectionRight:
            self.cone.rotation = 90;
            self.cone.position = ccp(self.cone.contentSize.height / 2, 0);
            break;
    }
}

#pragma mark Actor

- (id)initWithSprite:(NSString *)sprite position:(CGPoint)position {
    if ((self = [self init])) {
        self.cone = [CCSprite spriteWithSpriteFrameName:@"guardcone.png"];
        [self addChild:self.cone];
        self.sprite = [CCSprite spriteWithSpriteFrameName:sprite];
        [self addChild:self.sprite];
        self.mapPosition = position;
    }
    return self;
}

#pragma mark NSObject

- (void)dealloc {
    self.cone = nil;
    [super dealloc];
}

@end
