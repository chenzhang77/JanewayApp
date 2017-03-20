//
//  MessageTableViewCell.h
//  JanewayApp
//
//  Created by cz5670 on 2017-03-16.
//  Copyright © 2017 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic,weak)  NSString *cellId;
@property (nonatomic,weak) IBOutlet UIImageView *cellImage;
@property (nonatomic,weak) IBOutlet UILabel *cellTime;
@property (nonatomic,strong) IBOutlet UILabel *cellTimefull;
@property (nonatomic,weak) IBOutlet UILabel *cellTitle;
@property (nonatomic,weak) IBOutlet UILabel *cellDetail;
@end
