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
        CGSize winSize = [CCDirector sharedDirector].winSize;
        self.delegate = delegate;
        
        // Quit Button
        CCLabelTTF *quitLabel = [CCLabelTTF labelWithString:@"Quit" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        quitLabel.color = FONT_COLOR;
        CCMenuItem *quit = [CCMenuItemLabel itemWithLabel:quitLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(quitAction)]) {
                [self.delegate quitAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Resume Button
        CCLabelTTF *resumeLabel = [CCLabelTTF labelWithString:@"Resume" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        resumeLabel.color = FONT_COLOR;
        CCMenuItem *resume = [CCMenuItemLabel itemWithLabel:resumeLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(resumeAction)]) {
                [self.delegate resumeAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Next Level Button
        CCLabelTTF *nextLabel = [CCLabelTTF labelWithString:@"Next" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        nextLabel.color = FONT_COLOR;
        CCMenuItem *next = [CCMenuItemLabel itemWithLabel:nextLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(nextAction)]) {
                [self.delegate nextAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        self.menu = [CCMenu menuWithItems:quit,resume,next,nil];
        self.menu.position = ccp(winSize.width / 2, winSize.height * 0.15);
        [self.menu alignItemsHorizontallyWithPadding:FONT_SIZE_MED];
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
