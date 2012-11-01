//
//  Ultilities+Math.m
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/31/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "Ultilities+Math.h"

#define MAX_RANDOM  10000

double FloatRandom(double a,double b)
{
     return (rand()%(int)((b-a)*MAX_RANDOM)) / (double)MAX_RANDOM+a;
}

