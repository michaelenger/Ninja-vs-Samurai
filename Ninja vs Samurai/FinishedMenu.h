//
//  FinishedMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ResultsMenu.h"

@protocol FinishedMenuDelegate;
@interface FinishedMenu : ResultsMenu

@property (strong) id<FinishedMenuDelegate> delegate;

// Constructor
+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate;
+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

// Initialize
- (id)initWithDelegate:(id<FinishedMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls;

@end

@protocol FinishedMenuDelegate <NSObject>

@required
// Next level
- (void)nextAction;
// Quit to the main menu
- (void)quitAction;
// Retry the level
- (void)retryAction;

@end
