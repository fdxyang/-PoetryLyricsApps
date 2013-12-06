//
//  Poetrypicker.h
//  poetryapps
//
//  Created by Goda on 2013/12/1.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoetryCoreData.h"

@interface Poetrypicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *poetryPicker;
    NSMutableArray *poetryArr;
    BOOL isTurnOnView;
    PoetryCoreData *PoetryDataBase;
}

@property (nonatomic,strong) NSString *pickerContent;
@property (nonatomic,strong) UIButton *btn;
- (id)initWithFrame:(CGRect)frame getbtn:(UIButton*)btn getState:(BOOL)isTurnOn;
- (NSString *) getPickerContent;
- (void) setFlag:(BOOL)flag;

@end
