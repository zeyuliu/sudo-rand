//
//  SudokuWindowController.m
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuWindowController.h"

@interface SudokuWindowController ()

@end

@implementation SudokuWindowController

@synthesize _model; // #12
@synthesize _view; // #12

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
