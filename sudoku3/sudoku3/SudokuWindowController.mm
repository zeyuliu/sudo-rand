//
//  SudokuWindowController.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuWindowController.h"
#import "AppDelegate.h"


@interface SudokuWindowController ()

@end

@implementation SudokuWindowController

@synthesize _model; //12
@synthesize _view; //12

/** Remoevd in part 17
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
*/

- (id)init{ // 17
    self = [super initWithWindowNibName:@"SudokuWindow"];
    
    
    if (self)
    {
        [self showWindow:self];
    }
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.window setAspectRatio:NSMakeSize(1.0, 1.0)];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    _model = [SudokuModel sharedModel]; // 17
    
    [_view setNeedsDisplay:YES]; // 29
}

//30

-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                         xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    return ([_model isOriginalValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y]);
}

// 26
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y
{
    return ([self._model getOriginalValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y]);
}

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y
{
    return ([self._model getCurrentValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y]);
}

-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y
{
    [self._model setCurrentValue:value atCellX:cellX andCellY:cellY xIndex:x yIndex:y];
}

//32
-(BOOL)isPuzzleSolved
{
    return ([_model isPuzzleSolved]);
}

// 36
-(IBAction)menuSelected:(NSMenuItem*)sender
{
    NSString *name = sender.title;
    
    if ([name isEqualToString:@"Simple"])
    {
        [_model resetWithDifficulty:SudokuBoard::SIMPLE];
    }
    else if ([name isEqualToString:@"Easy"])
    {
        [_model resetWithDifficulty:SudokuBoard::EASY];
    }
    else if ([name isEqualToString:@"Intermediate"])
    {
        [_model resetWithDifficulty:SudokuBoard::INTERMEDIATE];
    }
    else if ([name isEqualToString:@"Expert"])
    {
        [_model resetWithDifficulty:SudokuBoard::EXPERT];
    }
    else // Random
    {
        [_model resetWithDifficulty:SudokuBoard::UNKNOWN];
    }
}

// 36
-(void)redrawWindow
{
    [_view setNeedsDisplay:YES];
}
@end
