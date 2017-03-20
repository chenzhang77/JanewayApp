//
//  RemainTableViewCell.h
//  JanewayApp
//
//  Created by cz5670 on 2016-05-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemainTableViewCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UIImageView *cellImage;

@property (nonatomic,weak) IBOutlet UIImageView *cellTailImage;
@property (nonatomic,strong)NSString *cellWebFileName;
@property (nonatomic,weak) IBOutlet UILabel *cellTitle;
@property (nonatomic,weak) IBOutlet UILabel *cellDetail;
@end
