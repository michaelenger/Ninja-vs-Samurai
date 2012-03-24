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
    [self setCurrentMenu:self.currentMenu+1 animated:YES];
}

- (void)previousMenu {
    [self setCurrentMenu:self.currentMenu-1 animated:YES];
}

- (void)showMenuForLevel:(Level *)level {
    for (unsigned int i = 0; i < LEVEL_GROUPS; i++) {
        LevelMenu *menu = (LevelMenu *)[self.levelMenus objectAtIndex:i];
        if ([menu hasLevel:level]) {
            [self setCurrentMenu:i animated:NO];
            break;
        }
    }
}

- (void)setCurrentMenu:(unsigned int)currentMenu {
    [self setCurrentMenu:currentMenu animated:NO];
}

- (void)setCurrentMenu:(unsigned int)currentMenu animated:(BOOL)animated {
    if (currentMenu >= LEVEL_GROUPS || currentMenu == _currentMenu) return;

    LevelMenu *current = (LevelMenu *)[self.levelMenus objectAtIndex:self.currentMenu];
    LevelMenu *next = (LevelMenu *)[self.levelMenus objectAtIndex:currentMenu];

    if (animated) {
        float duration = 0.3;
        CGPoint offset;

        offset = ccp(current.contentSize.width * (currentMenu > _currentMenu ? -1 : 1), 0);
        [current runAction:[CCSequence actions:
                            [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:duration position:offset] rate:2],
                            [CCCallBlock actionWithBlock:^{ current.visible = NO; }],
                            nil]];
        offset = ccp(current.contentSize.width * (currentMenu > _currentMenu ? 1 : -1), 0);
        next.position = ccp(self.contentSize.width / 2 + offset.x, next.position.y + offset.y);
        offset = ccp(current.contentSize.width * (currentMenu > _currentMenu ? -1 : 1), 0);
        [next runAction:[CCSequence actions:
                         [CCCallBlock actionWithBlock:^{ next.visible = YES; }],
                         [CCEaseInOut actionWithAction:[CCMoveBy actionWithDuration:duration position:offset] rate:2],
                         nil]];
    } else {
        current.visible = NO;
        next.visible = YES;
        next.position = ccp(self.contentSize.width / 2, next.position.y);
    }

    _currentMenu = currentMenu;
    [self updateButtons];
}

- (void)updateButtons {
    // Show/hide buttons
    self.previousButton.visible = (self.currentMenu != 0);
    self.nextButton.visible = (self.currentMenu < LEVEL_GROUPS - 1);
}

#pragma mark LevelMenuDelegate

- (void)selectLevel:(Level *)level {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playLevel:)]) {
        [self.delegate playLevel:level];
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        _currentMenu = 0;

        // Overlay
        CCSprite *overlay = [CCSprite spriteWithSpriteFrameName:@"overlay.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];

        // Title
        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:@"Select Level" fntFile:FONT_LARGE];
        titleLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height - (self.contentSize.height * 0.1));
        [self addChild:titleLabel];

        // Previous
        self.previousButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-previous.png"]
                                                     selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-previous-selected.png"]
                                                             target:self selector:@selector(previousMenu)];
        self.previousButton.position = ccp(self.previousButton.contentSize.width,
                                           self.contentSize.height / 2);

        // Next
        self.nextButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-next.png"]
                                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-next-selected.png"]
                                                         target:self selector:@selector(nextMenu)];
        self.nextButton.position = ccp(self.contentSize.width - self.nextButton.contentSize.width,
                                       self.contentSize.height / 2);
        
        // Back
        CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-back.png"]
                                                             selectedSprite:[CCSprite spriteWithSpriteFrameName:@"button-back-selected.png"]
                                                                      block:^(id selector){
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
                                self.contentSize.height / 2);
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
