//
//  SudokuView.h
//  Sudoku
//
//  Created by Matthew Miller on 3/22/13.
//  Copyright (c) 2013 Matthew Miller. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SudokuWindowController;

@interface SudokuView : NSView
{
    IBOutlet SudokuWindowController* _windowController;
    
@private
    
    SInt32 _selectionCellX;
    SInt32 _selectionCellY;
    SInt32 _selectionX;
    SInt32 _selectionY;
    
    BOOL _haveSelection;
}

@property (assign, nonatomic) IBOutlet SudokuWindowController* _windowController;

@end