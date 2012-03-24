//
//  LevelMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "LevelMenu.h"
#import "Constants.h"
#import "Level.h"
#import "Scores.h"

@interface LevelMenu (Private)

// Select a level
- (void)levelSelect:(Level *)level;

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
    float x; float y; int i = 0;
    Level *level = [Level firstLevelForGroup:group];
    do {
        NSString *buttonSprite;
        NSString *buttonSelectedSprite;
        if ([Scores scoresForLevel:level].completed) {
            buttonSprite = @"button-player.png";
            buttonSelectedSprite = @"button-player-selected.png";
        } else {
            buttonSprite = @"button-guard.png";
            buttonSelectedSprite = @"button-guard-selected.png";
        }
        CCMenuItemImage *button = [CCMenuItemImage itemWithNormalImage:buttonSprite
                                                         selectedImage:buttonSelectedSprite
                                                    block:^(id sender){ [menu levelSelect:level]; }];
        x = -(button.contentSize.width * LEVEL_COLUMNS / 2) + ((i % LEVEL_COLUMNS) * button.contentSize.width) + (button.contentSize.width / 2);
        y = (button.contentSize.height * LEVEL_ROWS / 2) - (ceil(i / LEVEL_COLUMNS) * button.contentSize.height) - (button.contentSize.height / 2);
        button.position = ccp(x,y);
        [menu addChild:button];

        level = [level nextLevelForGroup:group];
        i++;
    } while (level);

    return menu;
}

#pragma mark Instance Methods

- (BOOL)hasLevel:(Level *)level {
    return [level belongsToGroup:self.group];
}

- (void)levelSelect:(Level *)level {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectLevel:)]) {
        [self.delegate selectLevel:level];
    }
}

#pragma mark NSObject

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end
