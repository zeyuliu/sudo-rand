//
//  SudokuModel.h
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "qqwing.h"

@interface SudokuModel : NSObject
{
@private
    //27
    SudokuBoard* _sudokuBoard;
    
    //28
    int* _playerPuzzleInProgress;
}

+(SudokuModel*)sharedModel; // 15

// Next 3 are 27
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY
                xIndex:(UInt32)x yIndex:(UInt32)y;

//30
-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                         xIndex:( UInt32 )x yIndex:( UInt32 )y;
//32
-(BOOL)isPuzzleSolved;
-(void)resetWithDifficulty:(SudokuBoard::Difficulty)level;
@end
