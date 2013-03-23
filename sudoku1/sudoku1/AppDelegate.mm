//
//  AppDelegate.m
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    SudokuModel* model = [SudokuModel sharedModel]; // Changed to shared in #16
    SudokuModel* model2 = [SudokuModel sharedModel];
    SudokuModel* model3 = [SudokuModel sharedModel];
}

@end
