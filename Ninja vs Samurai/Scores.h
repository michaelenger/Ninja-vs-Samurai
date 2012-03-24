//
//  Scores.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scores : NSObject

@property (strong) NSString * level;
@property (assign) BOOL completed;
@property (assign) BOOL moves;
@property (assign) BOOL scrolls;

// Constructor
+ (Scores *)scoresForLevel:(NSString *)level;

// Initialize
- (id)initWithLevel:(NSString *)level;

// Save the score
- (void)save;


@end