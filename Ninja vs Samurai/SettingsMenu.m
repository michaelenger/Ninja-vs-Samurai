//
//  CreditsMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "SettingsMenu.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "Settings.h"

@implementation SettingsMenu
@synthesize delegate = _delegate,
            effectsButton = _effectsButton,
            musicButton = _musicButton;

#pragma mark Class Methods

+ (SettingsMenu *)menuWithDelegate:(id<SettingsMenuDelegate>)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<SettingsMenuDelegate>)delegate {
    if ((self = [self init])) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark Instance Methods

- (void)toggleEffects {
    // Toggle setting
    BOOL effects = ![Settings instance].effects;
    
    // Update label
    self.effectsButton.label.string = [NSString stringWithFormat:@"Effects: %@", (effects ? @"YES" : @"NO"), nil];
    
    // Update settings
    [Settings instance].effects = effects;
}

- (void)toggleMusic {
    // Toggle setting
    BOOL music = ![Settings instance].music;

    // Update label
    self.musicButton.label.string = [NSString stringWithFormat:@"Music: %@", (music ? @"YES" : @"NO"), nil];

    // Update settings
    [Settings instance].music = music;

    // Enable/disable music
    if (music) {
        [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
    } else {
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Overlay
        CCSprite *overlay = [CCSprite spriteWithSpriteFrameName:@"overlay.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];
        
        // Title
        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"Settings" fntFile:FONT_LARGE];
        titleLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height - (self.contentSize.height * 0.1));
        [self addChild:titleLabel];
        
        // Toggle music
        NSString *musicText = [NSString stringWithFormat:@"Music: %@", ([Settings instance].music ? @"YES" : @"NO"), nil];
        CCLabelBMFont *musicLabel = [CCLabelBMFont labelWithString:musicText fntFile:FONT_MEDIUM];
        self.musicButton = [CCMenuItemLabel itemWithLabel:musicLabel block:^(id selector){
            [self toggleMusic];
        }];
        self.musicButton.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.7);
        
        // Toggle effects
        NSString *effectsText = [NSString stringWithFormat:@"Effects: %@", ([Settings instance].effects ? @"YES" : @"NO"), nil];
        CCLabelBMFont *effectsLabel = [CCLabelBMFont labelWithString:effectsText fntFile:FONT_MEDIUM];
        self.effectsButton = [CCMenuItemLabel itemWithLabel:effectsLabel block:^(id selector){
            [self toggleEffects];
        }];
        self.effectsButton.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.55);
        
        // Back
        CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-back.png"]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-back-selected.png"]
                                                                      block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
                [self.delegate backAction];
            }
        }];
        backButton.position = ccp(self.contentSize.width / 2, backButton.contentSize.height * 0.75);
        
        // Menu
        self.menu = [CCMenu menuWithItems:self.musicButton, self.effectsButton, backButton, nil];
        self.menu.position = ccp(0,0);
        [self addChild:self.menu];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.effectsButton = nil;
    self.musicButton = nil;
    [super dealloc];
}

@end
