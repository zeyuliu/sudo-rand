//
//  SudokuWindowController.h
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SudokuModel.h"//12
#import "SudokuView.h"//12

@interface SudokuWindowController : NSWindowController
@property (assign, nonatomic) SudokuModel* _model; //12
@property (assign, nonatomic) IBOutlet SudokuView* _view; // 12


// next 3 are #26
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY
                xIndex:(UInt32)x yIndex:(UInt32)y;
//30
-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                         xIndex:( UInt32 )x yIndex:( UInt32 )y;

@end
