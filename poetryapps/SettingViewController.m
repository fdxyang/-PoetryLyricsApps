//
//  SettingViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "SettingViewController.h"
#import "PoetryCoreData.h"

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
    PoetryCoreData *PoetryDatabase = [[PoetryCoreData alloc] init];
    
    if ([PoetryDatabase Poetry_CoreDataReadingExist]) {
        _NowReading = [PoetryDatabase Poetry_CoreDataFetchDataInReading];
    } else {
        _NowReading = (NSDictionary*)[[PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] firstObject];
    }


    /*
    
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
     */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        //cell.textLabel.text = @"FONT SIZE";
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FontSizeSetting" owner:self options:nil];
        _FontSizeSettingView = (FontSizeSetting *)[subviewArray objectAtIndex:0];
        _FontSizeSettingView.frame = CGRectMake(0, 0, _FontSizeSettingView.frame.size.width, _FontSizeSettingView.frame.size.height);
        
        [self Setting_InitFontSizeViewBtns];
        
        [_FontSizeSettingView.SmallSizeBtn addTarget:self action:@selector(SmallSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.MidiumSizeBtn addTarget:self action:@selector(MediumSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.LargeSizeBtn addTarget:self action:@selector(LargeSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:_FontSizeSettingView];
        
    } else if (indexPath.section == 1) {

        NSArray *subviewArray2 = [[NSBundle mainBundle] loadNibNamed:@"ThemeSetting" owner:self options:nil];
        _ThemeSettingView = (ThemeSetting *)[subviewArray2 objectAtIndex:0];
        _ThemeSettingView.frame = CGRectMake(0, 0, _ThemeSettingView.frame.size.width, _ThemeSettingView.frame.size.height);
        
        [_ThemeSettingView.LightDarkBtn addTarget:self action:@selector(LightDarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_ThemeSettingView.DarkLightBtn addTarget:self action:@selector(DarkLightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        

        [cell addSubview:_ThemeSettingView];

        
    } else if (indexPath.section == 2) {
        
        if (_ThemePreViewLab == nil) {
            _ThemePreViewLab = [[UILabel alloc] init];
        }
        
        _ThemePreViewLab.frame = CGRectMake(0, 0, 320.f, 200.f);
        _ThemePreViewLab.textAlignment = NSTextAlignmentCenter;
        _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_Setting.SettingFontSize];
        
        [self Setting_InitThemeView];
        [cell addSubview:_ThemePreViewLab];
        
    } else if (indexPath.section ==3) {
        cell.textLabel.text = @"About me";
    }
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 1) {
        
        return 50;
        
    } else if (indexPath.section == 2) {
        
        return 200;
        
    } else {
        
        return 45;
    }
    
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
    
    _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:FontSizeSetting];

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
    
    //_ThemePreViewLab.text = [_NowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY];
    //NSLog(@"%@", [_NowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);
    
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
