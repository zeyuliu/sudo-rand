//
// SudokuModel.mm
// Sudoku
//
// Created by Glenn Sugden on 2011.08.19.
// This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to:
// Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import "SudokuModel.h"

#import "SudokuAppDelegate.h"

#include <ga/GASStateGA.h>

#define mCellToArrayIndex(cx,cy,x,y)  ( ( cy ) * 27 + ( y ) * 9 + ( cx ) * 3 + ( x ) )

static SudokuModel * gSharedModel;

static bool isBad(int* puzzle, int value, int cellX, int cellY, int x, int y);
static bool isPuzzleSolved(int * puzzleProgreess, int * solution );

// GA
static float objective(GAGenome &);
static GABoolean solved(GAGeneticAlgorithm & ga);
static void ListInitializer(GAGenome &);

@interface SudokuModel ( hidden )

-( unsigned int )hashComputerBoard;
-( BOOL )isBad:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer;
-( UInt32 )getSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-( BOOL )isSolution:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y;
-( BOOL )isSolutionAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer;
-( void )GAInit;
-( void )GAStep;
-( void )checkForGASolved;

@end

@implementation SudokuModel (hidden)

-( unsigned int )hashComputerBoard
{
    unsigned int hash = 5381;
    
    for (int i = 0; i < 81; i++ )
    {
        hash = ( ( hash << 5 ) + hash ) + _computerPuzzleInProgress[i];
    }
    return hash;
}

-( BOOL )isBad:( UInt32 )value atCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer
{
    BOOL isBadInOriginal = isBad(_sudokuBoard->getPuzzle(), value, cellX, cellY, x, y);
    
    if (only == YES)
    {
        return ( isBadInOriginal );
    }
    else if (computer == YES)
    {
        return ( isBadInOriginal || isBad(_computerPuzzleInProgress, value, cellX, cellY, x, y) );
    }
    else
    {
        return ( isBadInOriginal || isBad(_playerPuzzleInProgress, value, cellX, cellY, x, y) );
    }
}

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

-( void )GAInit
{
    // Set the default values of the parameters.
    
    GAParameterList params;
    GASteadyStateGA::registerDefaultParameters(params);
    params.set(gaNpopulationSize, 81 - 18);   // population size
    params.set(gaNpCrossover, 0.6); // probability of crossover
    params.set(gaNpMutation, 0.01); // probability of mutation
    params.set(gaNnGenerations, 10000); // number of generations
    params.set(gaNpReplacement, 0.5);   // how much of pop to replace each gen
    params.set(gaNscoreFrequency, 10);  // how often to record scores
    params.set(gaNnReplacement, 4); // how much of pop to replace each gen
    params.set(gaNflushFrequency, 10);  // how often to dump scores to file
    params.set(gaNscoreFilename, "bog.dat");
    //  params.read("settings.txt");	    // grab values from file first
    
    // Now create the GA and run it.  We first create a genome with the
    // operators we want.  Since we're using a template genome, we must assign
    // all three operators.  We use the order-based crossover site when we assign
    // the crossover operator.
    
    GAListGenome<int> genome(objective);
    genome.initializer(ListInitializer);
    genome.mutator(GAListGenome<int>::SwapMutator);
    genome.userData(_computerPuzzleInProgress);
    
    // Now that we have our genome, we create the GA (it clones the genome to
    // make all of the individuals for its populations).  Set the parameters on
    // the GA then let it evolve.
    
    _ga = new GASteadyStateGA(genome);
    _ga->crossover(GAListGenome<int>::PartialMatchCrossover);
    _ga->parameters(params);
    
    std::cout << params << std::endl;
    
    _ga->terminator( solved );
    
    _ga->userData( _sudokuBoard );
    
    _ga->initialize();
    
    _highestScore = 0;
}

