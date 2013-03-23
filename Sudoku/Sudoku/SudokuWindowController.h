//
//  SudokuWindowController.h
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SudokuModel.h"
#import "SudokuView.h"

@interface SudokuWindowController : NSWindowController
{
    SudokuModel* _model;
    
    IBOutlet SudokuView* _view;
    
    UInt32 _timerSpeed;
    
    BOOL _human;
}

@property (assign, nonatomic) SudokuModel* _model;
@property (assign, nonatomic) IBOutlet SudokuView* _view;
@property (assign) BOOL human;
@property (assign) UInt32 _timerSpeed;

-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(BOOL)isBadValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y original:(BOOL)only as:(BOOL)computer;

-(BOOL)isPuzzleSolved:(BOOL)computer;

-(void)makeComputerMove;
-(void)redrawWindow;

-(IBAction)menuSelected:(NSMenuItem*)sender;

@end
