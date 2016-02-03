//
//  HBBCommentHeaderView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/3.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBCommentHeaderView.h"

@interface HBBCommentHeaderView()
/** 文字标签 */
@property (nonatomic,weak) UILabel *label;

@end


@implementation HBBCommentHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"header";
    HBBCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[HBBCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier] ) {
        self.contentView.backgroundColor = HBBGlobalBG;
        
        
        UILabel  *label = [[UILabel alloc] init];
        label.textColor = HBBRGBColor(67, 67, 67);
        label.width = 200;
        label.x = HBBTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
        
    }
    
    return self;
}


- (void)setTitle:(NSString *)title{
    _title = [title copy];
    self.label.text = title;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
