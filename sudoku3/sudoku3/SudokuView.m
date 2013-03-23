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
        }
    }
    
}

@end
