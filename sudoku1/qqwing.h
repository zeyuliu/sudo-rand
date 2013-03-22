//
//  qqwing.h
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.23.
//

#ifndef Sudoku_qqwing_h
#define Sudoku_qqwing_h

#include "config.h"
#include <iostream>
#if HAVE_STRING_H == 1
#include <string.h>
#else
#include <string>
#endif
#include <stdio.h>
#include <vector>
#if HAVE_STDLIB_H == 1
#include <stdlib.h>
#else
#include <stdlib>
#endif
#if HAVE_GETTIMEOFDAY == 1
#include <sys/time.h>
#else
#include <time.h>
#endif

using namespace std;

/**
 * While solving the puzzle, log steps taken in a log item.
 * This is useful for later printing out the solve history
 * or gathering statistics about how hard the puzzle was to
 * solve.
 */
class LogItem {
public:
    enum LogType {
        GIVEN,
        SINGLE,
        HIDDEN_SINGLE_ROW,
        HIDDEN_SINGLE_COLUMN,
        HIDDEN_SINGLE_SECTION,
        GUESS,
        ROLLBACK,
        NAKED_PAIR_ROW,
        NAKED_PAIR_COLUMN,
        NAKED_PAIR_SECTION,
        POINTING_PAIR_TRIPLE_ROW,
        POINTING_PAIR_TRIPLE_COLUMN,
        ROW_BOX,
        COLUMN_BOX,
        HIDDEN_PAIR_ROW,
        HIDDEN_PAIR_COLUMN,
        HIDDEN_PAIR_SECTION,
    };
    LogItem(int round, LogType type);
    LogItem(int round, LogType type, int value, int position);
    int getRound();
    void print();
    LogType getType();
    ~LogItem();
private:
    void init(int round, LogType type, int value, int position);
    /**
     * The recursion level at which this item was gathered.
     * Used for backing out log items solve branches that
     * don't lead to a solution.
     */
    int round;
    
    /**
     * The type of log message that will determine the
     * message printed.
     */
    LogType type;
    
    /**
     * Value that was set by the operation (or zero for no value)
     */
    int value;
    
    /**
     * position on the board at which the value (if any) was set.
     */
    int position;
};

/**
 * The board containing all the memory structures and
 * methods for solving or generating sudoku puzzles.
 */
class SudokuBoard {
public:
    enum PrintStyle {
        ONE_LINE,
        COMPACT,
        READABLE,
        CSV,
    };
    enum Difficulty {
        UNKNOWN,
        SIMPLE,
        EASY,
        INTERMEDIATE,
        EXPERT,
    };
    SudokuBoard();
    bool setPuzzle(int* initPuzzle);
    void printPuzzle();
    void printSolution();
    bool solve();
    int countSolutions();
    void printPossibilities();
    bool isSolved();
    void printSolveHistory();
    void setRecordHistory(bool recHistory);
    void setLogHistory(bool logHist);
    void setPrintStyle(PrintStyle ps);
    bool generatePuzzle();
    int getGivenCount();
    int getSingleCount();
    int getHiddenSingleCount();
    int getNakedPairCount();
    int getHiddenPairCount();
    int getBoxLineReductionCount();
    int getPointingPairTripleCount();
    int getGuessCount();
    int getBacktrackCount();
    void printSolveInstructions();
    SudokuBoard::Difficulty getDifficulty();
    string getDifficultyAsString();
    ~SudokuBoard();
    
    int* getPuzzle() { return puzzle; }
    int* getSolution() { return solution; }
    
private:
    /**
     * The 81 integers that make up a sudoku puzzle.
     * Givens are 1-9, unknows are 0.
     * Once initialized, this puzzle remains as is.
     * The answer is worked out in "solution".
     */
    int* puzzle;
    
    /**
     * The 81 integers that make up a sudoku puzzle.
     * The solution is built here, after completion
     * all will be 1-9.
     */
    int* solution;
    
    /**
     * Recursion depth at which each of the numbers
     * in the solution were placed.  Useful for backing
     * out solve branches that don't lead to a solution.
     */
    int* solutionRound;
    
    /**
     * The 729 integers that make up a the possible
     * values for a suduko puzzle. (9 possibilities
     * for each of 81 squares).  If possibilities[i]
     * is zero, then the possibility could still be
     * filled in according to the sudoku rules.  When
     * a possibility is eliminated, possibilities[i]
     * is assigned the round (recursion level) at
     * which it was determined that it could not be
     * a possibility.
     */
    int* possibilities;
    
    /**
     * An array the size of the board (81) containing each
     * of the numbers 0-n exactly once.  This array may
     * be shuffled so that operations that need to
     * look at each cell can do so in a random order.
     */
    int* randomBoardArray;
    
    /**
     * An array with one element for each position (9), in
     * some random order to be used when trying each
     * position in turn during guesses.
     */
    int* randomPossibilityArray;
    
    /**
     * Whether or not to record history
     */
    bool recordHistory;
    
    /**
     * Whether or not to print history as it happens
     */
    bool logHistory;
    
    /**
     * A list of moves used to solve the puzzle.
     * This list contains all moves, even on solve
     * branches that did not lead to a solution.
     */
    vector<LogItem*>* solveHistory;
    
    /**
     * A list of moves used to solve the puzzle.
     * This list contains only the moves needed
     * to solve the puzzle, but doesn't contain
     * information about bad guesses.
     */
    vector<LogItem*>* solveInstructions;
    
    /**
     * The style with which to print puzzles and solutions
     */
    PrintStyle printStyle;
    
    /**
     * The last round of solving
     */
    int lastSolveRound;
    bool reset();
    bool singleSolveMove(int round);
    bool onlyPossibilityForCell(int round);
    bool onlyValueInRow(int round);
    bool onlyValueInColumn(int round);
    bool onlyValueInSection(int round);
    bool solve(int round);
    int countSolutions(int round, bool limitToTwo);
    bool guess(int round, int guessNumber);
    bool isImpossible();
    void rollbackRound(int round);
    bool pointingRowReduction(int round);
    bool rowBoxReduction(int round);
    bool colBoxReduction(int round);
    bool pointingColumnReduction(int round);
    bool hiddenPairInRow(int round);
    bool hiddenPairInColumn(int round);
    bool hiddenPairInSection(int round);
    void mark(int position, int round, int value);
    int findPositionWithFewestPossibilities();
    bool handleNakedPairs(int round);
    int countPossibilities(int position);
    bool arePossibilitiesSame(int position1, int position2);
    void addHistoryItem(LogItem* l);
    void markRandomPossibility(int round);
    void shuffleRandomArrays();
    void print(int* sudoku);
    void rollbackNonGuesses();
    void clearPuzzle();
    void printHistory(vector<LogItem*>* v);
    bool removePossibilitiesInOneFromTwo(int position1, int position2, int round);
    
};

int qqwing(int argc, char *argv[]);

#endif
