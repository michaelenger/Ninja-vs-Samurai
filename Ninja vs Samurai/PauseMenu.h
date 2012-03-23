//
//  PauseMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ResultsMenu.h"

@protocol PauseMenuDelegate;
@interface PauseMenu : ResultsMenu

@property (strong) id<PauseMenuDelegate> delegate;

// Constructor
+ (PauseMenu *)menuWithDelegate:(id<PauseMenuDelegate>)delegate;
+ (PauseMenu *)menuWithDelegate:(id<PauseMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

// Initialize
- (id)initWithDelegate:(id<PauseMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

@end

@protocol PauseMenuDelegate <NSObject>

@required
// Next level
- (void)nextAction;
// Quit to the main menu
- (void)quitAction;
// Resume play
- (void)resumeAction;

@end
