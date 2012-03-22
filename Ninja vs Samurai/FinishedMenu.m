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
            menu = _menu,
            completedStar = _completedStar,
            scrollsStar = _scrollsStar,
            movesStar = _movesStar;

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

#pragma mark Instance Methods

- (void)toggleCompletedStarAnimated:(BOOL)animated {
    CCSprite *star = [CCSprite spriteWithFile:@"star.png"];
    star.position = self.completedStar.position;
    [self addChild:star];
    if (animated) {
        star.scale = 0;
        [star runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.2 scale:1.3],
                                            [CCScaleTo actionWithDuration:0.1 scale:1],
                                            [CCCallBlock actionWithBlock:^{
                                                [self removeChild:self.completedStar cleanup:NO];
                                                self.completedStar = star;
                                            }], nil]];
    } else {
        [self removeChild:self.completedStar cleanup:NO];
        self.completedStar = star;
    }
}

- (void)toggleScrollsStarAnimated:(BOOL)animated {
    CCSprite *star = [CCSprite spriteWithFile:@"star.png"];
    star.position = self.scrollsStar.position;
    [self addChild:star];
    if (animated) {
        star.scale = 0;
        [star runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.2 scale:1.3],
                         [CCScaleTo actionWithDuration:0.1 scale:1],
                         [CCCallBlock actionWithBlock:^{
            [self removeChild:self.scrollsStar cleanup:NO];
            self.scrollsStar = star;
        }], nil]];
    } else {
        [self removeChild:self.scrollsStar cleanup:NO];
        self.scrollsStar = star;
    }
}

- (void)toggleMovesStarAnimated:(BOOL)animated {
    CCSprite *star = [CCSprite spriteWithFile:@"star.png"];
    star.position = self.movesStar.position;
    [self addChild:star];
    if (animated) {
        star.scale = 0;
        [star runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.2 scale:1.3],
                         [CCScaleTo actionWithDuration:0.1 scale:1],
                         [CCCallBlock actionWithBlock:^{
            [self removeChild:self.movesStar cleanup:NO];
            self.movesStar = star;
        }], nil]];
    } else {
        [self removeChild:self.movesStar cleanup:NO];
        self.movesStar = star;
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        // Overlay
        CCSprite *overlay = [CCSprite spriteWithFile:@"overlay.png"];
        overlay.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:overlay];

        // Title
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Success"
                                                  dimensions:CGSizeMake(winSize.width, FONT_SIZE_BIG)
                                                   alignment:UITextAlignmentCenter
                                                    fontName:FONT_NAME fontSize:FONT_SIZE_BIG];
        titleLabel.color = FONT_COLOR;
        titleLabel.position = ccp(winSize.width / 2,winSize.height - (winSize.height * 0.25 / 2));
        [self addChild:titleLabel];

        // Stars
        self.completedStar = [CCSprite spriteWithFile:@"star-empty.png"];
        self.completedStar.position = ccp((winSize.width * 0.5) / 2,
                                          winSize.height * 0.55);
        [self addChild:self.completedStar];
        CCLabelTTF *completedLabel = [CCLabelTTF labelWithString:@"COMPLETED LEVEL"
                                                      dimensions:CGSizeMake(self.completedStar.contentSize.width * 1.5, FONT_SIZE_SML * 3)
                                                       alignment:UITextAlignmentCenter
                                                        fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        completedLabel.position = ccp(self.completedStar.position.x,
                                      self.completedStar.position.y - (self.completedStar.contentSize.height * 0.6));
        completedLabel.color = FONT_COLOR_LIGHT;
        [self addChild:completedLabel];

        self.movesStar = [CCSprite spriteWithFile:@"star-empty.png"];
        self.movesStar.position = ccp(winSize.width / 2,
                                      winSize.height * 0.55);
        [self addChild:self.movesStar];
        CCLabelTTF *movesLabel = [CCLabelTTF labelWithString:@"UNDER PAR MOVES"
                                                  dimensions:CGSizeMake(self.movesStar.contentSize.width * 1.5, FONT_SIZE_SML * 3)
                                                   alignment:UITextAlignmentCenter
                                                    fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        
        movesLabel.position = ccp(self.movesStar.position.x,
                                  self.movesStar.position.y - (self.movesStar.contentSize.height * 0.6));
        movesLabel.color = FONT_COLOR_LIGHT;
        [self addChild:movesLabel];

        self.scrollsStar = [CCSprite spriteWithFile:@"star-empty.png"];
        self.scrollsStar.position = ccp(winSize.width - (winSize.width * 0.5) / 2,
                                        winSize.height * 0.55);
        [self addChild:self.scrollsStar];
        CCLabelTTF *scrollsLabel = [CCLabelTTF labelWithString:@"GOT ALL SCROLLS"
                                                    dimensions:CGSizeMake(self.scrollsStar.contentSize.width * 1.5, FONT_SIZE_SML * 3)
                                                     alignment:UITextAlignmentCenter
                                                      fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        scrollsLabel.position = ccp(self.scrollsStar.position.x,
                                    self.scrollsStar.position.y - (self.scrollsStar.contentSize.height * 0.6));
        scrollsLabel.color = FONT_COLOR_LIGHT;
        [self addChild:scrollsLabel];

        // Replay Button
        CCLabelTTF *replayLabel = [CCLabelTTF labelWithString:@"Replay" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        replayLabel.color = FONT_COLOR;
        CCMenuItem *replay = [CCMenuItemLabel itemWithLabel:replayLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(replayAction)]) {
                [self.delegate replayAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];

        // Next Level Button
        CCLabelTTF *nextLabel = [CCLabelTTF labelWithString:@"Next Level" fontName:FONT_NAME fontSize:FONT_SIZE_MED];
        nextLabel.color = FONT_COLOR;
        CCMenuItem *next = [CCMenuItemLabel itemWithLabel:nextLabel block:^(id selector){
            if (self.delegate && [self.delegate respondsToSelector:@selector(nextAction)]) {
                [self.delegate nextAction];
                [self removeFromParentAndCleanup:YES];
            }
        }];
        
        self.menu = [CCMenu menuWithItems:replay,next,nil];
        self.menu.position = ccp(winSize.width / 2,winSize.height * 0.4 / 2);
        [self.menu alignItemsHorizontallyWithPadding:FONT_SIZE_MED];
        [self addChild:self.menu];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.menu = nil;
    self.completedStar = nil;
    self.scrollsStar = nil;
    self.movesStar = nil;
    [super dealloc];
}

@end
