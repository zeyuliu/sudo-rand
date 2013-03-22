//
//  SudokuWindowController.h
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.19.
//  This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import <Cocoa/Cocoa.h>

#import "SudokuModel.h"
#import "SudokuView.h"

@interface SudokuWindowController : NSWindowController
{
    SudokuModel* _model;
    
    IBOutlet SudokuView* _view;

    CGFloat _timerSpeed;

    BOOL _isComputer;
}

@property (assign, nonatomic) SudokuModel* _model;
@property (assign, nonatomic) IBOutlet SudokuView* _view;
@property (assign) BOOL _isComputer;
@property (assign) CGFloat _timerSpeed;

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
