//
//  SudokuModel.m
//  sudoku3
//
//  Created by James Jia on 3/22/13.
//  Copyright (c) 2013 self. All rights reserved.
//

#import "SudokuModel.h"
#include "qqwing.h"

static SudokuModel* gSharedModel; //15

@implementation SudokuModel

- (id)init // 10
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

+(SudokuModel*)sharedModel // 15
{
    if (gSharedModel == nil)
    {
        gSharedModel = [[SudokuModel alloc] init];
    }
    return (gSharedModel);
}

@end
