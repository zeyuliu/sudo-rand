//
//  SudokuAppDelegate.m
//  SudokuFinal
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import "SudokuAppDelegate.h"
#import "SudokuModel.h"

@implementation SudokuAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _playerWindowController = [[SudokuWindowController alloc] init];
    [_playerWindowController.window setTitle:@"Player"];
    _playerWindowController._human = true;
    _compWindowController = [[SudokuWindowController alloc] init];
    [_compWindowController.window setTitle:@"Computer"];
    _compWindowController._human = false;

    [_playerWindowController.window makeKeyAndOrderFront:nil];
}

@end
