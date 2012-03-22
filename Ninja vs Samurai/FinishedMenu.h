//
//  FinishedMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@protocol FinishedMenuDelegate;
@interface FinishedMenu : CCNode

@property (strong) id<FinishedMenuDelegate> delegate;
@property (strong) CCMenu *menu;

// Constructor
+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<FinishedMenuDelegate>)delegate;

@end

@protocol FinishedMenuDelegate <NSObject>

@required
// Replay the level
- (void)replayAction;
// Next level
- (void)nextAction;

@end
