//
//  LevelMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "LevelMenu.h"
#import "Constants.h"
#import "Scores.h"

@interface LevelMenu (Private)

// Select a level
- (void)levelSelect:(NSString *)level;

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
        NSString *level = [NSString stringWithFormat:@"%d-%d.tmx",group,i+1,nil];
        NSString *buttonSprite;
        NSString *buttonSelectedSprite;
        if ([Scores scoresForLevel:level].completed) {
            buttonSprite = @"button-player.png";
            buttonSelectedSprite = @"button-player-selected.png";
        } else {
            buttonSprite = @"button-guard.png";
            buttonSelectedSprite = @"button-guard-selected.png";
        }
        CCMenuItemImage *button = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithFile:buttonSprite]
                                        selectedSprite:[CCSprite spriteWithFile:buttonSelectedSprite]
                                                 block:^(id sender){ [menu levelSelect:level]; }];
        x = -(button.contentSize.width * LEVEL_COLUMNS / 2) + ((i % LEVEL_COLUMNS) * button.contentSize.width) + (button.contentSize.width / 2);
        y = (button.contentSize.height * LEVEL_ROWS / 2) - (ceil(i / LEVEL_COLUMNS) * button.contentSize.height) - (button.contentSize.height / 2);
        button.position = ccp(x,y);
        [menu addChild:button];
    }

    return menu;
}

#pragma mark Instance Methods

- (BOOL)hasLevel:(NSString *)level {
    int group = [[level substringToIndex:[level rangeOfString:@"-"].length] intValue];
    return (group == self.group);
}

- (void)levelSelect:(NSString *)level {
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
