//
//  Level.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Level.h"
#import "Constants.h"

@implementation Level
@synthesize name = _name;

#pragma mark Class Methods

+ (Level *)levelWithName:(NSString *)name {
    return [[[self alloc] initWithName:name] autorelease];
}

+ (Level *)firstLevelForGroup:(int)group {
    return [self levelWithName:[NSString stringWithFormat:@"%d-1", group, nil]];
}

#pragma mark Initialize

- (id)initWithName:(NSString *)name {
    if ((self = [self init])) {
        self.name = name;
    }
    return self;
}

#pragma mark Instance Methods

- (BOOL)belongsToGroup:(int)group {
    return ([[self.name substringToIndex:[self.name rangeOfString:@"-"].length] intValue] == group);
}

- (NSString *)filename {
    return [NSString stringWithFormat:@"%@.tmx", self.name, nil];
}

- (Level *)nextLevel {
    // @todo: real one
    Level *level = [Level levelWithName:@"1-1"];
    if ([self.name compare:level.name] == 0) {
        level = [Level levelWithName:@"2-1"];
    }
    return level;
}

- (Level *)nextLevelForGroup:(int)group {
    if (group < 1 || group > LEVEL_GROUPS) return nil;

    int num = [[self.name substringFromIndex:[self.name rangeOfString:@"-"].length + 1] intValue];
    if (num < (LEVEL_COLUMNS * LEVEL_ROWS)) {
        return [Level levelWithName:[NSString stringWithFormat:@"%d-%d", group, num + 1]];
    } else {
        return nil;
    }
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
