//
//  ViewController.m
//  ImageLabel
//
//  Created by Tian on 16/6/14.
//  Copyright © 2016年 Tian. All rights reserved.
//

#import "ViewController.h"
#import "TagEidtorImageView.h"
#import "NextViewController.h"

@interface ViewController ()<LabelDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TagEidtorImageView *teiv = [[TagEidtorImageView alloc] initWithImage:[UIImage imageNamed:@"abc.jpg"]];
    [self.view addSubview:teiv];
    teiv.userInteractionEnabled = YES;
    [teiv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //展示图片上原有的标签
    [teiv addTagViewText:@"abcd" Location:CGPointMake(20, 20) isPositiveAndNegative:YES];
    
    teiv.delegate = self;
    
}
- (void)skipToNextViewcontroller{
    NextViewController *nvc = [[NextViewController alloc] init];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
