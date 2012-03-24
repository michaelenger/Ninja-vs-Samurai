//
//  BackgroundLayer.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "BackgroundLayer.h"

CCSprite *clouds;

@interface BackgroundLayer(Private)

// Update the background
- (void)update:(ccTime)dt;

@end

@implementation BackgroundLayer

#pragma mark Class Methods

+ (BackgroundLayer *)layer {
    return [self node];
}

#pragma mark Instance Methods

- (void)update:(ccTime)dt {
    float cloudWidth = [clouds contentSize].width;
    clouds.position = ccp( clouds.position.x - 2*dt, clouds.position.y );
    if (clouds.position.x < - cloudWidth/2) {
        clouds.position = ccp( [CCDirector sharedDirector].winSize.width + cloudWidth/2, clouds.position.y );
    }
}

#pragma mark NSObject

- (id)init {
	if((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;

        // Background texture
        CCSprite *texture = [CCSprite spriteWithSpriteFrameName:@"background.png"];
        texture.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:texture];
        
        // Landscape
        CCSprite *landscape = [CCSprite spriteWithSpriteFrameName:@"landscape.png"];
        landscape.position = texture.position;
        [self addChild:landscape];
        
        // Clouds
        clouds = [[CCSprite spriteWithSpriteFrameName:@"clouds.png"] retain];
        CGSize cloudSize = [clouds contentSize];
        clouds.position = ccp(winSize.width - cloudSize.width*0.75, winSize.height - cloudSize.height * 1.2);
        [self addChild:clouds];
        
        // Update scheduler
        [self schedule:@selector(update:)];
	}
	return self;
}

- (void)dealloc {
    if (clouds) [clouds release];
    [super dealloc];
}

@end
