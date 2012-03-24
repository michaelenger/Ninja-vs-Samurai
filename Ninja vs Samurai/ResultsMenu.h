//
//  FinishedMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@interface ResultsMenu : Menu

@property (strong) CCSprite *completedStar;
@property (strong) CCSprite *scrollsStar;
@property (strong) CCSprite *movesStar;

// Constructor
+ (ResultsMenu *)menuWithTitle:(NSString *)title completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

// Initialize
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

// Toggle stars
- (void)toggleCompletedStarAnimated:(BOOL)animated;
- (void)toggleScrollsStarAnimated:(BOOL)animated;
- (void)toggleMovesStarAnimated:(BOOL)animated;

@end
