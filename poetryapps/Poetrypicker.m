//
//  Poetrypicker.m
//  poetryapps
//
//  Created by Goda on 2013/12/1.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "Poetrypicker.h"

@implementation Poetrypicker

- (id)initWithFrame:(CGRect)frame getbtn:(UIButton*)btn getState:(BOOL)isTurnOn
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        isTurnOnView = isTurnOn;
        
        _btn = btn;
        
        poetryPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0, 320, 162)];
        
        poetryArr = [[NSMutableArray alloc] init];
        PoetryDataBase = [[PoetryCoreData alloc] init];
        
        poetryArr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:POETRYS];
        poetryPicker.delegate = self;
        poetryPicker.dataSource = self;
        [self addSubview:poetryPicker];
        
        poetryIndex = 0;
    }
    return self;
}

//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //NSLog(@"poetry  numberOfComponentsInPickerView section");
    return 1;
}

//內建的函式回傳UIPicker每組選項的項目數目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"poetry  numberOfRowsInComponent");
    //第一組選項由0開始
    switch (component)
    {
        case 0:
            return  [poetryArr count];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行
        default:
            return 0;
            break;
    }
}

//內建函式印出字串在Picker上以免出現"?"
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            _pickerContent = [NSString stringWithFormat:@"%@", [[poetryArr objectAtIndex:row] valueForKey:POETRY_CORE_DATA_NAME_KEY]];
            if(isTurnOnView)
                [_btn setTitle:[NSString stringWithFormat:@"%@", _pickerContent] forState:UIControlStateNormal];
             
            return _pickerContent;

            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            return @"Error";
            break;
    }
}

//選擇UIPickView中的項目時會出發的內建函式
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerContent = [NSString stringWithFormat:@"%@", [[poetryArr objectAtIndex:row] valueForKey:POETRY_CORE_DATA_NAME_KEY]];
    
    if(isTurnOnView)
        [_btn setTitle:[NSString stringWithFormat:@"%@", _pickerContent] forState:UIControlStateNormal];
    
    poetryIndex = row;
}

- (NSString *) getPickerContent
{
    return _pickerContent;
}

- (void) setFlag:(BOOL)flag
{
    isTurnOnView = flag;
}

- (NSDictionary*) getPoetryContent
{
    NSDictionary *result = [poetryArr objectAtIndex:poetryIndex];
    
    return result;
}

@end
