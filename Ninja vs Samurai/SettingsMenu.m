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
            menu = _menu,
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
        self.contentSize = [CCDirector sharedDirector].winSize;
        
        // Overlay
        CCSprite *overlay = [CCSprite spriteWithFile:@"overlay.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];
        
        // Title
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Settings" fontName:FONT_NAME fontSize:FONT_SIZE_BIG];
        titleLabel.color = FONT_COLOR;
        titleLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height - (self.contentSize.height * 0.1));
        [self addChild:titleLabel];
        
        // Toggle music
        NSString *musicText = [NSString stringWithFormat:@"Music: %@", ([Settings instance].music ? @"YES" : @"NO"), nil];
        CCLabelTTF *musicLabel = [CCLabelTTF labelWithString:musicText fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        musicLabel.color = FONT_COLOR;
        self.musicButton = [CCMenuItemLabel itemWithLabel:musicLabel block:^(id selector){
            [self toggleMusic];
        }];
        self.musicButton.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.7);
        
        // Toggle effects
        NSString *effectsText = [NSString stringWithFormat:@"Effects: %@", ([Settings instance].effects ? @"YES" : @"NO"), nil];
        CCLabelTTF *effectsLabel = [CCLabelTTF labelWithString:effectsText fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        effectsLabel.color = FONT_COLOR;
        self.effectsButton = [CCMenuItemLabel itemWithLabel:effectsLabel block:^(id selector){
            [self toggleEffects];
        }];
        self.effectsButton.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.55);
        
        // Back
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        backLabel.color = FONT_COLOR;
        CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
                [self.delegate backAction];
            }
        }];
        backButton.position = ccp(self.contentSize.width / 2, FONT_SIZE_MED);
        
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
    self.menu = nil;
    self.musicButton = nil;
    [super dealloc];
}

@end
