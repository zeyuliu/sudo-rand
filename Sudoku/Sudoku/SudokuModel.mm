//
//  SudokuModel.m
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import "SudokuModel.h"

#import "SudokuAppDelegate.h"


#define mCellToArrayIndex(cx,cy,x,y)  ( ( cy ) * 27 + ( y ) * 9 + ( cx ) * 3 + ( x ) )

static SudokuModel * gSharedModel;

static bool isPuzzleSolved(int * puzzleProgreess, int * solution );

@interface SudokuModel ( hidden )

-( UInt32 )getSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-( BOOL )isSolution:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-( BOOL )isSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer;

@end

@implementation SudokuModel (hidden)

-( UInt32 )getSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    int* solution = _sudokuBoard->getSolution();
    
    return solution[mCellToArrayIndex(cellX,cellY,x,y)];
}

-( BOOL )isSolution:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    return ( value == [self getSolutionAtCellX: cellX andCellY: cellY xIndex: x yIndex: y ] );
}

-( BOOL )isSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer
{
    UInt32 value =
    [self getCurrentValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y
                              as:
     computer];
    
    return [ self isSolution: value atCellX: cellX andCellY: cellY xIndex: x
                      yIndex: y ];
}


@end

@implementation SudokuModel

+( SudokuModel* )sharedModel
{
    if (gSharedModel == nil)
    {
        gSharedModel = [[SudokuModel alloc] init];
    }
    
    return ( gSharedModel );
}

-( id )init
{
    self = [super init];
    
    if (self)
    {
        _playerPuzzleInProgress = new int[81];
        
        _compPuzzleInProgress = new int[81];
        
        srandom( (unsigned)clock() );
        
    }
    return ( self );
}
-(void) startGame{
    if(_sudokuBoard){
        delete _sudokuBoard;
    }
    _sudokuBoard = new SudokuBoard();
    _sudokuBoard->setRecordHistory(true);
    memcpy(_playerPuzzleInProgress,_sudokuBoard->getPuzzle(),81 * sizeof( int ) );
    memcpy(_compPuzzleInProgress,_sudokuBoard->getPuzzle(),81 * sizeof( int ) );
    _sudokuBoard->printPuzzle();
    [[NSApp delegate] redrawWindows];


}


-( void )dealloc
{
    delete _sudokuBoard;
    delete[] _playerPuzzleInProgress;
    delete[] _compPuzzleInProgress;
    
}


-( UInt32 )getOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    int* puzzle = _sudokuBoard->getPuzzle();
    
    return( puzzle[ mCellToArrayIndex( cellX, cellY, x, y) ] );
}

-( UInt32 )getCurrentValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY
                           xIndex:( UInt32 )x yIndex:( UInt32 )y as:( BOOL )computer
{
    if ( computer )
    {
        return( _compPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] );
    }
    else
    {
        return( _playerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] );
    }
}

-( void )setCurrentValue:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y as:( BOOL )computer
{
    if ( computer )
    {
        _compPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] = value;
    }
    else
    {
        _playerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] = value;
    }
}

-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    if ( [self getOriginalValueAtCellX: cellX andCellY: cellY xIndex: x yIndex:
          y] != 0 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-( BOOL )isPuzzleSolved:( BOOL )computer
{
    if ( computer )
    {
        return ( isPuzzleSolved( _compPuzzleInProgress,
                                _sudokuBoard->getSolution() ) );
    }
    else
    {
        return ( isPuzzleSolved( _playerPuzzleInProgress,
                                _sudokuBoard->getSolution() ) );
    }
}

#pragma mark Computer Player (Genetic Algorithm method)

-( void )makeComputerMove
{
    if (_ga)
    {
        [self GAStep];
        
        [self checkForGASolved];
    }
}

-( void )solve
{
    if (_ga)
    {
        while ( ( _ga->done() == false ) && ( [self isPuzzleSolved: YES] == NO ) )
        {
            [self GAStep];
        }
    }
    
    [self checkForGASolved];
}

@end

#pragma mark Helper Functions

static bool isPuzzleSolved(int * puzzleProgreess, int * solution )
{
    return( memcmp( puzzleProgreess, solution, 81 * sizeof( int ) ) == 0 );
}

static bool isBad(int* puzzle, int value, int cellX, int cellY, int x, int y)
{
    int index;
    
    if ( value > 0 )
    {
        // This cell's values
        
        for (int checkY = 0; checkY < 3; checkY++)
        {
            for (int checkX = 0; checkX < 3; checkX++)
            {
                if ( ( checkX != x ) || ( checkY != y ) )
                {
                    index = mCellToArrayIndex(cellX,cellY,checkX,checkY);
                    
                    if ( value == puzzle[index] )
                    {
                        return true;
                    }
                }
            }
        }
        
        // The column's values
        
        for (int checkCellY = 0; checkCellY < 3; checkCellY++)
        {
            if (checkCellY != cellY)
            {
                for (int checkY = 0; checkY < 3; checkY++)
                {
                    index = mCellToArrayIndex(cellX,checkCellY,x,checkY);
                    
                    if ( value == puzzle[index] )
                    {
                        return true;
                    }
                }
            }
        }
        
        // The row's values
        
        for (int checkCellX = 0; checkCellX < 3; checkCellX++)
        {
            if (checkCellX != cellX)
            {
                for (int checkX = 0; checkX < 3; checkX++)
                {
                    index = mCellToArrayIndex(checkCellX,cellY,checkX,y);
                    
                    if ( value == puzzle[index] )
                    {
                        return true;
                    }
                }
            }
        }
    }
    
    return false;
}
