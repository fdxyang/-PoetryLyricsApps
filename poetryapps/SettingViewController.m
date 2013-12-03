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
    if (_FontSizeLab == nil) {
        _FontSizeLab = [[UILabel alloc] init];
    }
    _FontSizeLab.frame = CGRectMake(10, 70, 100.f, 30.f);
    _FontSizeLab.text = @"字型大小";
    _FontSizeLab.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_FontSizeLab];
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FontSizeSetting" owner:self options:nil];
    _FontSizeSettingView = (FontSizeSetting *)[subviewArray objectAtIndex:0];
    _FontSizeSettingView.frame = CGRectMake(0, 100, _FontSizeSettingView.frame.size.width, _FontSizeSettingView.frame.size.height);
    
    [self Setting_InitFontSizeViewBtns];
    
    [_FontSizeSettingView.SmallSizeBtn addTarget:self action:@selector(SmallSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_FontSizeSettingView.MidiumSizeBtn addTarget:self action:@selector(MediumSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_FontSizeSettingView.LargeSizeBtn addTarget:self action:@selector(LargeSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_FontSizeSettingView];
    
    
    NSArray *subviewArray2 = [[NSBundle mainBundle] loadNibNamed:@"ThemeSetting" owner:self options:nil];
    _ThemeSettingView = (ThemeSetting *)[subviewArray2 objectAtIndex:0];
    _ThemeSettingView.frame = CGRectMake(0, 300, _ThemeSettingView.frame.size.width, _ThemeSettingView.frame.size.height);
    
    if (_ThemePreViewLab == nil) {
        _ThemePreViewLab = [[UILabel alloc] init];
    }
    
    _ThemePreViewLab.frame = CGRectMake(10, 250, 300.f, 50.f);
    _ThemePreViewLab.textAlignment = NSTextAlignmentCenter;
    _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:POETRY_SETIING_FONT_SIZE_DEFAULT];
    
    [self Setting_InitThemeView];
    
    [_ThemeSettingView.LightDarkBtn addTarget:self action:@selector(LightDarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_ThemeSettingView.DarkLightBtn addTarget:self action:@selector(DarkLightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_ThemePreViewLab];
    [self.view addSubview:_ThemeSettingView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Font Setting

-(void) Setting_InitFontSizeViewBtns
{
    [self Setting_SetupBtnsInFontSizeViewWithSetting:_Setting.SettingFontSize andSave:NO];
}

-(void) Setting_SetupBtnsInFontSizeViewWithSetting : (FONT_SIZE_SETTING) FontSizeSetting andSave:(BOOL) Save
{
    UIColor *DefaultTintColor_iOS7 = [UIColor colorWithRed:0.0f green:(108.f/255.f) blue:(255.f/255.f) alpha:1.0f];
    
    if (Save) {
        [_Setting PoetrySetting_SetFontSize:FontSizeSetting];
    }
    
    switch (FontSizeSetting) {
            
        case FONT_SIZE_SMALL:
            
            NSLog(@"FONT  = SMALL SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
            
            
            break;
            
        case FONT_SIZE_MEDIUM:
            
            NSLog(@"FONT  = MEDIUM SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:DefaultTintColor_iOS7];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:[UIColor grayColor]];
        
            break;
            
        case FONT_SIZE_LARGE:
            
            NSLog(@"FONT  = LARGE SIZE ");
            [_FontSizeSettingView.SmallSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.MidiumSizeBtn setTintColor:[UIColor grayColor]];
            [_FontSizeSettingView.LargeSizeBtn setTintColor:DefaultTintColor_iOS7];
            
            break;
            
        default:
            break;
    }
}

-(void) SmallSizeBtnClicked
{
    NSLog(@"small");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_SMALL andSave:YES];
}

-(void) MediumSizeBtnClicked
{
        NSLog(@"medium");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_MEDIUM andSave:YES];
}

-(void) LargeSizeBtnClicked
{
        NSLog(@"large");
    [self Setting_SetupBtnsInFontSizeViewWithSetting:FONT_SIZE_LARGE andSave:YES];
}


#pragma mark - Theme Setting

-(void) Setting_InitThemeView
{
    [self Setting_SetupThemeSettingView : _Setting.SettingTheme andSave:NO];
}

-(void) Setting_SetupThemeSettingView : (THEME_SETTING) ThemeSetting andSave : (BOOL) Save
{
    
    if (Save) {
        [_Setting PoetrySetting_SetTheme:ThemeSetting];
    }
    
    switch (ThemeSetting) {
            
        case THEME_LIGHT_DARK:
            NSLog(@"THEME_LIGHT_DARK");
            //THEME_LIGHT_DARK = 0x00,    // Font color = Black, Background = White
            _ThemePreViewLab.backgroundColor = [UIColor whiteColor];
            _ThemePreViewLab.textColor = [UIColor blackColor];
            _ThemePreViewLab.text = @"白底黑字";

            break;
            
        case THEME_DARK_LIGHT:
            NSLog(@"THEME_DARK_LIGHT");

            //THEME_LIGHT_DARK = 0x01,    // Font color = White, Background = Black
            _ThemePreViewLab.backgroundColor = [UIColor blackColor];
            _ThemePreViewLab.textColor = [UIColor whiteColor];
            _ThemePreViewLab.text = @"黑底白字";

            break;
        
    }
}



-(void) LightDarkBtnClicked
{
    [self Setting_SetupThemeSettingView:THEME_LIGHT_DARK andSave:YES];
}

-(void) DarkLightBtnClicked
{
    [self Setting_SetupThemeSettingView:THEME_DARK_LIGHT andSave:YES];
}
@end
