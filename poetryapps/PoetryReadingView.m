//
//  PoetryReadingView.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/10.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "PoetryReadingView.h"
#import "Animations.h"
@implementation PoetryReadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 44, UI_SCREEN_WIDTH, UI_4_INCH_HEIGHT);
        _Scroller = [[UIScrollView alloc] init];
        _TitleTextLabel = [[UILabel alloc] init];
        _ContentTextLabel = [[UILabel alloc] init];
        //[_Scroller setBackgroundColor:[UIColor redColor]];
        //[Animations shadowOnView:self andShadowType:@"NoShadow"];
        [self addSubview:_Scroller];
        [_Scroller addSubview:_TitleTextLabel];
        [_Scroller addSubview:_ContentTextLabel];
        //[Animations frameAndShadow:self];
        //[Animations shadowOnView:self andShadowType:@"NoShadow"];

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
