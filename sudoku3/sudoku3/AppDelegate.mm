//
//  AppDelegate.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "AppDelegate.h"
#import "SudokuModel.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // removed in 16 SudokuModel* model = [[SudokuModel alloc] init]; //10
    SudokuModel* model = [SudokuModel sharedModel]; // 16
    SudokuModel* model2 = [SudokuModel sharedModel];
    SudokuModel* model3 = [SudokuModel sharedModel];
}

@end
