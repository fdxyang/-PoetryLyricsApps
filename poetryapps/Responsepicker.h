//
//  Responsepicker.h
//  poetryapps
//
//  Created by Goda on 2013/12/2.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Responsepicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *responsePicker;
    NSMutableArray *responseArr;
    BOOL isTurnOnView;
}

@property (nonatomic,strong) NSString *pickerContent;
@property (nonatomic,strong) UIButton *btn;
- (id)initWithFrame:(CGRect)frame getbtn:(UIButton*)btn getState:(BOOL)isTurnOn;
- (NSString *) getPickerContent;
- (void) setFlag:(BOOL)flag;

@end
