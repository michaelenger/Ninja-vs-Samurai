//
//  MainMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "MainMenu.h"
#import "Constants.h"

@implementation MainMenu
@synthesize animationDelay = _animationDelay,
            delegate = _delegate,
            ninja = _ninja;

#pragma mark Class Methods

+ (MainMenu *)menuWithDelegate:(id<MainMenuDelegate>)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<MainMenuDelegate>)delegate {
    if ((self = [self init])) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark Instance Methods

- (void)update:(ccTime)dt {
    if (!self.visible || self.animationDelay < 0) return;

    self.animationDelay -= dt;
    if (self.animationDelay < 0) {
        float x = (self.ninja.position.y < 0
                   ? self.ninja.contentSize.width + (rand() % (int)(self.contentSize.width - (self.ninja.contentSize.width * 2)))
                   : self.ninja.position.x);
        float y = (self.ninja.position.y < 0 ? self.ninja.contentSize.height * 0.2 : -self.ninja.contentSize.height);
        if (x != self.ninja.position.x) {
            if (x > self.contentSize.width / 2) {
                self.ninja.flipX = YES;
            } else {
                self.ninja.flipX = NO;
            }
            self.ninja.position = ccp(x, self.ninja.position.y);
        }
        [self.ninja runAction:[CCSequence actions:
                               [CCMoveTo actionWithDuration:0.5 position:ccp(x, y)],
                               [CCCallBlock actionWithBlock:^{
            self.animationDelay = 2 + ((rand() % 20) / 10);
        }],
                               nil]];
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        
        // Title
        CCSprite *title = [CCSprite spriteWithSpriteFrameName:@"title.png"];
        title.position = ccp(self.contentSize.width / 2, self.contentSize.height - (title.contentSize.height));
        [self addChild:title];
        
        // Ninja
        self.ninja = [CCSprite spriteWithSpriteFrameName:@"player.png"];
        self.ninja.position = ccp(self.ninja.contentSize.width * 2.5, -self.ninja.contentSize.height);
        [self addChild:self.ninja];

        unsigned int padding = (self.contentSize.width - title.contentSize.width) * 0.7;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            padding = (self.contentSize.width - title.contentSize.width);
        }

        // Play Button
        CCLabelBMFont *playLabel = [CCLabelBMFont labelWithString:@"Play Game" fntFile:FONT_MEDIUM];
        CCMenuItem *playButton = [CCMenuItemLabel itemWithLabel:playLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(playAction)]) {
                [self.delegate playAction];
            }
        }];
        playButton.position = ccp(self.contentSize.width / 2 - playLabel.contentSize.width / 2 - padding, padding * 0.5);
        
        // Settings Button
        CCLabelBMFont *settingsLabel = [CCLabelBMFont labelWithString:@"Settings" fntFile:FONT_MEDIUM];
        CCMenuItem *settingsButton = [CCMenuItemLabel itemWithLabel:settingsLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsAction)]) {
                [self.delegate settingsAction];
            }
        }];
        settingsButton.position = ccp(self.contentSize.width / 2 - settingsLabel.contentSize.width / 2 - padding, playButton.position.y - padding);
        
        // Credits Button
        CCLabelBMFont *creditsLabel = [CCLabelBMFont labelWithString:@"Credits" fntFile:FONT_MEDIUM];
        CCMenuItem *creditsButton = [CCMenuItemLabel itemWithLabel:creditsLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(creditsAction)]) {
                [self.delegate creditsAction];
            }
        }];
        creditsButton.position = ccp(self.contentSize.width / 2 - creditsLabel.contentSize.width / 2 - padding, settingsButton.position.y - padding);
        
        self.menu = [CCMenu menuWithItems:playButton, settingsButton, creditsButton, nil];
        [self addChild:self.menu];

        // Handle the update
        [self schedule:@selector(update:)];
        srand(time(NULL));
        self.animationDelay = 2;
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.ninja = nil;
    [super dealloc];
}

@end
