//
//  ResultsMenu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/23/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "ResultsMenu.h"
#import "Constants.h"

@implementation ResultsMenu
@synthesize completedStar = _completedStar,
            scrollsStar = _scrollsStar,
            movesStar = _movesStar;

#pragma mark Class Methods

+ (ResultsMenu *)menuWithTitle:(NSString *)title completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    return [[[self alloc] initWithTitle:title completed:completed moves:moves scrolls:scrolls] autorelease];
}

#pragma mark Initialize

- (id)initWithTitle:(NSString *)title {
    if ((self = [self init])) {
        self.contentSize = [CCDirector sharedDirector].winSize;
        unsigned int fontSize = FONT_SIZE_SML;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            fontSize = FONT_SIZE_MED;
        }
        
        // Overlay
        CCSprite *overlay = [CCSprite spriteWithSpriteFrameName:@"overlay.png"];
        overlay.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:overlay];
        
        // Title
        CCLabelBMFont *titleLabel = [CCLabelBMFont labelWithString:title fntFile:FONT_LARGE];
        titleLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height - (titleLabel.contentSize.height * 0.75));
        [self addChild:titleLabel];
        
        // Stars
        self.completedStar = [CCSprite spriteWithSpriteFrameName:@"star-empty.png"];
        self.completedStar.position = ccp((self.contentSize.width * 0.5) / 2,
                                          self.contentSize.height * 0.55);
        [self addChild:self.completedStar];
        CCLabelTTF *completedLabel = [CCLabelTTF labelWithString:@"COMPLETED LEVEL"
                                                      dimensions:CGSizeMake(self.completedStar.contentSize.width * 1.5, fontSize * 3)
                                                       alignment:UITextAlignmentCenter
                                                        fontName:FONT_NAME fontSize:fontSize];
        completedLabel.position = ccp(self.completedStar.position.x,
                                      self.completedStar.position.y - (self.completedStar.contentSize.height * 0.6));
        completedLabel.color = FONT_COLOR_LIGHT;
        [self addChild:completedLabel];
        
        self.movesStar = [CCSprite spriteWithSpriteFrameName:@"star-empty.png"];
        self.movesStar.position = ccp(self.contentSize.width / 2,
                                      self.contentSize.height * 0.55);
        [self addChild:self.movesStar];
        CCLabelTTF *movesLabel = [CCLabelTTF labelWithString:@"UNDER PAR MOVES"
                                                  dimensions:CGSizeMake(self.movesStar.contentSize.width * 1.5, fontSize * 3)
                                                   alignment:UITextAlignmentCenter
                                                    fontName:FONT_NAME fontSize:fontSize];
        
        movesLabel.position = ccp(self.movesStar.position.x,
                                  self.movesStar.position.y - (self.movesStar.contentSize.height * 0.6));
        movesLabel.color = FONT_COLOR_LIGHT;
        [self addChild:movesLabel];
        
        self.scrollsStar = [CCSprite spriteWithSpriteFrameName:@"star-empty.png"];
        self.scrollsStar.position = ccp(self.contentSize.width - (self.contentSize.width * 0.5) / 2,
                                        self.contentSize.height * 0.55);
        [self addChild:self.scrollsStar];
        CCLabelTTF *scrollsLabel = [CCLabelTTF labelWithString:@"GOT ALL SCROLLS"
                                                    dimensions:CGSizeMake(self.scrollsStar.contentSize.width * 1.5, fontSize * 3)
                                                     alignment:UITextAlignmentCenter
                                                      fontName:FONT_NAME fontSize:fontSize];
        scrollsLabel.position = ccp(self.scrollsStar.position.x,
                                    self.scrollsStar.position.y - (self.scrollsStar.contentSize.height * 0.6));
        scrollsLabel.color = FONT_COLOR_LIGHT;
        [self addChild:scrollsLabel];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title completed:(BOOL)completed moves:(BOOL)moves scrolls:(BOOL)scrolls {
    if ((self = [self initWithTitle:title])) {
        if (completed) {
            [self toggleCompletedStarAnimated:NO];
        }
        if (moves) {
            [self toggleMovesStarAnimated:NO];
        }
        if (scrolls) {
            [self toggleScrollsStarAnimated:NO];
        }
    }
    return self;
}

#pragma mark Instance Methods

- (void)toggleCompletedStarAnimated:(BOOL)animated {
    CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"star.png"];
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
    CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"star.png"];
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
    CCSprite *star = [CCSprite spriteWithSpriteFrameName:@"star.png"];
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

- (void)dealloc {
    self.completedStar = nil;
    self.scrollsStar = nil;
    self.movesStar = nil;
    [super dealloc];
}

@end
