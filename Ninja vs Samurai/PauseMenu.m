//
//  PauseMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "PauseMenu.h"
#import "Constants.h"

@implementation PauseMenu
@synthesize delegate = _delegate;

#pragma mark Class Methods

+ (PauseMenu *)menuWithDelegate:(id<PauseMenuDelegate>)delegate {
    return [self menuWithDelegate:delegate completed:NO moves:NO scrolls:NO];
}

+ (PauseMenu *)menuWithDelegate:(id<PauseMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    return [[[self alloc] initWithDelegate:delegate completed:completed moves:moves scrolls:scrolls] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<PauseMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    if ((self = [self initWithTitle:@"Paused" completed:completed moves:moves scrolls:scrolls])) {
        self.delegate = delegate;
        
        // Quit Button
        CCLabelBMFont *quitLabel = [CCLabelBMFont labelWithString:@"Quit" fntFile:FONT_MEDIUM];
        CCMenuItem *quit = [CCMenuItemLabel itemWithLabel:quitLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(quitAction)]) {
                [self.delegate quitAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Resume Button
        CCLabelBMFont *resumeLabel = [CCLabelBMFont labelWithString:@"Resume" fntFile:FONT_MEDIUM];
        CCMenuItem *resume = [CCMenuItemLabel itemWithLabel:resumeLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(resumeAction)]) {
                [self.delegate resumeAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Next Level Button
        CCLabelBMFont *nextLabel = [CCLabelBMFont labelWithString:@"Next" fntFile:FONT_MEDIUM];
        CCMenuItem *next = [CCMenuItemLabel itemWithLabel:nextLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(nextAction)]) {
                [self.delegate nextAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];

        self.menu = [CCMenu menuWithItems:quit,resume,next,nil];
        self.menu.position = ccp(self.contentSize.width / 2, (quitLabel.contentSize.height * 1.25));
        unsigned int padding = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? FONT_SIZE_BIG : FONT_SIZE_MED);
        [self.menu alignItemsHorizontallyWithPadding:padding];
        [self addChild:self.menu];
    }
    return self;
}

#pragma mark NSObject

- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end
