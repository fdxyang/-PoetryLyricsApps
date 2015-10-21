//
//  SettingViewController.m
//  poetryapps
//
//  Created by GIGIGUN on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "SettingViewController.h"
#import "PoetryCoreData.h"
#import "ILTranslucentView.h"

#define TEST_FACEBOOK_LOGIN

@interface SettingViewController () {
    
    UIColor                 *_LightBackgroundColor;
    UIColor                 *_DarkBackgroundColor;
    BOOL                    isShowSpecialTable;
    ILTranslucentView            *specialTableView;
    UIScrollView             *specialTableScrollView;
    UITapGestureRecognizer *tapGestureRecognizer;
}

@property (nonatomic) UIView *specialView;
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
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    self.navigationItem.title = @"設定";
   
    // 20140126 Change preview label background
    /*
    _LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Light_bgiPhone.png"]];
    _DarkBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Dark_bgiPhone.png"]];
    */
    
    _LightBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper.png"]];
    _DarkBackgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BG-GreyNote_paper_Dark.png"]];
    
    UILabel  *_NavigationTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    _NavigationTitleLab.text = @"設定";
    _NavigationTitleLab.backgroundColor = [UIColor clearColor];
    _NavigationTitleLab.font = [UIFont boldSystemFontOfSize:16.0];
    _NavigationTitleLab.textAlignment = NSTextAlignmentCenter;
    _NavigationTitleLab.textColor = [UIColor whiteColor]; // change this color
    
    //    _NavigationTitleLab.textColor = [[UIColor alloc] initWithRed:(247/255.0f) green:(243/255.0f) blue:(205/255.0f) alpha:1]; // change this color
    self.navigationItem.titleView = _NavigationTitleLab;
    CGSize Size = CGSizeMake(280, 200);
    Size = [_NavigationTitleLab sizeThatFits:Size];
    [_NavigationTitleLab setFrame:CGRectMake(0, 0, 280, Size.height)];
    
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:(32/255.0f)
                                                                                    green:(159/255.0f)
                                                                                     blue:(191/255.0f)
                                                                                    alpha:0.8]];
    
    _specialView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showSpecialTable)];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    isShowSpecialTable = FALSE;
    [self createSpecialTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"View did appear");
    
    if ([_PoetryDatabase Poetry_CoreDataReadingExist]) {
        
        // [CASPER] 2013.12.23 Set text in preview as poetry name
        _NowReadingText = [[_PoetryDatabase Poetry_CoreDataFetchDataInReading] valueForKey:POETRY_CORE_DATA_NAME_KEY];
        // [CASPER] 2013.12.23 ==
        
        if ([_NowReadingText length] == 0) {
            
            _NowReadingText = [(NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY];
            
        }
    } else {
        _NowReadingText = [(NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:POETRYS] firstObject] valueForKey:POETRY_CORE_DATA_NAME_KEY];
    }
    
    [_TableView reloadData];

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
#ifdef TEST_FACEBOOK_LOGIN
    // test cell
    return 6;
#else
    return 5;
#endif

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
        
        [self Setting_InitFontSizeViewBtns];
        [cell addSubview:_FontSizeSettingView];
        
    } else if (indexPath.section == 1) {
        
        [self Setting_InitThemeSettingView];
        [cell addSubview:_ThemeSettingView];

        
    } else if (indexPath.section == 2) {
        [self InitPreviewLab];
        [self Setting_InitThemeView];
        [cell addSubview:_ThemePreViewLab];
        
    } else if (indexPath.section ==3) {
        cell.textLabel.text = @"關於我們";
    }
    else if (indexPath.section == 4) {
        cell.textLabel.text = @"特殊字清單";
    }
#ifdef TEST_FACEBOOK_LOGIN
    else if (indexPath.section == 5) {
        cell.textLabel.text = @"Facebook Login Test";
    }
#endif
   
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 1) {
        
        return 50;
        
    } else if (indexPath.section == 2) {
        
        return 100;
        
    } else {
        
        return 45;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionStr = [[NSString alloc] init];
    

    switch (section) {
        case 0:
            sectionStr = @"字體大小";
            break;
            
        case 1:
            sectionStr = @"顯示主題";
            break;
            
        case 2:
            sectionStr = @"預覽";
            break;
            
        case 3:
            sectionStr = @"";
            break;
        default:
            break;
    }
    

    return sectionStr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Seleted");
    if (indexPath.section == 3) {
        
        [self performSegueWithIdentifier:@"AboutMeViewController" sender:nil];   
    }
    else if(indexPath.section == 4){
        //[specialTableView setHidden:NO];
        [self showSpecialTable];
    }
    
#ifdef TEST_FACEBOOK_LOGIN
    else if (indexPath.section ==5) {
        [self performSegueWithIdentifier:@"FacebookLoginTestViewController" sender:nil];
    }
#endif
}

