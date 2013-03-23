//
//  AppDelegate.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "AppDelegate.h"
#import "SudokuModel.h"

// 34
@interface AppDelegate (hidden)
-(void)setUpDifficultyMenu;
@end


@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

-(void)setUpDifficultyMenu
{
    NSMenu* mainMenu = [NSApp mainMenu];
    NSMenuItem* viewMenu = [mainMenu itemWithTitle:@"View"];
    
    [mainMenu removeItem:viewMenu];
    
    NSMenuItem* difficultyTopMenuItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]]
                                         initWithTitle:@"Difficulty" action:nil keyEquivalent:@""];
    
    NSMenu* difficultyTopMenu = [[NSMenu alloc] initWithTitle:@"Difficulty"];
    
    [difficultyTopMenuItem setSubmenu:difficultyTopMenu];
    
    [mainMenu insertItem:difficultyTopMenuItem atIndex:4];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // removed in 16 SudokuModel* model = [[SudokuModel alloc] init]; //10
    //SudokuModel* model = [SudokuModel sharedModel]; // 16
    //SudokuModel* model2 = [SudokuModel sharedModel];
    //SudokuModel* model3 = [SudokuModel sharedModel];
    
    _playerWindowController = [[SudokuWindowController alloc] init]; // 18
    [_playerWindowController.window setTitle:@"Player"]; // 18
    [_playerWindowController.window makeKeyAndOrderFront:nil]; //18
    
    [self setUpDifficultyMenu]; //34
}

@end
