//
//  HBBRecommandCategoryCell.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/17.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBRecommandCategoryCell.h"
#import "HBBRecommandCategory.h"


@interface HBBRecommandCategoryCell()

/** 选中显示的指示器控件   左边的竖线*/
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end


@implementation HBBRecommandCategoryCell

- (void)awakeFromNib {
    // Initialization code  加载 xib 会调用此方法
    // 设置背景颜色
    self.backgroundColor =HBBRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = HBBRGBColor(219, 21, 26);
    
    // 当 cell 的 selection 为 none时, cell被选中时,内部的子控件不会进入高亮状态;
    // 设置文字颜色
    //self.textLabel.textColor = HBBRGBColor(78, 78, 78);
    // 设置文字的高亮颜色
    //self.textLabel.highlightedTextColor = HBBRGBColor(219, 21, 26);
    
}

- (void)setCategory:(HBBRecommandCategory *)category{
    _category = category;
    
    self.textLabel.text = category.name;
}
/**
 *  降低 cell  textLable 高度,避免遮挡内部 UIView 充当的 separate
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textLabel.y = 2;
    self.textLabel.height =  self.contentView.height - 2 * self.textLabel.y;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    // 设置指示器的显示状态
    self.selectedIndicator.hidden = !selected;
    
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor:HBBRGBColor(78, 78, 78);
}

@end
