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
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Ninja vs Samurai" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        title.color = FONT_COLOR;
        title.position = ccp(self.contentSize.width / 2, self.contentSize.height - FONT_SIZE_MED);
        [self addChild:title];

        // Play Button
        CCLabelTTF *playLabel = [CCLabelTTF labelWithString:@"Play Game"
                                                 dimensions:CGSizeMake(self.contentSize.width - (padding * 2), FONT_SIZE_MED * 1.2)
                                                  alignment:UITextAlignmentRight
                                                   fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        playLabel.color = FONT_COLOR;
        CCMenuItem *playButton = [CCMenuItemLabel itemWithLabel:playLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(playAction)]) {
                [self.delegate playAction];
            }
        }];
        playButton.position = ccp(0, padding * 0.5);
        
        // Settings Button
        CCLabelTTF *settingsLabel = [CCLabelTTF labelWithString:@"Settings"
                                                     dimensions:CGSizeMake(self.contentSize.width - (padding * 2), FONT_SIZE_MED * 1.2)
                                                      alignment:UITextAlignmentRight
                                                       fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        settingsLabel.color = FONT_COLOR;
        CCMenuItem *settingsButton = [CCMenuItemLabel itemWithLabel:settingsLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(settingsAction)]) {
                [self.delegate settingsAction];
            }
        }];
        settingsButton.position = ccp(playButton.position.x, playButton.position.y - padding);
        
        // Credits Button
        CCLabelTTF *creditsLabel = [CCLabelTTF labelWithString:@"Credits"
                                                    dimensions:CGSizeMake(self.contentSize.width - (padding * 2), FONT_SIZE_MED * 1.2)
                                                     alignment:UITextAlignmentRight
                                                      fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        creditsLabel.color = FONT_COLOR;
        CCMenuItem *creditsButton = [CCMenuItemLabel itemWithLabel:creditsLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(creditsAction)]) {
                [self.delegate creditsAction];
            }
        }];
        creditsButton.position = ccp(settingsButton.position.x, settingsButton.position.y - padding);
        
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