#pragma kevin show special table
- (void)showSpecialTable
{
    if (!isShowSpecialTable)
    {
        isShowSpecialTable = TRUE;
        [self.view addSubview:specialTableView];
        [self.view bringSubviewToFront:specialTableView];
        //[_TableView setContentOffset:CGPointZero animated:YES];
        [_TableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    else
    {
        isShowSpecialTable = FALSE;
        [specialTableView removeFromSuperview];
    }
}

- (void) createSpecialTableView
{
    CGFloat imageHeight = 0.0;
    NSString *imageName;
    
    
    specialTableView = [[ILTranslucentView alloc] initWithFrame:
                        CGRectMake(0, 0, self.view.frame.size.width,
                                   self.view.frame.size.height+50)];
    
    
    specialTableView.translucentAlpha = 0.9;
    specialTableView.translucentStyle = UIBarStyleBlack;
    specialTableView.translucentTintColor = [UIColor clearColor];
    specialTableView.backgroundColor = [UIColor clearColor];
    
    
    imageHeight = self.view.frame.size.height;
    
    if (self.view.frame.size.height < 568) {
        imageName = @"specialtable_35inch.png";
    }
    else{
        imageName = @"specialtable.png";
    }
    
    specialTableScrollView = [[UIScrollView alloc] initWithFrame:
                              CGRectMake(0, 20, self.view.frame.size.width,
                                         self.view.frame.size.height)];
    
    [specialTableView addSubview:specialTableScrollView];
    
    specialTableScrollView.userInteractionEnabled = NO; // To pass touch event to the lower level
    specialTableScrollView.exclusiveTouch = NO;
    
    // TODO: Modify image as Special Table Img
    UIImageView *TestImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, imageHeight)];
    [TestImg setImage:[UIImage imageNamed:imageName]];
    [specialTableScrollView addSubview:TestImg];
    
    [specialTableScrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, imageHeight-150)]; // TODO: Modify "1000" as Image Height
    [specialTableScrollView setBackgroundColor:[UIColor clearColor]];
    
    [specialTableView addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - Font Setting

-(void) Setting_InitFontSizeViewBtns
{
    
    //cell.textLabel.text = @"FONT SIZE";
    if (_FontSizeSettingView == nil) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"FontSizeSetting" owner:self options:nil];
        _FontSizeSettingView = (FontSizeSetting *)[subviewArray objectAtIndex:0];
        _FontSizeSettingView.frame = CGRectMake(0, 0, _FontSizeSettingView.frame.size.width, _FontSizeSettingView.frame.size.height);
        
        [_FontSizeSettingView.SmallSizeBtn addTarget:self action:@selector(SmallSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.MidiumSizeBtn addTarget:self action:@selector(MediumSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_FontSizeSettingView.LargeSizeBtn addTarget:self action:@selector(LargeSizeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
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

-(void) InitPreviewLab
{
    
    if (_ThemePreViewLab == nil) {
        _ThemePreViewLab = [[UILabel alloc] init];
    }
    
    _ThemePreViewLab.frame = CGRectMake(0, 0, 320.f, 100.f);
    _ThemePreViewLab.textAlignment = NSTextAlignmentCenter;
    _ThemePreViewLab.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_Setting.SettingFontSize];
    

}

-(void) Setting_InitThemeSettingView
{
    NSArray *subviewArray2 = [[NSBundle mainBundle] loadNibNamed:@"ThemeSetting" owner:self options:nil];
    _ThemeSettingView = (ThemeSetting *)[subviewArray2 objectAtIndex:0];
    _ThemeSettingView.frame = CGRectMake(0, 0, _ThemeSettingView.frame.size.width, _ThemeSettingView.frame.size.height);
    
    [_ThemeSettingView.LightDarkBtn setTitle:@"淺色主題" forState:UIControlStateNormal];
    [_ThemeSettingView.DarkLightBtn setTitle:@"深色主題" forState:UIControlStateNormal];
    
    [_ThemeSettingView.LightDarkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_ThemeSettingView.DarkLightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [_ThemeSettingView.LightDarkBtn addTarget:self action:@selector(LightDarkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_ThemeSettingView.DarkLightBtn addTarget:self action:@selector(DarkLightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (_Setting.SettingTheme == THEME_LIGHT_DARK) {
        [_ThemeSettingView.LightDarkBtn setEnabled:NO];
    } else {
        [_ThemeSettingView.DarkLightBtn setEnabled:NO];
    }

}

-(void) Setting_InitThemeView
{
    [self Setting_SetupThemeSettingView : _Setting.SettingTheme andSave:NO];
}

-(void) Setting_SetupThemeSettingView : (THEME_SETTING) ThemeSetting andSave : (BOOL) Save
{
    
    if (Save) {
        [_Setting PoetrySetting_SetTheme:ThemeSetting];
    }
    /*
    NSRange range;
    range.length = 30;
    range.location = 2;
    */
    switch (ThemeSetting) {
            
        case THEME_LIGHT_DARK:
            NSLog(@"THEME_LIGHT_DARK");
            //THEME_LIGHT_DARK = 0x00,    // Font color = Black, Background = White
            _ThemePreViewLab.backgroundColor = _LightBackgroundColor;
            _ThemePreViewLab.textColor = [UIColor blackColor];
            _ThemePreViewLab.text = _NowReadingText;
            NSLog(@"now reading = %@", _NowReadingText);
            break;
            
        case THEME_DARK_LIGHT:
            NSLog(@"THEME_DARK_LIGHT");

            //THEME_LIGHT_DARK = 0x01,    // Font color = White, Background = Black
            _ThemePreViewLab.backgroundColor = _DarkBackgroundColor;
            _ThemePreViewLab.textColor = [UIColor whiteColor];
            _ThemePreViewLab.text = _NowReadingText;
            NSLog(@"now reading = %@", _NowReadingText);


            break;
        
    }
}



-(void) LightDarkBtnClicked
{
    [_ThemeSettingView.DarkLightBtn setEnabled:YES];
    [self Setting_SetupThemeSettingView:THEME_LIGHT_DARK andSave:YES];
    [_ThemeSettingView.LightDarkBtn setEnabled:NO];
}

-(void) DarkLightBtnClicked
{
    [_ThemeSettingView.LightDarkBtn setEnabled:YES];
    [self Setting_SetupThemeSettingView:THEME_DARK_LIGHT andSave:YES];
    [_ThemeSettingView.DarkLightBtn setEnabled:NO];
}




@end
