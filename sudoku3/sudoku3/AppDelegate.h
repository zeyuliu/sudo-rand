//
//  AppDelegate.h
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SudokuWindowController.h" //18


@interface AppDelegate : NSObject <NSApplicationDelegate>
{
@private
    
    SudokuWindowController* _playerWindowController; // 18
}

@property (assign) IBOutlet NSWindow *window;
-(void)redrawWindows;
@end
