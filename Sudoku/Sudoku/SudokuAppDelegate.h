//
//  SudokuAppDelegate.h
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.19.
//  This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import <Cocoa/Cocoa.h>

#import "SudokuWindowController.h"

@interface SudokuAppDelegate : NSObject <NSApplicationDelegate>
{
    
@private
    
    SudokuWindowController* _playerWindowController;
    SudokuWindowController* _computerWindowController;
    
    NSTimer* _timer;
}

-(void)changeTimerSpeed:(CGFloat)speed;
-(void)redrawWindows;

@end
