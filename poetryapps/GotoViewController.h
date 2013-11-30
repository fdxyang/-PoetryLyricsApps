//
//  GotoViewController.h
//  poetryapps
//
//  Created by Goda on 2013/11/29.
//  Copyright (c) 2013年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GotoTable.h"

typedef enum {
    BASICGUIDE = 0,
    HISTORY,
    GOTOPAGECOUNT
}GotoPageAreaSection;


typedef enum {
    GUIDE = 0,
    POETRY,
    RESPONSE
}GotoSection;


@interface GotoViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) GotoSection section;
//@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger currentGuideIndex;
@property (nonatomic) NSInteger currentPoetryIndex;
@property (nonatomic) NSInteger currentResponseIndex;
@property (nonatomic,strong) NSMutableArray *historyArr;
@property (nonatomic,strong) NSMutableArray *guideArray;
@property (nonatomic) BOOL isTreeMode;
@property (nonatomic, strong) GotoTable *TableView;
@property (strong, nonatomic) IBOutlet UIButton *guideBtn;
@property (strong, nonatomic) IBOutlet UIButton *poetryBtn;
@property (strong, nonatomic) IBOutlet UIButton *responseBtn;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIButton *gotoReading;

- (IBAction)guideBtnClicked:(id)sender;
- (IBAction)poetryBtnClicked:(id)sender;
- (IBAction)responseBtnClicked:(id)sender;
- (IBAction)changeModeBtnClicked:(id)sender;
- (IBAction)changeReadingModeClicked:(id)sender;

@end
