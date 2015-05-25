//
//  myView.m
//  Grid
//
//  Created by Friedrich Haeupl on 16.05.15.
//  Copyright (c) 2015 fritz. All rights reserved.
//

#import <time.h>
#import "myView.h"



@implementation myView

- (id)initWithFrame:(NSRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
   {
      // Initialization
      NSLog(@"initWithFrame");
      [self initial];
      
   }
   
   return self;
}

// attn: awakeFromNib is called and not initWithFrame
- (void) awakeFromNib
{
   // Initialization
   NSLog(@"awakeFromNib");
   [self initial];
   
}

- (void)initial
{
   scrambled = NO;
   board[3][3].index = -1;
   blankX = 3;
   blankY = 3;
   
   for (int i=0; i<15; i++)
   {
      int col = i%4;
      int row = i/4;
      int color = (col + row)%2;
      
      board[col][row].index = i+1;
      board[col][row].color = color;
   }
   
}

- (void)drawRect:(NSRect)dirtyRect
{
   // Drawing code here.
   int col=0;
   int row=0;
   
   [[NSColor blackColor] setFill];
   NSRectFill(dirtyRect);
   
   [super drawRect:dirtyRect];
   
   //[self initial];
   
   for (col = 0;col < 4; col++)
   {
      for(row = 0; row<4; row++)
      {
         
         NSRect tileRect = NSMakeRect(col * 100.0, row * 100.0, 100, 100);
         
         if (board[col][row].index == -1)
         {
            [[NSColor blackColor] setFill];
            NSRectFill(tileRect);
            blankX = col;
            blankY = row;
            continue;
         }
         
         if (board[col][row].color == 1)
         {
            [[NSColor whiteColor] setFill];
         }
         else
         {
            [[NSColor redColor] setFill];
         }
         NSRectFill(tileRect);
         
         // select a font
         NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:48.0];
         
         // center align
         NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
         [style setAlignment:NSCenterTextAlignment];
         
         // text with Gold Color
         // https://github.com/mbarriault/McChunk/blob/master/McChunk/NSColor%2BMoreColors.m
         //
         NSColor *textColor = [NSColor colorWithDeviceRed:1. green:0.84 blue:0. alpha:1.];
         
         // add a shadow
         //
         NSShadow * shadow = [NSShadow new];
         shadow.shadowOffset = CGSizeMake(-2,-2);
         shadow.shadowColor = [NSColor grayColor];
         
         NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         font, NSFontAttributeName,
                                         [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName,
                                         style, NSParagraphStyleAttributeName,
                                         textColor,NSForegroundColorAttributeName,
                                         shadow,NSShadowAttributeName,
                                         nil];
         
         
         NSString *string = [NSString stringWithFormat:@"%d",board[col][row].index];
         [string drawInRect:tileRect withAttributes:textAttributes];
         
      }
   }
}

- doMoveX:(int)xpos Y:(int)ypos
{
   //   
   if(xpos==blankX && ypos==blankY)
   {
      NSBeep();
   }
   else if(xpos==blankX)   // blanky by xpos selected
   {
      if(ypos==blankY+1)   // if it is down
      {
         // down
         board[xpos][ypos-1] = board[xpos][ypos];
         board[xpos][ypos].index = -1;
         blankY = ypos;
      }
      else
      if(ypos==blankY-1)
      {
         // up
         board[xpos][ypos+1] = board[xpos][ypos];
         board[xpos][ypos].index = -1;
         blankY = ypos;
      }
   }
   else if(ypos==blankY)
   {
      if(xpos==blankX+1)
      {
         // right of blank
         board[xpos-1][ypos] = board[xpos][ypos];
         board[xpos][ypos].index = -1;
         blankX = xpos;
      }
      else
      if(xpos==blankX-1)
      {
         // left of blank
         board[xpos+1][ypos] = board[xpos][ypos];
         board[xpos][ypos].index = -1;
         blankX = xpos;
      }
   }
   else
   {
      NSBeep();
   }
   
   return self;
}

- (int)totalPositioned
{
   int x, y, count = 0;
   
   for(x=0; x<4; x++)
   {
      for(y=0; y<4; y++)
      {
         // NSLog(@"board[%d][%d].index=%d == %d",x,y,board[x][y].index,x*4+y);
         if(board[x][y].index == (x+1)+4*y)
         {
            count++;
            // NSLog(@"count=%d",count);
         }
      }
   }
   // NSLog(@"returns count=%d",count);
   return count;
}



- shuffle:(id)sender
{
   
   int array[16];
   int n;
   int i;
   int x;
   int y;
   n=16;
   
   //
   // http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
   //
   // Write down the numbers from 1 through N.
   // Pick a random number k between one and the number of unstruck numbers remaining (inclusive).
   // Counting from the low end, strike out the kth number not yet struck out, and write it down elsewhere.
   // Repeat from step 2 until all the numbers have been struck out.
   // The sequence of numbers written down in step 3 is now a random permutation of the original numbers.
   //
   
   for(i=0;i<15;i++)
   {
      array[i] = i+1;
   }
   array[15] = -1;
   
   
   //
   for (i = 15; i > 0; i--)
   {
      int j = (unsigned int) (lrand48()%16);
      int t = array[j];
      array[j] = array[i];
      array[i] = t;
   }
   
   for(y=0; y<4; y++)
   {
      for(x=0; x<4; x++)
      {
         int val =  array[y*4+x];
         board[x][y].index = val;
         if ( ( (val>4) && (val<9) ) 
             || ( (val>12) && (val<16)) 
             )
         {
            board[x][y].color = val % 2;
         }
         else
         {
            board[x][y].color = (1 + val) % 2;
         }
      }
   }
   
   scrambled = YES;
   [self setNeedsDisplay:YES];
   
   return self;
   
}

- (BOOL)isFlipped
{
   return YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
   NSPoint loc;
   int x, y;
   
   loc = [theEvent locationInWindow];
   loc = [self convertPoint:loc fromView: nil];
   loc.x =  loc.x;
   //loc.y = 400 - loc.y;
   loc.y =  loc.y;
   
   x = loc.x/100.0;
   y = loc.y/100.0;
   
   if (scrambled == NO) 
   {
      NSBeep();
      return;
   }
   
   [self doMoveX:x Y:y];
   
   if([self totalPositioned]==15)
   {
      [self setNeedsDisplay:YES];
      scrambled = NO;
      //[self display];
      NSRunAlertPanel(@"Congartulations!", @"Puzzle solved", @"OK", nil, nil);
   }
   else
   {
      [self setNeedsDisplay:YES];
   }
}

- (IBAction)btnScramble:(id)sender
{
   [self shuffle:sender];
   [self setNeedsDisplay:YES];
   
}

@end
