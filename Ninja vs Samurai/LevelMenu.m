//
//  LevelMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "LevelMenu.h"
#import "Constants.h"

@interface LevelMenu (Private)

// Select a level
- (void)levelSelect:(int)level;

@end

@implementation LevelMenu
@synthesize delegate = _delegate,
            group = _group;

#pragma mark Class Methods

+ (LevelMenu *)menuWithDelegate:(id<LevelMenuDelegate>)delegate group:(unsigned int)group {
    // Menu
    LevelMenu *menu = [self menuWithItems:nil];
    menu.delegate = delegate;
    menu.group = group;

    // Level buttons
    int maxLevels = (LEVEL_ROWS * LEVEL_COLUMNS);
    float x; float y;
    for (int i = 0; i < maxLevels; i++) {
        CCMenuItemImage *button = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:@"button-player.png"]
                                                         selectedSprite:[CCSprite spriteWithFile:@"button-player-selected.png"]
                                                                  block:^(id sender){ [menu levelSelect:i+1]; }];
        x = -(button.contentSize.width * LEVEL_COLUMNS / 2) + ((i % LEVEL_COLUMNS) * button.contentSize.width) + (button.contentSize.width / 2);
        y = (button.contentSize.height * LEVEL_ROWS / 2) - (ceil(i / LEVEL_ROWS) * button.contentSize.height) - (button.contentSize.height / 2);
        button.position = ccp(x,y);
        [menu addChild:button];
    }

    return menu;
}

#pragma mark Instance Methods

- (void)levelSelect:(int)level {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectLevel:fromGroup:)]) {
        [self.delegate selectLevel:level fromGroup:self.group];
    }
}

#pragma mark NSObject

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end
