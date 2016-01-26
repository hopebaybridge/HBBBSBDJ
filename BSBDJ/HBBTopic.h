//
//  HBBTopic.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//  段子  模型数据类

#import <Foundation/Foundation.h>

@interface HBBTopic : NSObject

/**  名称 */
@property (nonatomic,copy)  NSString *name;
/**  头像 */
@property (nonatomic,copy)  NSString *profile_image;
/**  发帖时间*/
@property (nonatomic,copy)  NSString *create_time;
/**  文字内容 */
@property (nonatomic,copy)  NSString *text;
/** 顶的数量 */
@property (nonatomic,assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic,assign) NSInteger  cai;
/** 转发的数量 */
@property (nonatomic,assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic,assign) NSInteger  comment;
/** cell 的高度 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;
/** 帖子的类型 */
@property (nonatomic,assign)HBBTopicType type;
/** 图片的宽度 */
@property (nonatomic,assign) NSInteger width;
/** 图片的高度 */
@property (nonatomic,assign)NSInteger height;
/**  小图片的 URL */
@property (nonatomic,copy) NSString *small_image;
/**  中图片的 URL  */
@property (nonatomic,copy) NSString *middle_image;
/**  大图片的 URL  */
@property (nonatomic,copy) NSString *large_image;

@end
