//
//  CreditsMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "CreditsMenu.h"
#import "Constants.h"

@interface CreditsMenu (Private)

// Add link button to the menu
- (CCMenuItemLabel *)addButtonWithTitle:(NSString *)title name:(NSString *)name url:(NSString *)url position:(CGPoint)position;

@end

@implementation CreditsMenu
@synthesize delegate = _delegate,
            menu = _menu;

#pragma mark Class Methods

+ (CreditsMenu *)menuWithDelegate:(id<CreditsMenuDelegate>)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<CreditsMenuDelegate>)delegate {
    if ((self = [self init])) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark Instance Methods

- (CCMenuItemLabel *)addButtonWithTitle:(NSString *)title name:(NSString *)name url:(NSString *)url position:(CGPoint)position {
    unsigned int padding = FONT_SIZE_MED * 0.9;

    CCLabelTTF *label = [CCLabelTTF labelWithString:title fontName:FONT_NAME fontSize:FONT_SIZE_SML];
    label.color = FONT_COLOR_LIGHT;
    label.position = ccp(position.x, position.y);
    [self addChild:label];

    CCLabelTTF *buttonLabel = [CCLabelTTF labelWithString:name fontName:FONT_NAME fontSize:FONT_SIZE_MED];
    buttonLabel.color = FONT_COLOR;
    CCMenuItemLabel *button = [CCMenuItemLabel itemWithLabel:buttonLabel block:^(id selector){
        [[UIApplication sharedApplication] openURL:[[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@",url,nil]] autorelease]];
    }];
    button.position = ccp(label.position.x, label.position.y - padding);

    /*CCLabelTTF *link = [CCLabelTTF labelWithString:url fontName:FONT_NAME fontSize:FONT_SIZE_SML];
    link.color = FONT_COLOR_LIGHT;
    link.position = ccp(button.position.x, button.position.y - padding);
    [self addChild:link];*/

    return button;
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
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Credits" fontName:FONT_NAME fontSize:FONT_SIZE_BIG];
        titleLabel.color = FONT_COLOR;
        titleLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height - (self.contentSize.height * 0.1));
        [self addChild:titleLabel];

        // Buttons
        unsigned int y = self.contentSize.height * 0.75;
        CCMenuItemLabel *mikeButton = [self addButtonWithTitle:@"Design & Development"
                                                          name:@"Michael Enger"
                                                           url:@"thelonelycoder.com"
                                                      position:ccp(self.contentSize.width / 2, y)];

        y = self.contentSize.height * 0.55;
        CCMenuItemLabel *jmoButton = [self addButtonWithTitle:@"Art"
                                                          name:@"Jon-Morten Kristiansen"
                                                           url:@"jonmorten.com"
                                                      position:ccp(self.contentSize.width / 2, y)];
        
        y = self.contentSize.height * 0.35;
        CCMenuItemLabel *evanButton = [self addButtonWithTitle:@"Music"
                                                         name:@"Evan King"
                                                          url:@"soundcloud.com/evan-king"
                                                     position:ccp(self.contentSize.width / 2, y)];
        
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        backLabel.color = FONT_COLOR;
        CCMenuItemLabel *backButton = [CCMenuItemLabel itemWithLabel:backLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
                [self.delegate backAction];
            }
        }];
        backButton.position = ccp(self.contentSize.width / 2, FONT_SIZE_MED);

        // Menu
        self.menu = [CCMenu menuWithItems:mikeButton, jmoButton, evanButton, backButton, nil];
        self.menu.position = ccp(0,0);
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