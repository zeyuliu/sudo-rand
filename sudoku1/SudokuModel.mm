//
//  SudokuModel.m
//  sudoku1
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuModel.h"
#include "qqwing.h"

@implementation SudokuModel

- (id)init
{
    self = [super init];
    if (self)
    {
        int argc=3;
        char* argv[] = {"qqwing", "--generate","10"};
        qqwing(argc,argv);
        
    }
    return self;
}


@end
