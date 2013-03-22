//
//  SudokuView.mm
//  Sudoku
//
//  Created by Glenn Sugden on 2011.08.19.
//  This source is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import "SudokuView.h"

#import "SudokuWindowController.h"

const unichar kForwardDeleteKey = 63272;
const unichar kDeleteKey = 127;

@interface SudokuView ( hidden )

-( NSRect )drawHashInBounds:( NSRect )bounds usingColor:( NSColor* )color;
-( void )drawValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY inBounds:( NSRect )bounds as:( BOOL )computer;
-( void )moveSelectionX:( SInt32 )dx andY:( SInt32 )dy;
-( void )paintSelectionRectangle;

@end

@implementation SudokuView ( hidden )

-( NSRect )drawHashInBounds:( NSRect )bounds usingColor:( NSColor* )color
{
    CGFloat top = bounds.origin.y;
    CGFloat bottom = top + bounds.size.height;
    CGFloat left = bounds.origin.x;
    CGFloat right = left + bounds.size.width;

    CGFloat thirdWidth = bounds.size.width / 3.0;
    CGFloat thirdHeight = bounds.size.height / 3.0;
    
    CGFloat lineWidth = ( thirdWidth > thirdHeight ) ? thirdWidth / 50.0 : thirdHeight / 50.0;

    NSBezierPath* framePath = [NSBezierPath bezierPath];

    [framePath moveToPoint: NSMakePoint(left + thirdWidth,top)];
    [framePath lineToPoint: NSMakePoint(left + thirdWidth,bottom)];

    [framePath moveToPoint: NSMakePoint(right - thirdWidth,top)];
    [framePath lineToPoint: NSMakePoint(right - thirdWidth,bottom)];

    [framePath moveToPoint: NSMakePoint(left,top + thirdHeight)];
    [framePath lineToPoint: NSMakePoint(right,top + thirdHeight)];

    [framePath moveToPoint: NSMakePoint(left,bottom - thirdHeight)];
    [framePath lineToPoint: NSMakePoint(right,bottom - thirdHeight)];

    [color setStroke];

    [framePath setLineWidth: lineWidth];

    [framePath stroke];

    return( NSMakeRect( bounds.origin.x, bounds.origin.y, thirdWidth, thirdHeight ) );
}

-( void )drawValueAtCellX:( UInt32 )cellX andCellY:( UInt32 )cellY inBounds:( NSRect )bounds as:( BOOL )computer
{
    if (self._windowController._model)
    {
        CGFloat thirdWidth = bounds.size.width / 3.0;
        CGFloat thirdHeight = bounds.size.height / 3.0;
        
        for (UInt32 y = 0; y < 3; y++)
        {
            for (UInt32 x = 0; x < 3; x++)
            {
                UInt32 value = [self._windowController getCurrentValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y as: computer];
                
                if ( value != 0 )
                {
                    NSColor* color;
                    
                    if ([self._windowController isOriginalValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y])
                    {
                        color = [NSColor blackColor];
                    }
                    else
                    {
                        if ([self._windowController isBadValueAtCellX: cellX andCellY: cellY xIndex: x yIndex: y original: NO as: computer])
                        {
                            color = [NSColor redColor];
                            if ( computer )
                            {
                                if ( [self._windowController isPuzzleSolved: YES] == false )
                                {
                                    color = [color colorWithAlphaComponent: 0.5];
                                }
                            }
                        }
                        else
                        {
                            if (computer)
                            {
                                color = [NSColor orangeColor];
                                if ( [self._windowController isPuzzleSolved: YES] == false )
                                {
                                    color = [color colorWithAlphaComponent: 0.5];
                                }
                            }
                            else
                            {
                                color = [NSColor blueColor];
                            }
                        }
                    }
                    
                    NSPoint valueDrawPosition = NSMakePoint(bounds.origin.x + x * thirdWidth + thirdWidth / 3, bounds.origin.y + y * thirdHeight + thirdHeight / 6);
                    
                    NSString* valueString = [NSString stringWithFormat:@"%c",(char)value+'0'];
                    
                    NSFont * font = [NSFont fontWithName: @"American Typewriter" size: thirdHeight / 2.0];
                    
                    NSDictionary * attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font,NSFontAttributeName,color,NSForegroundColorAttributeName,nil];
                    
                    [valueString drawAtPoint: valueDrawPosition withAttributes: attrsDictionary];
                }
            }
        }
    }
}

-( void )moveSelectionX:( SInt32 )dx andY:( SInt32 )dy
{
    do
    {
        _selectionX += dx;
        _selectionY += dy;
        
        if ( _selectionX < 0 )
        {
            _selectionX = 2;
            _selectionCellX = ( _selectionCellX + 2 ) % 3;
        }
        else if ( _selectionX > 2 )
        {
            _selectionX = 0;
            _selectionCellX = ( _selectionCellX + 4 ) % 3;
        }
        else if ( _selectionY < 0 )
        {
            _selectionY = 2;
            _selectionCellY = ( _selectionCellY + 2 ) % 3;
        }
        else if ( _selectionY > 2 )
        {
            _selectionY = 0;
            _selectionCellY = ( _selectionCellY + 4 ) % 3;
        }
    }
    while ( [self._windowController isOriginalValueAtCellX: _selectionCellX andCellY: _selectionCellY xIndex: _selectionX yIndex: _selectionY] == true);
}

