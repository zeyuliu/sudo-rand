//
//  SudokuAppDelegate.h
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SudokuWindowController.h"

@interface SudokuAppDelegate : NSObject <NSApplicationDelegate>
{
    
@private
    
    SudokuWindowController* _playerWindowController;
    SudokuWindowController* _compWindowController;
    
    NSTimer* _timer;
}

-(void)redrawWindows;

@end