



//
//  HBBSettingViewController.m
//  BSBDJ
//
//  Created by HopeBayBridge on 16/2/11.
//  Copyright © 2016年 hopebaybridge. All rights reserved.
//

#import "HBBSettingViewController.h"
#import <SDImageCache.h>

@implementation HBBSettingViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.tableView.backgroundColor = HBBGlobalBG;
}


- (void)getSize2
{
    // 图片缓存
    NSUInteger size = [SDImageCache sharedImageCache].getSize;
        HBBLog(@"%zd %@", size, NSTemporaryDirectory());
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 文件夹
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    // 获得文件夹内部的所有内容
    //    NSArray *contents = [manager contentsOfDirectoryAtPath:cachePath error:nil];
    NSArray *subpaths = [manager subpathsAtPath:cachePath];
    HBBLog(@"%@", subpaths);
}

- (void)getSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cachePath = [caches stringByAppendingPathComponent:@"default/com.hackemist.SDWebImageCache.default"];
    
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:cachePath];
    NSInteger totalSize = 0;
    for (NSString *fileName in fileEnumerator) {
        NSString *filepath = [cachePath stringByAppendingPathComponent:fileName];
        
        //        BOOL dir = NO;
        // 判断文件的类型：文件\文件夹
        //        [manager fileExistsAtPath:filepath isDirectory:&dir];
        //        if (dir) continue;
        NSDictionary *attrs = [manager attributesOfItemAtPath:filepath error:nil];
        if ([attrs[NSFileType] isEqualToString:NSFileTypeDirectory]) continue;
        
        totalSize += [attrs[NSFileSize] integerValue];
    }
    HBBLog(@"%zd", totalSize);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    CGFloat size = [SDImageCache sharedImageCache].getSize / 1000.0 /1000;
    cell.textLabel.text = [NSString stringWithFormat:@"清除缓存（已使用 %.2fMB）",size];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[SDImageCache sharedImageCache] cleanDisk];
    
    
}


@end
