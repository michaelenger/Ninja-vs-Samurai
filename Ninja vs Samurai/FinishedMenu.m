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
@synthesize delegate = _delegate,
            menu = _menu;

#pragma mark Class Methods

+ (FinishedMenu *)menuWithDelegate:(id<FinishedMenuDelegate>)delegate {
    return [[[self alloc] initWithDelegate:delegate] autorelease];
}

#pragma mark Initialize

- (id)initWithDelegate:(id<FinishedMenuDelegate>)delegate {
    if ((self = [self init])) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Replay
        CCLabelTTF *replayLabel = [CCLabelTTF labelWithString:@"Replay" fontName:FONT_NAME fontSize:FONT_SIZE];
        replayLabel.color = FONT_COLOR;
        CCMenuItem *replay = [CCMenuItemLabel itemWithLabel:replayLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(replayAction)]) {
                [self.delegate replayAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        // Next Level
        CCLabelTTF *nextLabel = [CCLabelTTF labelWithString:@"Next Level" fontName:FONT_NAME fontSize:FONT_SIZE];
        nextLabel.color = FONT_COLOR;
        CCMenuItem *next = [CCMenuItemLabel itemWithLabel:nextLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(nextAction)]) {
                [self.delegate nextAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        self.menu = [CCMenu menuWithItems:replay,next,nil];
        [self.menu alignItemsHorizontallyWithPadding:10];
        [self addChild:self.menu];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.menu = nil;
    [super dealloc];
}

@end
