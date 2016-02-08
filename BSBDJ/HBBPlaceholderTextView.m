//
//  HBBPlaceholderTextView.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/8.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBPlaceholderTextView.h"

/**
 占位文字的显示可以用两种方法
 
 1⃣️  利用 drawrect  绘制文字  但是 缺点是 在 scroll滚动的时候无法同光标一起滚动    视觉效果不佳
 2⃣️  添加 UILabel 控件  将文字设置到 UILabel 中   ,然后将 UIlabel 添加到 textView 中,则滚动 textView的同时, UILabel 滚动   文字滚动
 */
@interface HBBPlaceholderTextView()
/**占位文字 label */
@property (nonatomic,weak) UILabel *placeholderLabel;

@end

@implementation HBBPlaceholderTextView


- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        // 添加一个显示占位文字的 label
        UILabel *placeholderLabel  = [[UILabel alloc] init];
        // 显示多行文字
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    
    return _placeholderLabel;
}



- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        // 垂直方向永远有弹簧效果  (textView  继承 scrollView 但是默认是文字多到一定程度才滚动)
        self.alwaysBounceVertical = YES;
        
        // 默认字体(防止没有值传递造成的空指针)
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字的颜色 (防止没有值传递造成的空指针)
        self.placeholderColor = HBBRGBColor(220, 220, 220);
        
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return  self;
}

/**
 *  监听文字改变
 */
- (void)textDidChange{
    
    // 强刷重绘 效果 系统会自动调调用drawRect() 1⃣️
//    [self setNeedsDisplay];
    
    
    // 只要有文字,就隐藏占位文字 label  2⃣️
    self.placeholderLabel.hidden = self.hasText;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  绘制占位文字(每次drawRect: 之前,会自动清除之前绘制的内容
 *
 *  @return
 * 1⃣️  利用 drawrect  绘制文字  但是 缺点是 在 scroll滚动的时候无法同光标一起滚动    视觉效果不佳
 */
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    
//    // 如果有文字,直接返回,不绘制占位文字 (包含富文本)
//    //if(self.text.length  || self.attributedText.length) return ;
//    // ⬆️⬇️
//    if(self.hasText ) return ;
//    
//    // 处理 rect  防止 导航栏遮盖(-64,0)
//    rect.origin.x = 4;
//    rect.origin.y = 7;
//    rect.size.width -= 2 * rect.origin.x;
//    // 设置文字的属性
//    NSMutableDictionary *attrs = [ NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = self.font;
//    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
//    
//    [self.placeholder drawInRect:rect withAttributes:attrs];
//    
//}

- (void)updatePlaceholderLabelSize{
    
    CGSize maxSize = CGSizeMake(HBBScreenWidth - 2 * self.placeholderLabel.x, MAXFLOAT);
    
    // label 文字默认锤子居中   所以要设置 label 的高度和文字的总高度一致
    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
//    self.placeholderLabel.backgroundColor = [UIColor redColor];
}



#pragma mark -重写 setter
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;  // 2⃣️
    
//  1⃣️  [self setNeedsDisplay];
}


-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;   // 2⃣️
    
    [self updatePlaceholderLabelSize];// 2⃣️

//   1⃣️ [self setNeedsDisplay];
}


#pragma mark - 重写系统方法
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    
    self.placeholderLabel.font = font;  // 2⃣️
    
    [self updatePlaceholderLabelSize];// 2⃣️
    
//   1⃣️ [self setNeedsDisplay];
}


- (void)setText:(NSString *)text{
    [super setText:text];
    
    [self textDidChange];
    
//   1⃣️ [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self textDidChange];

    
//    1⃣️ [self setNeedsDisplay];
}
@end
