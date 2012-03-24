//
//  Level.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Level.h"

@implementation Level
@synthesize name = _name;

#pragma mark Class Methods

+ (Level *)levelWithName:(NSString *)name {
    return [[[self alloc] initWithName:name] autorelease];
}

#pragma mark Initialize

- (id)initWithName:(NSString *)name {
    if ((self = [self init])) {
        self.name = name;
    }
    return self;
}

#pragma mark Instance Methods

- (NSString *)filename {
    return [NSString stringWithFormat:@"%@.tmx", self.name, nil];
}

- (Level *)nextLevel {
    // @todo
    return nil;
}

#pragma mark NSObject

- (id)init {
    if ((self = [super init])) {
        self.name = @"";
    }
    return self;
}

- (void)dealloc {
    self.name = nil;
    [super dealloc];
}

@end
