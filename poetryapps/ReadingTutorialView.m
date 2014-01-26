//
//  ReadingTutorialView.m
//  poetryapps
//
//  Created by GIGIGUN on 2014/1/26.
//  Copyright (c) 2014年 cc. All rights reserved.
//

#import "ReadingTutorialView.h"

@implementation ReadingTutorialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id) initWithCoder:(NSCoder *)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        [self BackgroundSetup];
    }
    return self;
}

- (void) BackgroundSetup
{
    //if (iOS7OrLater)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barTintColor = self.tintColor;
        [self insertSubview:toolbar atIndex:0];
    }
}
@end
