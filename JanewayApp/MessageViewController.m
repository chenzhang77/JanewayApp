//
//  MessageViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2017-03-17.
//  Copyright © 2017 winemocol. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"MessageViewController   =  %@", _titleMessage.text);
    
    
    _titleMessage.text = _titleString;
    _detailMessage.text = _detailString;
    _timeMessage.text = _timeString;
    [_detailMessage sizeToFit];
}
-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSLog(@"MessageViewController   =  %@", _titleMessage.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
