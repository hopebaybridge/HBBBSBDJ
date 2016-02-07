//
//  HBBTextField.m
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/22.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBTextField.h"
#import <objc/runtime.h>


static NSString *const HBBPlaceholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation HBBTextField

- (void)initialize{
    [self getIvars];
}

+ (void) getProperties{
    
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0 ; i < count; count++) {
        // 取出属性
        objc_property_t property =  properties[i];
        
//        HBBLog(@"%s  <----> %s",property_getName(property),property_getAttributes(property));
    }
    
//    HBBLog(@"----------------------------------");
    
    // 释放 copy后的内存资源
    free(properties);
}


- (void)getIvars{
    unsigned int count = 0;
    
    // 拷贝所有的隐藏成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for (int i = 0 ; i < count; count++) {
        Ivar ivar = ivars[i];
        
        
//        HBBLog(@"%s < ---->%s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
        
        
    }
//    HBBLog(@"--------------------------------------");
    
    free(ivars);

}


- (void)awakeFromNib{
    
    // 设置光标的颜色和文字的颜色一致
    self.tintColor = self.textColor;
    
    // bu成为第一响应者
    [self resignFirstResponder];
}


/**
 *  当前文本框聚焦时就会调用
 *
 *  @return <#return value description#>
 */
- (BOOL)becomeFirstResponder{
    
    // 修改站位文本的颜色
    [self setValue:self.textColor forKeyPath:HBBPlaceholderColorKeyPath];
    
    return [super becomeFirstResponder];
}

/**
 *  当文本失去焦点时调用的方法
 *
 *  @return <#return value description#>
 */
- (BOOL)resignFirstResponder{
    // 修改站位文本的颜色
    [self setValue:[UIColor grayColor] forKeyPath:HBBPlaceholderColorKeyPath];
    
    return [super resignFirstResponder];
}




/**
 *运行时( runtime)
 *
 *苹果官方调用底层的 c 语言库(隐藏的成员变量,成员方法)
 */

@end
