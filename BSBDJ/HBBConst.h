//
//  HBBConst.h
//  HBBBDBDJ
//
//  Created by HopeBayBridge on 16/1/24.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import <UIKit/UIKit.h>




/**
 *  定义帖子的类型
 */
typedef enum{
    
    HBBTopicTypeAll = 1,
    HBBTopicTypeVideo = 41,
    HBBTopicTypeVoice = 31,
    HBBTopicTypePicture = 10,
    HBBTopicTypeWord = 29
    
} HBBTopicType ;




UIKIT_EXTERN   CGFloat const HBBTitlesViewH ;
UIKIT_EXTERN   CGFloat const HBBTitlesViewY ;


/**  精华 - cell 的间距 */
UIKIT_EXTERN CGFloat const  HBBTopicCellMargin ;

/**  精华 - cell 的文字内容的 Y值 */
UIKIT_EXTERN CGFloat const HBBTopicCellTextY ;

/**  精华 - cell 底部工具条的高度 */
UIKIT_EXTERN CGFloat const HBBTopicCellBottomBarH ;

/**  精华 - cell - 图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const HBBTopicCellPictureMaxHeight ;

/**  精华 - cell - 图片帖子的超出最大高度后定义的高度 */
UIKIT_EXTERN CGFloat const HBBTopicCellPictureCustomHeight;


/**  精华 - User - 模型性别*/
UIKIT_EXTERN  NSString *const HBBUserSexMale;
UIKIT_EXTERN  NSString *const HBBUserSexFeMale;



/** 精华 cell 最热评论标题的高度*/
UIKIT_EXTERN CGFloat const HBBTopicCellTopicCmtTitleH ;
