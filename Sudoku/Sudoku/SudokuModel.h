//
//  SudokuModel.h
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "qqwing.h"

@interface SudokuModel : NSObject
{
    
@private
    
    SudokuBoard* _sudokuBoard;
    
    int* _playerPuzzleInProgress;
    int* _compPuzzleInProgress;
}

+(SudokuModel*)sharedModel;


-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(BOOL)isBadValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y original:(BOOL)only as:(BOOL)computer;

-(void)makeComputerMove;
-(void)solve;

-(BOOL)isPuzzleSolved:(BOOL)computer;

@end
