//
//  VRPlayerController.m
//  VRPlayer
//
//  Created by chengshenggen on 7/19/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRPlayerController.h"
#import "VRPlayer.h"

@interface VRPlayerController ()

@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)VRPlayer *vrplayer;

@end

@implementation VRPlayerController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.vrplayer];
    [self.view addSubview:self.backButton];
    
    [self.vrplayer preparePlay];
    
}

#pragma mark - button response
-(void)backButtonActions{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setters and getters
-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(0, 20, 60, 30);
        [_backButton addTarget:self action:@selector(backButtonActions) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(VRPlayer *)vrplayer{
    if (_vrplayer == nil) {
        _vrplayer = [[VRPlayer alloc] initWithFrame:self.view.bounds];
    }
    return _vrplayer;
}

@end