-( void )GAStep
{
    _ga->step();
    
    GAListGenome<int> & genome =
    ( GAListGenome<int> & )(_ga->statistics().bestIndividual() );
    SudokuBoard* sb = (SudokuBoard*)genome.geneticAlgorithm()->userData();
    int* puzzle = sb->getPuzzle();
    
    int cellX;
    int cellY;
    int x;
    int y;
    
    GAListIter<int> iter = GAListIter<int>(genome);
    
    int value = *iter.head();
    
    for (cellX = 0; cellX < 3; cellX++)
    {
        for (cellY = 0; cellY < 3; cellY++)
        {
            for (x = 0; x < 3; x++)
            {
                for (y = 0; y < 3; y++)
                {
                    int index = mCellToArrayIndex(cellX,cellY,x,y);
                    if (puzzle[index] == 0)
                    {
// Uncomment the DEBUG lines below to hide the red "bad values" for computer's current solution.
//#if DEBUG
//#else //DEBUG
//                        if ([self isBad: value atCellX: cellX andCellY: cellY
//                                 xIndex: x yIndex: y original: NO as: YES] == NO)
//#endif //DEBUG
                        {
                            [self setCurrentValue: value atCellX: cellX
                                         andCellY: cellY xIndex: x yIndex: y as: YES];
                        }
//#if DEBUG
//#else //DEBUG
//                        else
//                        {
//                            [self setCurrentValue: 0 atCellX: cellX andCellY:
//                             cellY xIndex: x yIndex: y as: YES];
//                        }
//#endif //DEBUG
                        
                        value = *iter.next();
                    }
                }
            }
        }
    }
    
    if (genome.score() > _highestScore)
    {
        _highestScore = genome.score();
        
        std::cout << "Score = " << _highestScore << std::endl;
    }
}

-( void )checkForGASolved
{
    if ( ( _ga->done() == true ) || [self isPuzzleSolved: YES])
    {
        const GAListGenome<int>& genome =
        dynamic_cast<const GAListGenome<int>&>( _ga->statistics().
                                               bestIndividual() );
        // Assign the best that the GA found to our genome then print out the results.
        std::cout << "the ga generated the following list (objective score is ";
        std::cout << genome.score() << "):\n" << genome << "\n";
        std::cout << "best of generation data are in '" <<
        _ga->scoreFilename() << "'\n";
        std::cout << _ga->parameters() << "\n";
        
        delete _ga;
        _ga = NULL;
    }
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

        _computerPuzzleInProgress = new int[81];

        srandom( (unsigned)clock() );

        [self resetWithDifficulty: SudokuBoard::UNKNOWN];
    }
    return ( self );
}

-( void )resetWithDifficulty:( SudokuBoard::Difficulty )level
{
    if (_sudokuBoard)
    {
        delete _sudokuBoard;
    }

    GASteadyStateGA* oldGA = _ga;

    _ga = NULL;

    if (oldGA)
    {
        delete oldGA;
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

            if ( ( haveSolution ) &&
                 ( ( level == SudokuBoard::UNKNOWN ) ||
                   ( _sudokuBoard->getDifficulty() == level ) ) )
            {
                haveLevelPuzzle = true;
            }
        }
    }

    NSLog(@"...done!");

    memcpy(_playerPuzzleInProgress,_sudokuBoard->getPuzzle(),81 * sizeof( int ) );

    memcpy(_computerPuzzleInProgress,_sudokuBoard->getPuzzle(),81 * sizeof( int ) );

//    memcpy(_playerPuzzleInProgress,_sudokuBoard->getSolution(),81*sizeof(int));
//    _playerPuzzleInProgress[2]=0;

    _sudokuBoard->printPuzzle();

    [self GAInit];

    _boardsSeenHashTable.clear();

//        _sudokuBoard->printSolution();

    [[NSApp delegate] redrawWindows];
}

-( void )dealloc
{
    delete _sudokuBoard;
    delete[] _playerPuzzleInProgress;
    delete[] _computerPuzzleInProgress;

    [super dealloc];
}

-( NSString* )currentDifficultyAtString
{
    switch (_sudokuBoard->getDifficulty() )
    {
        case SudokuBoard::SIMPLE:
            return @"Simple";
            break;
        case SudokuBoard::EASY:
            return @"Easy";
            break;
        case SudokuBoard::INTERMEDIATE:
            return @"Intermediate";
            break;
        case SudokuBoard::EXPERT:
            return @"Expert";
            break;
        case SudokuBoard::UNKNOWN:
            break;
    }
    return @"Random";
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
        return( _computerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] );
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
        _computerPuzzleInProgress[ mCellToArrayIndex(cellX,cellY,x,y) ] = value;
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

-( BOOL )isBadValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y original:( BOOL )only as:( BOOL )computer
{
    UInt32 value =
        [self getCurrentValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y
         as:
         computer];

    return ( [ self isBad: value atCellX: cellX andCellY: cellY xIndex: x
               yIndex: y original: only as: computer] );
}

