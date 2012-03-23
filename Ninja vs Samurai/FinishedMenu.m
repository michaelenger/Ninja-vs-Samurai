//
//  FinishedMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "FinishedMenu.h"
#import "Constants.h"

@implementation FinishedMenu
@synthesize delegate = _delegate;

#pragma mark Class Methods

+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate {
    return [self menuWithDelegate:delegate completed:NO moves:NO scrolls:NO];
}

+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    return [[[self alloc] initWithDelegate:delegate completed:completed moves:moves scrolls:scrolls] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<FinishedMenuDelegate>)delegate completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    if ((self = [self initWithTitle:@"Success" completed:completed moves:moves scrolls:scrolls])) {
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
        
        // Retry Button
        CCLabelTTF *replayLabel = [CCLabelTTF labelWithString:@"Retry" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        replayLabel.color = FONT_COLOR;
        CCMenuItem *replay = [CCMenuItemLabel itemWithLabel:replayLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(retryAction)]) {
                [self.delegate retryAction];
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
        
        self.menu = [CCMenu menuWithItems:quit,replay,next,nil];
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
