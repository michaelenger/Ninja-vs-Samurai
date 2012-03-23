//
//  CreditsMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@protocol CreditsMenuDelegate;
@interface CreditsMenu : CCNode

@property (strong) id<CreditsMenuDelegate> delegate;
@property (strong) CCMenu *menu;

// Constructor
+ (CreditsMenu *)menuWithDelegate:(id<CreditsMenuDelegate>)delegate;

// Initialize
- (id)initWithDelegate:(id<CreditsMenuDelegate>)delegate;

@end

@protocol CreditsMenuDelegate <NSObject>
@required

// Go back from the credits
- (void)backAction;

@end
