//
//  ReadingViewController.m
//  poetryapps
//
//  Created by Goda on 2013/11/30.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import "ReadingViewController.h"

@interface ReadingViewController ()

@end

@implementation ReadingViewController

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
 
	// Do any additional setup after loading the view.
    
    _PoetryDatabase = [[PoetryCoreData alloc] init];
    _PoetrySetting = [[PoetrySettingCoreData alloc] init];
//    [self readingViewSetupScroller];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self readingViewSetupScroller];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // TODO: save _PoetryNowReading in Reading database
    NSLog(@"ViewDidDisappear - save reading \n %@", _PoetryNowReading);
    [_PoetryDatabase PoetryCoreDataSaveIntoNowReading:_PoetryNowReading];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)readingViewSetupScroller
{
    
    if (_PoetryDatabase.isReadingExist) {
        
        _PoetryNowReading = [_PoetryDatabase Poetry_CoreDataFetchDataInReading];
        NSLog(@"READING EXIST , \n%@", [_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]);

        
    } else {
        
        NSLog(@"NO READING POETRY, GET THE 1st POETRY in GUARD READING");
        _PoetryNowReading = (NSDictionary*)[[_PoetryDatabase Poetry_CoreDataFetchDataInCategory:GUARD_READING] objectAtIndex:0];
        
    }
    
    
    // Read Setting
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:_PoetrySetting.SettingFontSize];
    NSLog(@"Font size = %@", font);
    
    // Setup Scroll View
    [_Scroller setContentSize:CGSizeMake(320, 1000)];
    [_Scroller setScrollEnabled:YES];
    CGSize size = CGSizeMake(300, 0);
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ReadingScroller" owner:self options:nil];
    if (subviewArray == nil) {
        NSLog(@"CANNOT FIND ReadingScroller");
    }
    
    // Add Content
    UILabel *ContentLab = [[UILabel alloc] init];
    [ContentLab setText:[_PoetryNowReading valueForKey:POETRY_CORE_DATA_CONTENT_KEY]];
    [ContentLab setFont:font];
    ContentLab.numberOfLines = 0;
    [ContentLab setBackgroundColor: [UIColor whiteColor]];
    CGSize constraint = CGSizeMake(300, 20000.0f);
    
    size = [ContentLab sizeThatFits:constraint];
    [ContentLab setFrame:CGRectMake(10, 20, size.width, size.height)];
    
    [_Scroller setContentSize:CGSizeMake(320, size.height + 40)];
    
    [_Scroller addSubview: ContentLab];
}

@end
