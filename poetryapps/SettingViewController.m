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
    
    [_FontSizeSettingView.SmallSizeBtn addTarget:self action:@selector(SmallSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_FontSizeSettingView.MidiumSizeBtn addTarget:self action:@selector(MediumSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_FontSizeSettingView.LargeSizeBtn addTarget:self action:@selector(LargeSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    switch (FontSizeSetting) {
            
        case FONT_SIZE_SMALL:
            NSLog(@"FONT  = SMALL SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            
            [_Setting PoetrySetting_SetFontSize:FONT_SIZE_SMALL];
            
            break;
            
        case FONT_SIZE_MEDIUM:
            NSLog(@"FONT  = MEDIUM SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            
            [_Setting PoetrySetting_SetFontSize:FONT_SIZE_MEDIUM];

            break;
            
        case FONT_SIZE_LARGE:
            NSLog(@"FONT  = LARGE SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:DefaultTintColor_iOS7];
            
            [_Setting PoetrySetting_SetFontSize:FONT_SIZE_LARGE];

            break;
            
        default:
            NSLog(@"!!!");
            break;
    }
}

-(void) SmallSizeBtnClicked
{
    NSLog(@"small");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_SMALL];
}

-(void) MediumSizeBtnClicked
{
        NSLog(@"medium");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_MEDIUM];
}

-(void) LargeSizeBtnClicked
{
        NSLog(@"large");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_LARGE];
}

@end
