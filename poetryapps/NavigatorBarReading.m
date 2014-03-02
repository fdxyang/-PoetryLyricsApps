//
//  NavigatorBarReading.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/3/2.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "NavigatorBarReading.h"

@implementation NavigatorBarReading

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _TitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 290, 65)];
        _TitleLab.text = @"設定";
        _TitleLab.backgroundColor = [UIColor clearColor];
        _TitleLab.font = [UIFont boldSystemFontOfSize:16.0];
        _TitleLab.textAlignment = NSTextAlignmentCenter;
        _TitleLab.textColor = [UIColor whiteColor]; // change this color
        [self addSubview:_TitleLab];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
