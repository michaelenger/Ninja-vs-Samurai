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
@synthesize delegate = _delegate,
            menu = _menu;

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

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.contentSize = [CCDirector sharedDirector].winSize;
        unsigned int padding = FONT_SIZE_MED * 1.5;
        
        // Title
        CCSprite *title = [CCSprite spriteWithFile:@"title.png"];
        title.position = ccp(self.contentSize.width / 2, self.contentSize.height - (title.contentSize.height));
        [self addChild:title];
        
        // Ninja
        CCSprite *ninja = [CCSprite spriteWithSpriteFrameName:@"player.png"];
        ninja.position = ccp(ninja.contentSize.width * 2.5, ninja.contentSize.height * 0.2);
        [self addChild:ninja];

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
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.menu = nil;
    [super dealloc];
}

@end
