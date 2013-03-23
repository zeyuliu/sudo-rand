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

@property (assign, nonatomic) IBOutlet SudokuWindowController* _windowController; //14


@end
