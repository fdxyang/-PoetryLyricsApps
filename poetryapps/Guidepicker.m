//
//  Guidepicker.m
//  poetryapps
//
//  Created by Goda on 2013/12/2.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "Guidepicker.h"

@implementation Guidepicker

- (id)initWithFrame:(CGRect)frame getbtn:(UIButton*)btn getState:(BOOL)isTurnOn;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //NSLog(@"Guidepicker init");
        
        isTurnOnView = isTurnOn;
        _btn = btn;
        
        
        PoetryDataBase = [[PoetryCoreData alloc] init];

        guidePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0, 320, 162)];
        //guideArr = [[NSArray alloc]initWithObjects:@"g1",@"g2",@"g3",@"g4",@"g5",@"g6", nil];
        guideArr = [[NSMutableArray alloc] init];
        guideArr = [PoetryDataBase Poetry_CoreDataFetchDataInCategory:GUARD_READING];
        
        if (guideArr != nil) {
            NSLog(@"guideArr List Count = %d", [guideArr count]);
            NSLog(@"guideArr Name = %@", [[guideArr firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY]);
            NSLog(@"guideArr Content = %@", [[guideArr firstObject] valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
            
        }
        guidePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,0, 320, 162)];
        guidePicker.delegate = self;
        guidePicker.dataSource = self;
        [self addSubview:guidePicker];
        
        guideIndex = 0;
    }
    return self;
}


//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //NSLog(@"guide  numberOfComponentsInPickerView section");
    return 1;
}

//內建的函式回傳UIPicker每組選項的項目數目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //NSLog(@"guide  numberOfRowsInComponent");
    //第一組選項由0開始
    switch (component)
    {
        case 0:
            return  [guideArr count];
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
    NSLog(@"guide titleForRow = %d", row);
    switch (component) {
        case 0:
            _pickerContent = [NSString stringWithFormat:@"%@", [[guideArr objectAtIndex:row] valueForKey:POETRY_CORE_DATA_NAME_KEY]];
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
    _pickerContent = [NSString stringWithFormat:@"%@", [[guideArr objectAtIndex:row] valueForKey:POETRY_CORE_DATA_NAME_KEY]];
    //NSLog(@"_pickerContent = %@",_pickerContent);
    if(isTurnOnView)
        [_btn setTitle:[NSString stringWithFormat:@"%@", _pickerContent] forState:UIControlStateNormal];
    guideIndex = row;
}

//get title
- (NSString *) getPickerContent
{
    return _pickerContent;
}

- (void) setFlag:(BOOL)flag
{
    isTurnOnView = flag;
}

- (NSDictionary*) getGuideContent
{
    NSDictionary *result = [guideArr objectAtIndex:guideIndex];
    return result;
}
@end
