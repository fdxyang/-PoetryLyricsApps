//
//  General.h
//  poetryapps
//
//  Created by GIGIGUN on 2013/12/26.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#pragma mark - SCREEN RECT DEFINITION


#define   IS_IPHONE5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define UI_SCREEN_WIDTH                         320
#define UI_SCREEN_3_5_INCH_HEIGHT               480
#define UI_SCREEN_4_INCH_HEIGHT                 568
#define UI_IPAD_SCREEN_WIDTH                    1024
#define UI_IPAD_SCREEN_HEIGHT                   768


#define UI_IOS7_TAB_BAR_HEIGHT          49
#define UI_IOS7_NAV_BAR_HEIGHT          65 // 2014.03.02 [CASPER] Change to 65 from 44.


#define UI_IOS7_VERSION_FLOATING        7.0f

#define UI_GLOBAL_COLOR_BLUE [UIColor colorWithRed:(32/255.0f) green:(159/255.0f) blue:(191/255.0f) alpha:0.8]