-( void )paintSelectionRectangle
{
    CGFloat thirdWidth = self.bounds.size.width / 3.0;
    CGFloat thirdHeight = self.bounds.size.height / 3.0;
    CGFloat ninthWidth = thirdWidth / 3.0;
    CGFloat ninthHeight = thirdHeight / 3.0;

    NSRect selectionRect = NSMakeRect(_selectionCellX * thirdWidth + _selectionX * ninthWidth,
                                      _selectionCellY * thirdHeight + _selectionY * ninthHeight,
                                      ninthWidth, ninthHeight);

    NSColor* selectionColor = [NSColor colorWithSRGBRed: 0.0 green: 0.0 blue: 1.0
                               alpha: 0.5];

    [selectionColor setFill];

    NSBezierPath* selectionPath = [NSBezierPath bezierPathWithRoundedRect: selectionRect
                                                                  xRadius: ( ninthWidth / 4.0 )
                                                                  yRadius: ( ninthHeight / 4.0 )];

    [selectionPath fill];
}

@end

@implementation SudokuView

@synthesize _windowController;

-( void )awakeFromNib
{
    _selectionCellX = -1;
    _selectionCellY = -1;
    _selectionX = -1;
    _selectionY = -1;
    _haveSelection = NO;
}

-( void )drawRect:( NSRect )dirtyRect
{
    NSRect oneSquareBounds = [self drawHashInBounds: self.bounds usingColor: [NSColor blackColor]];

    for (UInt32 y = 0; y < 3; y++)
    {
        for (UInt32 x = 0; x < 3; x++)
        {
            NSRect smallBounds = NSOffsetRect(oneSquareBounds, x * oneSquareBounds.size.width, y * oneSquareBounds.size.height );
            
            smallBounds = NSInsetRect(smallBounds, 4.0, 4.0);

            [self drawHashInBounds: smallBounds usingColor: [NSColor whiteColor]];

            [self drawValueAtCellX: x andCellY: y inBounds: smallBounds as: self._windowController._isComputer];
        }
    }

    if (_haveSelection)
    {
        [self paintSelectionRectangle];
    }

    if ( ( ( ( self._windowController._isComputer == NO ) && [self._windowController isPuzzleSolved: NO] ) ) ||
         ( ( self._windowController._isComputer == YES ) && [self._windowController isPuzzleSolved: YES] ) )
    {
        NSInteger fourth = self.bounds.size.height / 4;

        NSColor* winColor = [NSColor colorWithSRGBRed: 1.0 green: 0.0 blue: 0.0 alpha: 0.33];

        NSFont * font = [NSFont fontWithName: @"Zapfino" size: 60];

        NSDictionary* attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys: font,NSFontAttributeName,winColor,NSForegroundColorAttributeName, [NSNumber numberWithDouble: 16.0],NSStrokeWidthAttributeName,nil];

        NSPoint solvedDrawPosition = NSMakePoint(self.bounds.origin.x, self.bounds.origin.y + fourth);

        [@"SOLVED!" drawAtPoint: solvedDrawPosition withAttributes: attrsDictionary];
    }
}

-( BOOL ) acceptsFirstResponder
{
    return ( self._windowController._isComputer == NO );
}

-( void )mouseDown:( NSEvent * )event
{
    if ( self._windowController._isComputer == NO )
    {
        NSPoint location = [event locationInWindow];

        CGFloat thirds = self.bounds.size.width / 3;

        CGFloat ninths = thirds / 3;

        _selectionCellX = (UInt32)( location.x / thirds );

        _selectionCellY = (UInt32)( location.y / thirds );

        _selectionX = (UInt32)( ( location.x - ( _selectionCellX * thirds ) ) / ninths );

        _selectionY = (UInt32)( ( location.y - ( _selectionCellY * thirds ) ) / ninths );

        if ([_windowController isOriginalValueAtCellX: _selectionCellX andCellY: _selectionCellY xIndex: _selectionX yIndex: _selectionY] == NO)
        {
            _haveSelection = YES;
        }
        else
        {
            _haveSelection = NO;
        }

        [self setNeedsDisplay: YES];
    }
}

-( void )keyDown:( NSEvent * )theEvent
{
    BOOL handled = NO;

    if (_haveSelection)
    {
        NSString * theChars = [theEvent charactersIgnoringModifiers];

        unichar keyChar = [theChars characterAtIndex: 0];

    // arrow keys have this mask
        if ([theEvent modifierFlags] & NSNumericPadKeyMask)
        {
            if ( keyChar == NSLeftArrowFunctionKey )
            {
                [self moveSelectionX: -1 andY: 0];
                handled = true;
            }
            else if ( keyChar == NSRightArrowFunctionKey )
            {
                [self moveSelectionX: +1 andY: 0];
                handled = true;
            }
            else if ( keyChar == NSUpArrowFunctionKey )
            {
                [self moveSelectionX: 0 andY: +1];
                handled = true;
            }
            else if ( keyChar == NSDownArrowFunctionKey )
            {
                [self moveSelectionX: 0 andY: -1];
                handled = true;
            }
        }
        else if (keyChar == kForwardDeleteKey || keyChar == kDeleteKey)
        {
            [self._windowController setCurrentValue: 0 atCellX: _selectionCellX andCellY: _selectionCellY xIndex: _selectionX yIndex: _selectionY as: NO];
            handled = true;
        }
        else if (keyChar >= '1' && keyChar <= '9')
        {
            [self._windowController setCurrentValue: keyChar - '0' atCellX: _selectionCellX andCellY: _selectionCellY xIndex: _selectionX yIndex: _selectionY as: NO];
            handled = true;
        }
    }

    if (handled == NO)
    {
        [super keyDown: theEvent];
    }
    else
    {
        [self setNeedsDisplay: YES];
    }
}

@end