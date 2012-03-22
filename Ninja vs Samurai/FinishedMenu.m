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
            parmovesStar = _parmovesStar;

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
        CGSize winSize = [CCDirector sharedDirector].winSize;

        // Title
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Success"
                                                  dimensions:CGSizeMake(winSize.width, FONT_SIZE_BIG)
                                                   alignment:UITextAlignmentCenter
                                                    fontName:FONT_NAME fontSize:FONT_SIZE_BIG];
        titleLabel.color = FONT_COLOR;
        titleLabel.position = ccp(winSize.width / 2,winSize.height - (winSize.height * 0.2 / 2));
        [self addChild:titleLabel];
        
        // Stars
        self.completedStar = [CCSprite spriteWithFile:@"star.png"];
        self.completedStar.position = ccp((winSize.width * 0.5) / 2,
                                          winSize.height * 0.55);
        [self addChild:self.completedStar];
        CCLabelTTF *completedLabel = [CCLabelTTF labelWithString:@"COMPLETED"
                                                      dimensions:CGSizeMake(winSize.width, FONT_SIZE_SML)
                                                       alignment:UITextAlignmentCenter
                                                        fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        completedLabel.position = ccp(self.completedStar.position.x,
                                      self.completedStar.position.y - self.completedStar.contentSize.height / 2);
        completedLabel.color = FONT_COLOR;
        [self addChild:completedLabel];
        
        self.scrollsStar = [CCSprite spriteWithFile:@"star.png"];
        self.scrollsStar.position = ccp(winSize.width / 2,
                                        winSize.height * 0.55);
        [self addChild:self.scrollsStar];
        CCLabelTTF *scrollsLabel = [CCLabelTTF labelWithString:@"SCROLLS"
                                                    dimensions:CGSizeMake(winSize.width, FONT_SIZE_SML)
                                                     alignment:UITextAlignmentCenter
                                                      fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        scrollsLabel.position = ccp(self.scrollsStar.position.x,
                                    self.scrollsStar.position.y - self.scrollsStar.contentSize.height / 2);
        scrollsLabel.color = FONT_COLOR;
        [self addChild:scrollsLabel];
        
        self.parmovesStar = [CCSprite spriteWithFile:@"star.png"];
        self.parmovesStar.position = ccp(winSize.width - (winSize.width * 0.5) / 2,
                                          winSize.height * 0.55);
        [self addChild:self.parmovesStar];
        CCLabelTTF *parmovesLabel = [CCLabelTTF labelWithString:@"MOVES"
                                                     dimensions:CGSizeMake(winSize.width, FONT_SIZE_SML)
                                                      alignment:UITextAlignmentCenter
                                                       fontName:FONT_NAME fontSize:FONT_SIZE_SML];
        parmovesLabel.position = ccp(self.parmovesStar.position.x,
                                     self.parmovesStar.position.y - self.parmovesStar.contentSize.height / 2);
        parmovesLabel.color = FONT_COLOR;
        [self addChild:parmovesLabel];
        
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
    self.parmovesStar = nil;
    [super dealloc];
}

@end
