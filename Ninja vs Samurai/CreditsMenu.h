//
//  CreditsMenu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"
#import "Menu.h"

@protocol CreditsMenuDelegate;
@interface CreditsMenu : Menu

@property (strong) id<CreditsMenuDelegate> delegate;

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
