//
//  Level.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/24/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Level.h"
#import "Constants.h"

@interface Level (Private)

// Extract the group/number from the name
- (int)groupFromName:(NSString *)name;
- (int)numberFromName:(NSString *)name;

@end

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
    return ([self groupFromName:self.name] == group);
}

- (NSString *)filename {
    return [NSString stringWithFormat:@"%@.tmx", self.name, nil];
}

- (int)groupFromName:(NSString *)name {
    return [[name substringToIndex:[name rangeOfString:@"-"].length] intValue];
}

- (Level *)nextLevel {
    int group = [self groupFromName:self.name];
    int number = [self numberFromName:self.name];

    number++;
    if (number > (LEVEL_COLUMNS * LEVEL_ROWS)) {
        group++;
        number = 1;
    }
    if (group > LEVEL_GROUPS) {
        group = 1;
    }

    return [Level levelWithName:[NSString stringWithFormat:@"%d-%d", group, number, nil]];
}

- (Level *)nextLevelForGroup:(int)group {
    if (group < 1 || group > LEVEL_GROUPS) return nil;

    int num = [self numberFromName:self.name];
    if (num < (LEVEL_COLUMNS * LEVEL_ROWS)) {
        return [Level levelWithName:[NSString stringWithFormat:@"%d-%d", group, num + 1]];
    } else {
        return nil;
    }
}

- (int)numberFromName:(NSString *)name {
    return [[name substringFromIndex:[name rangeOfString:@"-"].length + 1] intValue];
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
