//
//  draftBoxViewCollectionViewCell.h
//  shootVideoDemo
//
//  Created by 赵一帆 on 15/12/9.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface draftBoxViewCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *renove;

@end
