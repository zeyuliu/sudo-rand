//
//  SudokuAppDelegate.mm
//  Sudoku
//
//  Created by Glenn Sugden on 2011.06.06.
//
//

#import "SudokuAppDelegate.h"

#import "SudokuModel.h"

@interface SudokuAppDelegate (hidden)

-(void)setUpDifficultyMenu;
-(void)setupGASpeedMenu;
-(void)timerFireMethod:(NSTimer*)theTimer;

@end

@implementation SudokuAppDelegate (hidden)

-(void)setUpDifficultyMenu
{
    NSMenu* mainMenu = [NSApp mainMenu];
    
    NSMenuItem* viewMenu = [mainMenu itemWithTitle:@"View"];
    NSMenuItem* formatMenu = [mainMenu itemWithTitle:@"Format"];
    
    [mainMenu removeItem:viewMenu];
    [mainMenu removeItem:formatMenu];
    
    NSMenuItem* difficultyTopMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Difficulty" action:nil keyEquivalent:@""] autorelease];
    
    NSMenu* difficultyTopMenu = [[[NSMenu alloc] initWithTitle:@"Difficulty"] autorelease];
    
    [difficultyTopMenuItem setSubmenu:difficultyTopMenu];
    
    [mainMenu insertItem:difficultyTopMenuItem atIndex:4];
    
    NSMenuItem* difficultyMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Random" action:@selector(menuSelected:) keyEquivalent:@"0"] autorelease];
    
    [difficultyMenuItem setTarget:_playerWindowController];
    
    [difficultyTopMenu addItem:difficultyMenuItem];
    
    [difficultyTopMenu addItem:[NSMenuItem separatorItem]];
    
    difficultyMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Simple" action:@selector(menuSelected:) keyEquivalent:@"1"] autorelease];
    
    [difficultyMenuItem setTarget:_playerWindowController];
    
    [difficultyTopMenu addItem:difficultyMenuItem];
    
    difficultyMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Easy" action:@selector(menuSelected:) keyEquivalent:@"2"] autorelease];
    
    [difficultyMenuItem setTarget:_playerWindowController];
    
    [difficultyTopMenu addItem:difficultyMenuItem];
    
    difficultyMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Intermediate" action:@selector(menuSelected:) keyEquivalent:@"3"] autorelease];
    
    [difficultyMenuItem setTarget:_playerWindowController];
    
    [difficultyTopMenu addItem:difficultyMenuItem];
    
    difficultyMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Expert" action:@selector(menuSelected:) keyEquivalent:@"4"] autorelease];
    
    [difficultyMenuItem setTarget:_playerWindowController];
    
    [difficultyTopMenu addItem:difficultyMenuItem];
}

-(void)setupGASpeedMenu
{
    NSMenu* mainMenu = [NSApp mainMenu];
    
    NSMenuItem* gaSpeedTopMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"GA Speed" action:nil keyEquivalent:@""] autorelease];
    
    NSMenu* gaSpeedTopMenu = [[[NSMenu alloc] initWithTitle:@"GA Speed"] autorelease];
    
    [gaSpeedTopMenuItem setSubmenu:gaSpeedTopMenu];
    
    [mainMenu insertItem:gaSpeedTopMenuItem atIndex:5];
    
    NSMenuItem* gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Very Slow" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
    
    gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Slow" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
    
    gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Moderate" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
    
    gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Fast" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
    
    gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Hyper" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
    
    [gaSpeedTopMenu addItem:[NSMenuItem separatorItem]];
    
    gaSpeedMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Solve!" action:@selector(menuSelected:) keyEquivalent:@""] autorelease];
    
    [gaSpeedMenuItem setTarget:_playerWindowController];
    
    [gaSpeedTopMenu addItem:gaSpeedMenuItem];
}

-(void)timerFireMethod:(NSTimer*)theTimer
{
    if ( [_computerWindowController isPuzzleSolved:YES ] == false )
    {
        [_computerWindowController makeComputerMove];
    }
}

@end

@implementation SudokuAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _playerWindowController = [[SudokuWindowController alloc] init];
    [_playerWindowController.window setTitle:@"Player"];
    _computerWindowController._isComputer = false;

    NSRect playerWindowFrame = [_playerWindowController.window frame];

    NSPoint onTheRightPoint = playerWindowFrame.origin;
    onTheRightPoint.x += ( playerWindowFrame.size.width + 40 );
    onTheRightPoint.y += playerWindowFrame.size.height;

    _computerWindowController = [[SudokuWindowController alloc] init];
    [_computerWindowController.window setTitle:@"Computer"];
    [_computerWindowController.window setFrameTopLeftPoint:onTheRightPoint];
    _computerWindowController._isComputer = true;

    [_playerWindowController.window makeKeyAndOrderFront:nil];

    [self changeTimerSpeed:_computerWindowController._timerSpeed];

    [self setUpDifficultyMenu];
    
    [self setupGASpeedMenu];
}

-(void)changeTimerSpeed:(CGFloat)speed
{
    if ( _timer )
    {
        [_timer invalidate];
    }

    _timer = [NSTimer scheduledTimerWithTimeInterval:speed
                                              target:self
                                            selector:@selector(timerFireMethod:)
                                            userInfo:nil
                                             repeats:YES];
}

-(void)redrawWindows
{
    [_computerWindowController redrawWindow];
    [_playerWindowController redrawWindow];
}

@end
