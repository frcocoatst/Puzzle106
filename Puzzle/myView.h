//
//  myView.h
//  Grid
//
//  Created by Friedrich Haeupl on 16.05.15.
//  Copyright (c) 2015 fritz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DIM 4

typedef struct
{
   int index;
   int color;

}element;

@interface myView : NSView
{
   element board[DIM][DIM];
   int blankX, blankY;
   BOOL scrambled;
}

- (void)initial;

@end
