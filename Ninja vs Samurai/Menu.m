//
//  Menu.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Menu.h"

GLubyte _opacity;

@implementation Menu
@synthesize menu = _menu;

#pragma mark Setters & Getters

- (GLubyte)opacity {
    return _opacity;
}

- (void)setOpacity:(GLubyte)o {
    _opacity = o;
    for(id item in self.children) {
        if ([item conformsToProtocol:@protocol(CCRGBAProtocol)]) {
            ((id<CCRGBAProtocol>)item).opacity = o;
        }
    }
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.opacity = 255;
    }
    return self;
}

- (void)dealloc {
    self.menu = nil;
    [super dealloc];
}

@end
