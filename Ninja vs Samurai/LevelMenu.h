//
//  LevelMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@protocol LevelMenuDelegate;
@interface LevelMenu : CCMenu

@property (strong) id<LevelMenuDelegate> delegate;
@property (assign) unsigned int group;

// Construtor
+ (LevelMenu *)menuWithDelegate:(id<LevelMenuDelegate>)delegate group:(unsigned int)group;

// Checks if the menu has a specific level
- (BOOL)hasLevel:(NSString *)level;

@end

@protocol LevelMenuDelegate <NSObject>
@required

// Select a level
- (void)selectLevel:(NSString *)level;

@end
