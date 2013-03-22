//
//  AppDelegate.m
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuAppDelegate.h"

@implementation SudokuAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    SudokuModel* model = [[SudokuModel alloc] init];
}

@end
