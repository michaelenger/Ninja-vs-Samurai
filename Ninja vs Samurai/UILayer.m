//
//  UILayer.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/22/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "UILayer.h"

NSString * const FONTNAME = @"Marker Felt"; // @todo: custom font
unsigned int const FONTSIZE = 50;

@implementation UILayer
@synthesize damageIndicator = _damageIndicator,
            moves = _moves,
            movesLabel = _movesLabel;

#pragma mark Class Methods

+ (UILayer *)layer {
    return [self node];
}

#pragma mark Instance Methods

- (void)flashDamage {
    [self.damageIndicator stopAllActions];
    self.damageIndicator.opacity = 255;
    [self.damageIndicator runAction:[CCFadeOut actionWithDuration:1]];
}

- (void)update {
    [self.movesLabel setString:[NSString stringWithFormat:@"%d",self.moves,nil]];
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        // Moves label
        self.moves = 0;
        self.movesLabel = [CCLabelTTF labelWithString:@""
                                           dimensions:CGSizeMake(self.contentSize.width-(FONTSIZE / 2), FONTSIZE)
                                            alignment:UITextAlignmentRight
                                             fontName:FONTNAME
                                             fontSize:FONTSIZE];
        self.movesLabel.color = ccc3(137,134,117);
        self.movesLabel.position = ccp(self.contentSize.width/2,
                                       self.contentSize.height-(FONTSIZE / 2));
        [self addChild:self.movesLabel];

        // Damage splash sprite
        self.damageIndicator = [CCSprite spriteWithFile:@"damage.png"];
        self.damageIndicator.position = ccp(self.contentSize.width / 2,
                                            self.contentSize.height / 2);
        self.damageIndicator.opacity = 0;
        [self addChild:self.damageIndicator];

        [self update];
    }
    return self;
}

- (void)dealloc {
    self.damageIndicator = nil;
    self.movesLabel = nil;
    [super dealloc];
}

@end
