//
//  SettingViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _Setting = [[PoetrySettingCoreData alloc] init];
    
    NSLog(@" font size = %d and theme = %d", _Setting.SettingFontSize, _Setting.SettingTheme);
    
    
    // TODO: Set UI
    UILabel *FontSizeLab = [[UILabel alloc] init];
    FontSizeLab.frame = CGRectMake(10, 70, 100.f, 30.f);
    FontSizeLab.text = @"字型大小";
    [self.view addSubview:FontSizeLab];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FontSizeSetting" owner:self options:nil];
    _FontSizeSettingView = (FontSizeSetting *)[subviewArray objectAtIndex:0];
    _FontSizeSettingView.frame = CGRectMake(0, 100, _FontSizeSettingView.frame.size.width, _FontSizeSettingView.frame.size.height);
    
    [self Setting_InitFontSizeViewBtns];
    
    [self.view addSubview:_FontSizeSettingView];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) Setting_InitFontSizeViewBtns
{
    [self Setting_SetupBtnsInFontSizeViewWithSetting:_Setting.SettingFontSize];
}

-(void) Setting_SetupBtnsInFontSizeViewWithSetting : (FONT_SIZE_SETTING) FontSizeSetting
{
    UIColor *DefaultTintColor_iOS7 = [UIColor colorWithRed:0.0f green:(108.f/255.f) blue:(255.f/255.f) alpha:1.0f];
    switch (_Setting.SettingFontSize) {
        case POETRY_SETIING_FONT_SIZE_SMALL:
            NSLog(@"FONT  = SMALL SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            break;
            
        case POETRY_SETIING_FONT_SIZE_MEDIUM:
            NSLog(@"FONT  = MEDIUM SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            break;
            
        case POETRY_SETIING_FONT_SIZE_LARGE:
            NSLog(@"FONT  = LARGE SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor blueColor]];
            break;
            
        default:
            break;
    }
}


@end
