//
//  SudokuWindowController.mm
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.19.
//  This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to:
//  Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import "SudokuWindowController.h"

#import "SudokuAppDelegate.h"

const CGFloat kTimerSpeedVerySlow = (1.0f / 0.25f);
const CGFloat kTimerSpeedSlow = (1.0f / 0.5f);
const CGFloat kTimerSpeedModerate = (1.0f / 1.0f);
const CGFloat kTimerSpeedFast = (1.0f / 4.0f);
const CGFloat kTimerSpeedHyper = (1.0f / 240.0f);

@implementation SudokuWindowController

@synthesize _model;
@synthesize _view;
@synthesize _isComputer;
@synthesize _timerSpeed;

- (id)init
{
    self = [super initWithWindowNibName:@"SudokuWindow"];
    
    if ( self )
    {
        [self showWindow:self];
        _timerSpeed = kTimerSpeedSlow;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.window setAspectRatio:NSMakeSize(1.0, 1.0)];
    
    _model = [SudokuModel sharedModel];
    
    [_view setNeedsDisplay:YES];
}

-(void)dealloc
{
    [_model release];
    [_view release];
    
    [super dealloc];
}

-( BOOL )isOriginalValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY xIndex:( UInt32 )x yIndex:( UInt32 )y
{
    return ([_model isOriginalValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y]);
}

-(UInt32)getOriginalValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y
{
    return ([self._model getOriginalValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y]);
}

-(UInt32)getCurrentValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer
{
    return ([self._model getCurrentValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y as:computer]);
}

-(void)setCurrentValue:(UInt32)value atCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y as:(BOOL)computer
{
    [self._model setCurrentValue:value atCellX:cellX andCellY:cellY xIndex:x yIndex:y as:computer];
}

-(BOOL)isBadValueAtCellX:(UInt32)cellX andCellY:(UInt32)cellY xIndex:(UInt32)x yIndex:(UInt32)y original:(BOOL)only as:(BOOL)computer
{
    return ([_model isBadValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y original:only as:computer]);
}

-(BOOL)isPuzzleSolved:(BOOL)computer
{
    return ([_model isPuzzleSolved:computer]);
}

-(void)makeComputerMove
{
    [_model makeComputerMove];
    
    [_view setNeedsDisplay:YES];
}

-(void)redrawWindow
{
    [_view setNeedsDisplay:YES];
}

-(IBAction)menuSelected:(NSMenuItem*)sender
{
    NSString *name = sender.title;
    CGFloat oldTimerSpeed = _timerSpeed;

    if ([name isEqualToString:@"Simple"])
    {
        [_model resetWithDifficulty:SudokuBoard::SIMPLE];
    }
    else if ([name isEqualToString:@"Easy"])
    {
        [_model resetWithDifficulty:SudokuBoard::EASY];
    }
    else if ([name isEqualToString:@"Intermediate"])
    {
        [_model resetWithDifficulty:SudokuBoard::INTERMEDIATE];
    }
    else if ([name isEqualToString:@"Expert"])
    {
        [_model resetWithDifficulty:SudokuBoard::EXPERT];
    }
    else if ([name isEqualToString:@"Random"])
    {
        [_model resetWithDifficulty:SudokuBoard::UNKNOWN];
    }

    else if ([name isEqualToString:@"Very Slow"])
    {
        _timerSpeed = kTimerSpeedVerySlow;
    }
    else if ([name isEqualToString:@"Slow"])
    {
        _timerSpeed = kTimerSpeedSlow;
    }
    else if ([name isEqualToString:@"Moderate"])
    {
        _timerSpeed = kTimerSpeedModerate;
    }
    else if ([name isEqualToString:@"Fast"])
    {
        _timerSpeed = kTimerSpeedFast;
    }
    else if ([name isEqualToString:@"Hyper"])
    {
        _timerSpeed = kTimerSpeedHyper;
    }
    else if ([name isEqualToString:@"Solve!"])
    {
        [_model solve];
    }

    if ( _timerSpeed != oldTimerSpeed )
    {
        [[NSApp delegate] changeTimerSpeed:_timerSpeed];
    }

    [[NSApp delegate] redrawWindows];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(menuSelected:))
    {
        if ( ( [[_model currentDifficultyAtString] isEqualToString:menuItem.title]) ||
            ( ( [menuItem.title isEqualToString:@"Very Slow"] ) && (_timerSpeed == kTimerSpeedVerySlow ) ) ||
            ( ( [menuItem.title isEqualToString:@"Slow"] ) && (_timerSpeed == kTimerSpeedSlow ) ) ||
            ( ( [menuItem.title isEqualToString:@"Moderate"] ) && (_timerSpeed == kTimerSpeedModerate ) ) ||
            ( ( [menuItem.title isEqualToString:@"Fast"] ) && (_timerSpeed == kTimerSpeedFast ) ) ||
            ( ( [menuItem.title isEqualToString:@"Hyper"] ) && (_timerSpeed == kTimerSpeedHyper ) ) )
        {
            [menuItem setState:NSOnState];
        }
        else
        {
            [menuItem setState:NSOffState];
        }
    }

    return YES;
}

@end
