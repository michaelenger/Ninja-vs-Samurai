//
//  PlayMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "PlayMenu.h"
#import "Constants.h"
#import "LevelMenu.h"

@interface PlayMenu (Private)

// Navigate the menus
- (void)nextMenu;
- (void)previousMenu;

// Update the menu
- (void)updateButtons;

@end

@implementation PlayMenu
@synthesize currentMenu = _currentMenu,
            delegate = _delegate,
            levelMenus = _levelMenus,
            nextButton = _nextButton,
            previousButton = _previousButton;

#pragma mark Class Methods

+ (PlayMenu *)menuWithDelegate:(id<PlayMenuDelegate>)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<PlayMenuDelegate>)delegate {
    if ((self = [self init])) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark Instance Methods

- (void)nextMenu {
    float duration = 0.3;
    LevelMenu *current = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu];
    LevelMenu *next = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu + 1];

    [current runAction:[CCSequence actions:
                        [CCEaseInOut actionWithAction:[CCMoveTo
                                                       actionWithDuration:duration
                                                       position:ccp(-current.contentSize.width / 2,current.position.y)] rate:2],
                        [CCCallBlock actionWithBlock:^{ current.visible = NO; }],
                        nil]];
    [next runAction:[CCSequence actions:
                        [CCCallBlock actionWithBlock:^{ next.visible = YES; }],
                        [CCEaseInOut actionWithAction:[CCMoveTo
                                                       actionWithDuration:duration
                                                       position:ccp(self.contentSize.width / 2,next.position.y)] rate:2],
                        nil]];

    self.currentMenu++;
    [self updateButtons];
}

- (void)previousMenu {
    float duration = 0.3;
    LevelMenu *current = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu];
    LevelMenu *previous = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu - 1];

    [current runAction:[CCSequence actions:
                        [CCEaseInOut actionWithAction:[CCMoveTo
                                                       actionWithDuration:duration
                                                       position:ccp(self.contentSize.width + (current.contentSize.width / 2),current.position.y)] rate:2],
                        [CCCallBlock actionWithBlock:^{ current.visible = NO; }],
                        nil]];
    [previous runAction:[CCSequence actions:
                     [CCCallBlock actionWithBlock:^{ previous.visible = YES; }],
                     [CCEaseInOut actionWithAction:[CCMoveTo
                                                    actionWithDuration:duration
                                                    position:ccp(self.contentSize.width / 2,previous.position.y)] rate:2],
                     nil]];

    self.currentMenu--;
    [self updateButtons];
}

- (void)updateButtons {
    // Show/hide buttons
    self.previousButton.visible = (self.currentMenu != 0);
    self.nextButton.visible = (self.currentMenu < LEVEL_GROUPS - 1);
}

#pragma mark LevelMenuDelegate

- (void)selectLevel:(int)level fromGroup:(int)group {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playLevel:)]) {
        [self.delegate playLevel:[NSString stringWithFormat:@"%d-%d.tmx",group,level,nil]];
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.contentSize = [CCDirector sharedDirector].winSize;
        self.currentMenu = 0;

        // Overlay
        CCSprite *overlay = [CCSprite spriteWithFile:@"overlay.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];

        // Previous
        self.previousButton = [CCMenuItemImage itemWithNormalImage:@"button-previous.png"
                                                     selectedImage:@"button-previous-selected.png"
                                                            target:self selector:@selector(previousMenu)];
        self.previousButton.position = ccp(self.previousButton.contentSize.width,
                                           self.contentSize.height / 2);

        // Next
        self.nextButton = [CCMenuItemImage itemWithNormalImage:@"button-next.png"
                                                 selectedImage:@"button-next-selected.png"
                                                        target:self selector:@selector(nextMenu)];
        self.nextButton.position = ccp(self.contentSize.width - self.nextButton.contentSize.width,
                                       self.contentSize.height / 2);
        
        // Back
        CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalImage:@"button-back.png" selectedImage:@"button-back-selected.png" block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(backAction)]) {
                [self.delegate backAction];
            }
        }];
        backButton.position = ccp(self.contentSize.width / 2, backButton.contentSize.height * 0.75);

        self.menu = [CCMenu menuWithItems:self.previousButton, self.nextButton, backButton, nil];
        self.menu.position = ccp(0,0);

        // Level menus
        NSMutableArray *menus = [NSMutableArray arrayWithCapacity:LEVEL_GROUPS];
        for (int i = 0; i < LEVEL_GROUPS; i++) {
            LevelMenu *menu = [LevelMenu menuWithDelegate:self group:i+1];
            [menus addObject:menu];
            menu.position = ccp(self.contentSize.width + (menu.contentSize.width / 2),
                                self.contentSize.height / 2 + (backButton.contentSize.height / 2));
            menu.visible = NO;
            [self addChild:menu];
        }
        self.levelMenus = menus;

        // Reposition the first menu
        LevelMenu *menu = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu];
        menu.position = ccp(self.contentSize.width / 2, menu.position.y);
        menu.visible = YES;

        [self addChild:self.menu];
        [self updateButtons];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.levelMenus = nil;
    self.nextButton = nil;
    self.previousButton = nil;
    [super dealloc];
}

@end
