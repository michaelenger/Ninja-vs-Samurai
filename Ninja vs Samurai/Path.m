//
//  Path.m
//  Ninja vs Samurai
//
//  Created by Michael Enger on 3/21/12.
//  Copyright (c) 2012 The Lonely Coder. All rights reserved.
//

#import "Path.h"
#import "PathNode.h"

@interface Path (Private)

// Build a map of nodes based on the map
- (NSArray *)buildNodeMapFromMap:(NSArray *)map;

// Calculate the heuristic distance
- (int)heuristicFrom:(CGPoint)origin to:(CGPoint)destination;

// Find the neighbors of a node
- (NSArray *)neighborsOf:(PathNode *)node withMap:(NSArray *)map;

// Search for the path
- (NSArray *)search:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination;

@end

@implementation Path
@synthesize nodes = _nodes;

#pragma mark Class Methods

+ (Path *)pathWithMap:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination {

    Path *path = [[self alloc] init];
    path.nodes = [path search:[path buildNodeMapFromMap:map] from:origin to:destination];

    return [path autorelease];
}

#pragma mark Initialize

- (id)initWithMap:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination {
    if ((self = [self init])) {
        self.nodes = [self search:[self buildNodeMapFromMap:map] from:origin to:destination];
    }
    return self;
}

#pragma mark Instance Methods

- (NSArray *)buildNodeMapFromMap:(NSArray *)map {
    NSMutableArray *nodeMap = [NSMutableArray arrayWithCapacity:[map count]];
    
    for (int x = 0; x < [map count]; x++) {
        NSArray *row = (NSArray *)[map objectAtIndex:x];
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:[row count]];
        for (int y = 0; y < [row count]; y++) {
            NSNumber *wall = [row objectAtIndex:y];
            if ([wall intValue] == 1) {
                [temp addObject:[PathNode wallWithPosition:ccp(x,y)]];
            } else {
                [temp addObject:[PathNode floorWithPosition:ccp(x,y)]];
            }
        }
        [nodeMap addObject:temp];
    }
    
    return [NSArray arrayWithArray:nodeMap];
}

- (int)heuristicFrom:(CGPoint)origin to:(CGPoint)destination {
    // This is the Manhattan distance
    int d1 = abs(origin.x - destination.x);
    int d2 = abs(origin.y - destination.y);
    return d1 + d2;
}

- (NSArray *)neighborsOf:(PathNode *)node withMap:(NSArray *)map {
    NSMutableArray *neighbors = [NSMutableArray arrayWithCapacity:0];
    float x = node.position.x;
    float y = node.position.y;
    PathNode *neighbor = nil;

    // Left
    if (x > 0) {
        neighbor = (PathNode *)[(NSArray *)[map objectAtIndex:x-1] objectAtIndex:y];
        if (!neighbor.wall) {
            [neighbors addObject:neighbor];
        }
    }
    // Right
    if (x < [map count] - 1) {
        neighbor = (PathNode *)[(NSArray *)[map objectAtIndex:x+1] objectAtIndex:y];
        if (!neighbor.wall) {
            [neighbors addObject:neighbor];
        }
    }
    // Above
    if (y > 0) {
        neighbor = (PathNode *)[(NSArray *)[map objectAtIndex:x] objectAtIndex:y-1];
        if (!neighbor.wall) {
            [neighbors addObject:neighbor];
        }
    }
    // Below
    if (y < [(NSArray *)[map objectAtIndex:x] count] - 1) {
        neighbor = (PathNode *)[(NSArray *)[map objectAtIndex:x] objectAtIndex:y+1];
        if (!neighbor.wall) {
            [neighbors addObject:neighbor];
        }
    }

    return [NSArray arrayWithArray:neighbors];
}

- (NSArray *)search:(NSArray *)map from:(CGPoint)origin to:(CGPoint)destination {
    //
    // This method is copied from: http://www.briangrinstead.com/blog/astar-search-algorithm-in-javascript
    //

    if (origin.x == destination.x && origin.y == destination.y) {
        return nil;
    }

    NSMutableArray *openList = [[NSMutableArray arrayWithCapacity:0] retain];
    NSMutableArray *closedList = [[NSMutableArray arrayWithCapacity:0] retain];

    // Start node
    [openList addObject:[PathNode nodeWithPosition:origin]];

    while ([openList count] > 0) {
        // Grab the lowest f(x) to process next
        int lowInd = 0;
        for (int i = 0; i < [openList count]; i++) {
            if (((PathNode *)[openList objectAtIndex:i]).f < ((PathNode *)[openList objectAtIndex:lowInd]).f)
                lowInd = i;
        }
        PathNode *currentNode = [openList objectAtIndex:lowInd];

        // End case -- result has been found, return the traced path
        if (currentNode.position.x == destination.x && currentNode.position.y == destination.y) {
            PathNode *curr = currentNode;
            NSMutableArray *path = [NSMutableArray arrayWithCapacity:0];
            while (curr.parent) {
                [path addObject:curr];
                curr = curr.parent;
            }

            return [NSArray arrayWithArray:[[path reverseObjectEnumerator] allObjects]];
        }

        // Normal case -- move currentNode from open to closed, process each of its neighbors
        [openList removeObject:currentNode];
        [closedList addObject:currentNode];
        NSArray *neighbors = [self neighborsOf:currentNode withMap:map];

        for (int i = 0; i < [neighbors count]; i++) {
            PathNode *neighbor = (PathNode *)[neighbors objectAtIndex:i];
            if (neighbor.wall || [closedList indexOfObject:neighbor] != NSNotFound) {
                continue;
            }

            // g score is the shortest distance from start to current node, we need to check if
            //	 the path we have arrived at this neighbor is the shortest one we have seen yet
            int gScore = currentNode.g + 10; // 10 is the distance from a node to it's neighbor
            BOOL gScoreIsBest = NO;

            if([openList indexOfObject:neighbor] == NSNotFound) {
                // This the the first time we have arrived at this node, it must be the best
                // Also, we need to take the h (heuristic) score since we haven't done so yet

                gScoreIsBest = YES;
                neighbor.h = [self heuristicFrom:neighbor.position to:destination];
                [openList addObject:neighbor];
            } else if (gScore < neighbor.g) {
                // We have already seen the node, but last time it had a worse g (distance from start)
                gScoreIsBest = true;
            }

            if(gScoreIsBest) {
                // Found an optimal (so far) path to this node.	 Store info on how we got here and
                //	just how good it really is...
                neighbor.parent = currentNode;
                neighbor.g = gScore;
                neighbor.f = neighbor.g + neighbor.h;
            }
        }
    }

    // Cleanup
    [openList release];
    [closedList release];

    // No result was found -- empty variable signifies failure to find path
    return nil;
}

#pragma mark NSObject

- (void)dealloc {
    self.nodes = nil;
    [super dealloc];
}

@end
