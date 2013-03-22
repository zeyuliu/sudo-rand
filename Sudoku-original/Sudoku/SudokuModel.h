//
//  SudokuModel.h
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.19.
//  This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import <Foundation/Foundation.h>

#include <map>

#include <ga/ga.h>

#include "qqwing.h"

@interface SudokuModel : NSObject
{

@private
    
    SudokuBoard* _sudokuBoard;
    
    int* _playerPuzzleInProgress;
    int* _computerPuzzleInProgress;

    // Used for "randomly guessing" computer player:
    map<unsigned int,bool> _boardsSeenHashTable;

    GASteadyStateGA* _ga;
    float _highestScore;
}

+(SudokuModel*)sharedModel;

-(void)resetWithDifficulty:(SudokuBoard::Difficulty)level;

-(NSString*)currentDifficultyAtString;

-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y;

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer;
-(BOOL)isBadValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y original:(BOOL)only as:(BOOL)computer;

-(void)makeComputerMove;
-(void)solve;

-(BOOL)isPuzzleSolved:(BOOL)computer;

@end
