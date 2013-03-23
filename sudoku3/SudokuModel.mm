//
//  SudokuModel.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuModel.h"
#import "AppDelegate.h"
#include "qqwing.h"
// added 28
#define mCellToArrayIndex(cx,cy,x,y) ( (cy)*27 + (y)*9 + (cx)*3 + (x) )

static SudokuModel* gSharedModel; //15

@implementation SudokuModel

/**
- (id)init // 10
{
    self = [super init];
    if (self)
    {
        int argc=3;
        char* argv[] = {"qqwing", "--generate","10"};
        qqwing(argc,argv);
        
    }
    return self;
}
 */ //removed in 27
/** removed in 36
- (id)init
{
    self = [super init];
    if (self)
    {
        
        
        _sudokuBoard = new SudokuBoard();
        _sudokuBoard->setRecordHistory(true);
        // int argc=3; // char* argv[]={“qqwing”,”–generate”,”10″}; // // qqwing(argc,argv);
        //Next are from 28
        _sudokuBoard->generatePuzzle();
        bool haveSolution = false;
        while( haveSolution == false)
        {
            haveSolution = _sudokuBoard->solve();
        }
        
        //added 28
        _playerPuzzleInProgress = new int[81];
        
        memcpy( _playerPuzzleInProgress,_sudokuBoard->getPuzzle(),81*sizeof(int));
        
        // added 32
        _sudokuBoard->printSolution();
        _playerPuzzleInProgress[mCellToArrayIndex(1, 1, 1, 1)] =0;
        
    }
    return self;
}
 */


- (id)init
{
    self = [super init];
    
    if (self)
    {
        _playerPuzzleInProgress = new int[81];
        
        srandom((unsigned)clock());
        
        [self resetWithDifficulty:SudokuBoard::UNKNOWN];
    }
    
    return (self);
}

-(BOOL)isPuzzleSolved //added 32
{
    return (memcmp (_playerPuzzleInProgress, _sudokuBoard->getSolution(), 81*sizeof(int))==0);
}

+(SudokuModel*)sharedModel // 15
{
    if (gSharedModel == nil)
    {
        gSharedModel = [[SudokuModel alloc] init];
    }
    return (gSharedModel);
}

// 28
-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY
                          xIndex:(UInt32)x yIndex:(UInt32)y
{
    int* puzzle = _sudokuBoard->getPuzzle();
    
    return( puzzle[ mCellToArrayIndex( cellX, cellY, x, y) ] );
}

-( UInt32 )getCurrentValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                           xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    return( _playerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] );
}

-( void )setCurrentValue:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                  xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    _playerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] = value;
}

// 30
-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                         xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    if ( [ self getOriginalValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y ] != 0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


//36
-(void)resetWithDifficulty:(SudokuBoard::Difficulty)level
{
    if (_sudokuBoard)
    {
        delete _sudokuBoard;
    }
    
    _sudokuBoard = new SudokuBoard();
    
    _sudokuBoard->setRecordHistory(true);
    
    bool haveLevelPuzzle = false;
    
    NSLog(@"Generating Sudoku (level=%d)...",level);
    
    while (haveLevelPuzzle == false)
    {
        bool havePuzzle = _sudokuBoard->generatePuzzle();
        
        if ( havePuzzle )
        {
            bool haveSolution = _sudokuBoard->solve();
            
            if ( ( haveSolution ) && ( ( level == SudokuBoard::UNKNOWN ) || ( _sudokuBoard->getDifficulty() == level ) ) )
            {
                haveLevelPuzzle = true;
            }
        }
    }
    
    NSLog(@"...done!");
    
    memcpy(_playerPuzzleInProgress,_sudokuBoard->getPuzzle(),81*sizeof(int));
    
    //    memcpy(_playerPuzzleInProgress,_sudokuBoard->getSolution(),81*sizeof(int));
    //    _playerPuzzleInProgress[2]=0;
    
    _sudokuBoard->printPuzzle();
    
    //        _sudokuBoard->printSolution();
    
    //36
    [[NSApp delegate] redrawWindows];
}

@end
