//
//  PuzzleAppDelegate.h
//  Puzzle
//
//  Created by Friedrich Haeupl on 24.05.15.
//  Copyright 2015 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PuzzleAppDelegate : NSObject <NSApplicationDelegate> {
@private
   NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
