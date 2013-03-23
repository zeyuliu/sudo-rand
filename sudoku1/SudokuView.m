//
//  SudokuView.m
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuView.h"
#import "SudokuWindowController.h" // #14

@implementation SudokuView
@synthesize _windowController; // #14

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
