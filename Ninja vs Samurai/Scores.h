//
//  Scores.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Level;
@interface Scores : NSObject

@property (strong) Level * level;
@property (assign) BOOL completed;
@property (assign) BOOL moves;
@property (assign) BOOL scrolls;

// Constructor
+ (Scores *)scoresForLevel:(Level *)level;

// Initialize
- (id)initWithLevel:(Level *)level;

// Full score
- (BOOL)fullScore;

// Save the score
- (void)save;


@end
