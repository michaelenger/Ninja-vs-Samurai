//
//  Menu.h
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "cocos2d.h"

@interface Menu : CCLayer

@property (strong) CCMenu *menu;

// Opacity
- (GLubyte)opacity;
- (void)setOpacity:(GLubyte)o;

@end
