//
//  SudokuAppDelegate.m
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import "SudokuAppDelegate.h"

#import "SudokuModel.h"

@interface SudokuAppDelegate (hidden)

-(void)timerFireMethod:(NSTimer*)theTimer;

@end

@implementation SudokuAppDelegate (hidden)

-(void)timerFireMethod:(NSTimer*)theTimer
{
    if ( [_computerWindowController isPuzzleSolved:YES ] == false )
    {
        [_computerWindowController makeComputerMove];
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
    _compWindowController._human = false;
    
    [_playerWindowController.window makeKeyAndOrderFront:nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:speed
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];
}


-(void)redrawWindows
{
    [_compWindowController redrawWindow];
    [_playerWindowController redrawWindow];
}

@end