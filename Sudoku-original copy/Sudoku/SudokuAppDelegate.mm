//
//  SudokuAppDelegate.mm
//  Sudoku
//
//  Created by Glenn Sugden on 2011.06.06.
//
//

#import "SudokuAppDelegate.h"

#import "SudokuModel.h"

@interface SudokuAppDelegate (hidden)

-(void)timerFireMethod:(NSTimer*)theTimer;

@end

@implementation SudokuAppDelegate (hidden)

-(void)timerFireMethod:(NSTimer*)theTimer
{
    if ( [_compWindowController isPuzzleSolved:YES ] == false )
    {
        [_compWindowController makeComputerMove];
    }
}

@end

@implementation SudokuAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _playerWindowController = [[SudokuWindowController alloc] init];
    [_playerWindowController.window setTitle:@"Player"];
    _playerWindowController._human = true;

    NSRect playerWindowFrame = [_playerWindowController.window frame];

    _compWindowController = [[SudokuWindowController alloc] init];
    [_compWindowController.window setTitle:@"Computer"];
    _compWindowController._isComputer = true;

    [_playerWindowController.window makeKeyAndOrderFront:nil];

    UInt32 speed = 10;
    _timer = [NSTimer scheduledTimerWithTimeInterval:speed
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];

}


-(void)redrawWindows
{
    [_computerWindowController redrawWindow];
    [_playerWindowController redrawWindow];
}

@end
