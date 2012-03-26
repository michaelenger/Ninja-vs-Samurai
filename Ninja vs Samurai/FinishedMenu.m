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
        self.delegate = delegate;

        // Quit Button
        CCLabelBMFont *quitLabel = [CCLabelBMFont labelWithString:@"Quit" fntFile:FONT_MEDIUM];
        CCMenuItem *quit = [CCMenuItemLabel itemWithLabel:quitLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(quitAction)]) {
                [self.delegate quitAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Retry Button
        CCLabelBMFont *replayLabel = [CCLabelBMFont labelWithString:@"Retry" fntFile:FONT_MEDIUM];
        CCMenuItem *replay = [CCMenuItemLabel itemWithLabel:replayLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(retryAction)]) {
                [self.delegate retryAction];
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
        
        self.menu = [CCMenu menuWithItems:quit,replay,next,nil];
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
