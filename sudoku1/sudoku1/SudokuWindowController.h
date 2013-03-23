//
//  SudokuWindowController.h
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SudokuModel.h"
#import "SudokuView.h"

@interface SudokuWindowController : NSWindowController

@property (assign, nonatomic) SudokuModel* _model; // #12
@property (assign, nonatomic) IBOutlet SudokuView* _view;

@end
