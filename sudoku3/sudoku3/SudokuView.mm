//
//  SudokuView.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuView.h"
#import "SudokuWindowController.h" //14

@interface SudokuView (hidden) //19
-(NSRect)drawHashInBounds: (NSRect)bounds usingColor:(NSColor*) color;//19
-(void)paintSelectionRectangle; //22
-(void)drawValueAtCellX:(int)cellX andCellY:(int)cellY inBounds:(NSRect)bounds; //25

@end

@implementation SudokuView (hidden) //19
-(NSRect)drawHashInBounds: (NSRect)bounds usingColor:(NSColor*) color //19
{
    //Actual implementation done in 20
    CGFloat top = bounds.origin.y;
    CGFloat bottom = top + bounds.size.height;
    CGFloat left = bounds.origin.x;
    CGFloat right = left + bounds.size.width;
    
    CGFloat thirdWidth = bounds.size.width / 3.0;
    CGFloat thirdHeight = bounds.size.height / 3.0;
    CGFloat lineWidth = ( thirdWidth > thirdHeight ) ? thirdWidth / 30.0 : thirdHeight / 30.0;
    
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
    // 22
-(void)paintSelectionRectangle
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



//25
-(void)drawValueAtCellX:(int)cellX andCellY:(int)cellY inBounds:(NSRect)bounds
{
    if (self._windowController._model)
    {
        CGFloat thirdWidth = bounds.size.width / 3.0;
        CGFloat thirdHeight = bounds.size.height / 3.0;
        
        for (int y=0; y<3; y++)
        {
            for (int x=0; x<3; x++)
            {
                int value = [self._windowController getCurrentValueAtCellX:cellX andCellY:cellY
                                                                    xIndex:x yIndex:y];
                
                if ( value != 0 )
                {
                    // included in 31
                    NSColor* color;
                    
                    if ([self._windowController isOriginalValueAtCellX:cellX andCellY:cellY xIndex:x yIndex:y])
                    {
                        color = [NSColor blackColor];
                    }
                    else
                    {
                        color = [NSColor blueColor];
                    }
                    NSPoint valueDrawPosition = NSMakePoint(bounds.origin.x +
                                                            x * thirdWidth + thirdWidth / 3,
                                                            bounds.origin.y +
                                                            y * thirdHeight + thirdHeight / 6);
                    
                    NSString* valueString = [NSString stringWithFormat:@"%c",(char)value+'0'];
                    
                    NSFont *font = [NSFont fontWithName:@"American Typewriter" size:thirdHeight/2.0];
                    

                    
                    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                     font, NSFontAttributeName,
                                                     color, NSForegroundColorAttributeName,
                                                     nil];
                    
                    [valueString drawAtPoint:valueDrawPosition withAttributes:attrsDictionary];
                }
            }
        }
    }
}
@end


@implementation SudokuView
@synthesize _windowController; //14

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect //19
{
    NSRect oneSquareBounds = [self drawHashInBounds:self.bounds usingColor:[NSColor blackColor]]; // 20
    for (UInt32 y = 0; y < 3; y++) // 21
    {
        for (UInt32 x = 0; x < 3; x++)
        {
            NSRect smallBounds = NSOffsetRect(oneSquareBounds, x * oneSquareBounds.size.width, y * oneSquareBounds.size.height );
            
            smallBounds = NSInsetRect(smallBounds, 4.0, 4.0);
            
            [self drawHashInBounds: smallBounds usingColor: [NSColor whiteColor]];
            
            //25
            [self drawValueAtCellX:x andCellY:y inBounds:smallBounds];
        }
    }
    
    
    // 24
    if (_haveSelection)
    {
        [self paintSelectionRectangle];
    }
    
    
    //33
    
    if ( [_windowController isPuzzleSolved]) // is this right???
    {
        NSInteger fourth = self.bounds.size.height / 4;
        
        NSColor* winColor = [NSColor colorWithSRGBRed:1.0 green:0.0 blue:0.0 alpha:0.33];
        
        NSFont *font = [NSFont fontWithName:@"Zapfino" size:60];
        
        NSDictionary* attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                         font, NSFontAttributeName, winColor, NSForegroundColorAttributeName,
                                         [NSNumber numberWithDouble:16.0], NSStrokeWidthAttributeName, nil];
        
        NSPoint solvedDrawPosition = NSMakePoint(self.bounds.origin.x, self.bounds.origin.y + fourth);
        
        [@"SOLVED!" drawAtPoint:solvedDrawPosition withAttributes:attrsDictionary];
    }
    
}

// 24
-(void)mouseDown:(NSEvent *)event
{
    NSPoint location = [event locationInWindow];
    CGFloat thirds = self.bounds.size.width / 3;
    CGFloat ninths = thirds / 3;
    
    _selectionCellX = (UInt32)( location.x / thirds );
    _selectionCellY = (UInt32)( location.y / thirds );
    _selectionX = (UInt32)( ( location.x - ( _selectionCellX * thirds ) ) / ninths );
    _selectionY = (UInt32)( ( location.y - ( _selectionCellY * thirds ) ) / ninths );
    
    // removed 30 _haveSelection = YES;
    
    if ([self._windowController isOriginalValueAtCellX:_selectionCellX andCellY:_selectionCellY
                                                xIndex:_selectionX yIndex:_selectionY] == NO)
    {
        _haveSelection = YES;
    }
    else
    {
        _haveSelection = NO;
    }

    [self setNeedsDisplay: YES];
}

//24
- (void)keyDown: (NSEvent *)theEvent
{
    BOOL handled = NO;
    
    if (_haveSelection)
    {
        NSString *theChars = [theEvent charactersIgnoringModifiers];
        unichar keyChar = [theChars characterAtIndex:0];
        
        if (keyChar>='1' && keyChar <'9')
        {
            [self._windowController setCurrentValue:keyChar-'0'
                                            atCellX:_selectionCellX
                                           andCellY:_selectionCellY
                                             xIndex:_selectionX
                                             yIndex:_selectionY];
             handled = YES;
        }
    }
    
    if (handled == NO)
    {
        [super keyDown:theEvent];
    }
    else
    {
        [self setNeedsDisplay:YES];
    }
}

// 29
- (BOOL) acceptsFirstResponder
{
    return (YES);
}

@end
