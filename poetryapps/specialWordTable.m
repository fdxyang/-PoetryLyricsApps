//
//  specialWordTable.m
//  poetryapps
//
//  Created by Kevin on 2014/2/6.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "specialWordTable.h"

@implementation specialWordTable

- (id) init
{
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sc1.png"]];
    _stone = logoView;
    //UIImage *img = [UIImage imageNamed:@"sc1.png"];
    CGRect frame = CGRectMake(0, 0, 100, 100);
    
    
    self = [self initWithFrame:frame];
    [self addSubview:logoView];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
