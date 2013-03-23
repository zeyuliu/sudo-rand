//
//  SudokuView.h
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class SudokuWindowController; //14
@interface SudokuView : NSView
{
    IBOutlet SudokuWindowController* _windowController; // Do I need this? 22
    @private
    
    // 22
    SInt32 _selectionCellX;
    SInt32 _selectionCellY;
    SInt32 _selectionX;
    SInt32 _selectionY;
    
    BOOL _haveSelection;
}

@property (assign, nonatomic) IBOutlet SudokuWindowController* _windowController; //14


@end