-( BOOL )isPuzzleSolved:( BOOL )computer
{
    if ( computer )
    {
        return ( isPuzzleSolved( _computerPuzzleInProgress,
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

static float objective(GAGenome & c)
{
    GAListGenome<int> & genome = ( GAListGenome<int> & )c;
    SudokuBoard* sb = (SudokuBoard*)c.geneticAlgorithm()->userData();
    int* solution = sb->getSolution();
    int* puzzle = sb->getPuzzle();

    int cellX;
    int cellY;
    int x;
    int y;

    GAListIter<int> iter = GAListIter<int>(genome);

    int value = *iter.head();

    float score = 0.0f;

    for (cellX = 0; cellX < 3; cellX++)
    {
        for (cellY = 0; cellY < 3; cellY++)
        {
            for (x = 0; x < 3; x++)
            {
                for (y = 0; y < 3; y++)
                {
                    int index = mCellToArrayIndex(cellX,cellY,x,y);
                    if (puzzle[index] == 0)
                    {
                        if ( isBad(puzzle, value, cellX, cellY, x, y) == false )
                        {
                            score += ( value == solution[index] );
                        }
                        else
                        {
                            score -= 0.50;
                        }
                        value = *iter.next();
                    }
                }
            }
        }
    }

    return fmax(score,0.0f);
}

static GABoolean solved(GAGeneticAlgorithm & ga)
{
    GAListGenome<int> & genome =
        ( GAListGenome<int> & )(ga.statistics().bestIndividual() );
    SudokuBoard* sb = (SudokuBoard*)ga.userData();
    int* solution = sb->getSolution();
    int* computerPuzzleInProgress = (int*)genome.userData();

    return ( (GABoolean)isPuzzleSolved(computerPuzzleInProgress,solution) );
}

/* ----------------------------------------------------------------------------
   List Genome Operators
   -------------------------------------------------------------------------------
   The initializer creates a list with n elements in it and puts a unique digit
   in each one.  After we make the list, we scramble everything up.
   ---------------------------------------------------------------------------- */
static void ListInitializer(GAGenome & c)
{
    GAListGenome<int> &child = ( GAListGenome<int> & )c;
    while(child.head() )
    {
        child.destroy();             // destroy any pre-existing list

    }
    SudokuBoard* sb = (SudokuBoard*)c.geneticAlgorithm()->userData();
    int* puzzle = sb->getPuzzle();

    int cellX;
    int cellY;
    int x;
    int y;
    int n = 0;

    for (cellX = 0; cellX < 3; cellX++)
    {
        for (cellY = 0; cellY < 3; cellY++)
        {
            for (x = 0; x < 3; x++)
            {
                for (y = 0; y < 3; y++)
                {
                    if (cellX + cellY + x + y == 0)
                    {
                        child.insert(1,GAListBASE::HEAD);
                    }
                    else
                    {
                        child.insert(y * 3 + x + 1);
                    }
                    n++;
                }
            }
        }
    }

    for (cellX = 0; cellX < 3; cellX++)
    {
        for (cellY = 0; cellY < 3; cellY++)
        {
            for (x = 0; x < 3; x++)
            {
                for (y = 0; y < 3; y++)
                {
                    int index = mCellToArrayIndex(cellX,cellY,x,y);
                    if (puzzle[index] != 0)
                    {
                        for (int i = 0; i < n; i++)
                        {
                            if ( *child[i] == puzzle[index] )
                            {
                                child.remove();
                                break;
                            }
                        }
                        n--;
                    }
                }
            }
        }
    }

    for (int i = 0; i < n; i++)
    {
        child.swap(GARandomInt(0,n), GARandomInt(0,n) );
    }
}

//   Here we specialize the write method for the List class.  This lets us see
// exactly what we want (the default write method dumps out pointers to the
// data rather than the data contents).
//   This routine prints out the contents of each element of the list,
// separated by a space.  It does not put a newline at the end of the list.
//   Notice that you can specialize ANY function of a template class, but
// some compilers are more finicky about how you do it than others.  For the
// metrowerks compiler this specialization must come before the forced
// instantiation.
template<> int GAListGenome<int>::write(ostream & os) const
{
    int * cur, * head;
    GAListIter<int> tmpiter(*this);
    if( ( head = tmpiter.head() ) != 0)
    {
        os << *head << " ";
    }
    for(cur = tmpiter.next(); cur && cur != head; cur = tmpiter.next() )
    {
        os << *cur << " ";
    }
    return os.fail() ? 1 : 0;
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
