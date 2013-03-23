//
//  SudokuWindowController.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuWindowController.h"


@interface SudokuWindowController ()

@end

@implementation SudokuWindowController

@synthesize _model; //12
@synthesize _view; //12

/** Remoevd in part 17
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
*/

- (id)init{ // 17
    self = [super initWithWindowNibName:@"SudokuWindow"];
    
    
    if (self)
    {
        [self showWindow:self];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    _model = [SudokuModel sharedModel]; // 17
}

@end
