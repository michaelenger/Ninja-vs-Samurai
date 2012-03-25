//
//  GameMap.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/20/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "GameMap.h"
#import "Constants.h"
#import "Path.h"

CGSize winSize;

@implementation GameMap
@synthesize mapInfo = _mapInfo,
            actors = _actors,
            walls = _walls,
            moves = _moves,
            scrolls = _scrolls;

#pragma mark Instance Methods

- (BOOL)isOpen:(CGPoint)position {
    BOOL open = YES;

    // Check boundaries
    open = open && (position.x >= 0
                    && position.y >= 0
                    && position.x < [self.walls count]
                    && position.y < [((NSArray *)[self.walls objectAtIndex:position.x]) count]);
    if (!open) {
        return NO;
    }

    // Check walls
    NSNumber *value = [[self.walls objectAtIndex:position.x] objectAtIndex:position.y];
    open = open && ([value intValue] == 0);
    if (!open) {
        return NO;
    }

    return YES;
}

- (NSArray *)pathFrom:(CGPoint)origin to:(CGPoint)desination {
    Path *path = [Path pathWithMap:self.walls from:origin to:desination];
    return path.nodes;
}

- (CGPoint)translateMapPosition:(CGPoint)position {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        return ccp(self.position.x + (position.x * TILE_WIDTH_IPAD),
                   winSize.height - self.position.y - ((position.y + 1) * TILE_HEIGHT_IPAD));
    } else {
        // iPhone
        return ccp(self.position.x + (position.x * TILE_WIDTH),
                   winSize.height - self.position.y - ((position.y + 1) * TILE_HEIGHT));
    }
}

- (CGPoint)translatePosition:(CGPoint)position {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad
        return ccp(floorf((position.x - self.position.x) / TILE_WIDTH_IPAD),
                   floorf((self.contentSize.height - (position.y - self.position.y)) / TILE_HEIGHT_IPAD));
    } else {
        // iPhone
        return ccp(floorf((position.x - self.position.x) / TILE_WIDTH),
                   floorf((self.contentSize.height - (position.y - self.position.y)) / TILE_HEIGHT));
    }
}

#pragma mark CCTMXTiledMap

-(id) initWithTMXFile:(NSString*)tmxFile {
    if((self = [super initWithTMXFile:tmxFile])) {
        self.mapInfo = [CCTMXMapInfo formatWithTMXFile:tmxFile];
        winSize = [CCDirector sharedDirector].winSize;

        // Build the array of walls
        CCTMXLayer *level = [self layerNamed:@"Level"];
        CGSize size = [level layerSize];
        NSMutableArray *walls = [NSMutableArray arrayWithCapacity:size.width];
        for (int x = 0; x < size.width; x++) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:size.height];
            for (int y = 0; y < size.height; y++) {
                unsigned int gid = [level tileGIDAt:ccp(x, y)];
                NSDictionary *info = [self.mapInfo.tileProperties objectForKey:[NSNumber numberWithInt:gid]];
                BOOL wall = NO;
                if ([info valueForKey:@"wall"]) {
                    wall = YES;
                }
                [temp addObject:[NSNumber numberWithBool:wall]];
            }
            [walls addObject:temp];
        }
        self.walls = walls;

        // Extract the actors layer
        self.actors = [self layerNamed:@"Actors"];
        if (self.actors) {
            [self removeChild:self.actors cleanup:YES];
        }

        // Determine the success conditions
        NSString *moves = [self.mapInfo.properties objectForKey:@"moves"];
        if (moves) {
            self.moves = [moves intValue];
        } else {
            self.moves = 0;
        }
        self.scrolls = 0;
        size = [self.actors layerSize];
        for (int x = 0; x < size.width; x++) {
            for (int y = 0; y < size.height; y++) {
                unsigned int gid = [self.actors tileGIDAt:ccp(x, y)];
                NSDictionary *info = [self.mapInfo.tileProperties objectForKey:[NSNumber numberWithInt:gid]];
                NSString *actorName = [info valueForKey:@"actor"];
                if (actorName && [actorName compare:@"scroll"] == 0) {
                    self.scrolls++;
                }
            }
        }
        
    }
    return self;
}

#pragma mark NSObject

- (void)dealloc {
    self.mapInfo = nil;
    self.actors = nil;
    self.walls = nil;
    [super dealloc];
}

@end
