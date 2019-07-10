### IOS科研实训最终成果报告

#### 小组成员与指导老师

| 姓名   | 学号     | 指导老师 |
| ------ | -------- | -------- |
| 王亮岛 | 16340219 | 郑贵锋   |
| 王晶   |          | 郑贵锋   |
| 曲翔宇 |          | 郑贵锋   |
| 彭伟林 |          | 郑贵锋   |

#### 项目实现功能与介绍

本项目是基于feed信息流的新闻展示APP，使用objective-c语言开发，运行环境是IOS操作系统，主要功能如下：

- 新闻列表展示
- 新闻详情展示
- 新闻搜索功能
- 评论功能
- 收藏功能
- 用户登录与注册，用户信息编辑
- 收藏功能
- 视频列表展示
- 视频播放功能

#### 功能截图

<table>
  <tr>
    <td><img src="1.png">新闻列表</td>
    <td><img src="2.png"></td>
    <td><img src="3.png"></td>
    <td><img src="4.png"></td>
  </tr>
</table>

#### 功能设计介绍

##### 新闻详情页

这部分主要分为两个部分，一个是使用今日头条给的API显示新闻内容，使用js调整图片大小，使用css渲染文本，使新闻详情能更好看的显示。在这一部分遇到的问题是需要使用正则表达式获取到图片的链接，然后与html文本合并显示，使用的正则表达式函数如下：

```objective-c
-(NSArray *) filterString:(NSString *)html{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"<img "].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"<img "];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@">"].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                if ([src containsString:@"{{image_domain}}"]) {
                    [resultArray addObject:src];
                }
            }
        }
    }
    
    return resultArray;
}
```

然后使用wkWebView的loadHTMLString方法载入html文本和css的渲染样式。

然后是详情中显示大图的方法，使用的是wkWebView的代理，添加js点击事件：

```objective-c
- (void)showBigImage:(NSURLRequest *)request {
    NSString *str = request.URL.absoluteString;
    if ([str hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [str substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imgUrlArr = [self.wkWebView getImgUrlArray];
        NSInteger index = 0;
        for (NSInteger i = 0; i < [imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]]){
                index = i;
            }
        }
        NSNumber* Index = [[NSNumber alloc] initWithInteger:index];
        PicDetailController* pc = [[PicDetailController alloc] initWithPicModel:imgUrlArr PicIndex: Index];
        [self.navigationController pushViewController:pc animated:YES];
    }
    
}
```

在这个函数中会创建一个PicDetailController的对象，进行跳转，在这个类里面，使用的是MWPhotoBrowser第三方库的代理进行图片的展示：

```objective-c
#pragma mark - <MWPhotoBrowserDelegate>
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imgURL.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:self.imgURL[index]]];
    return photo;
}

```

##### 评论界面的实现

在新闻详情页面的最下方会有输入框和各种按钮，分别是收藏，查看评论。其中查看评论是使用动画来实现，在点击查看评论按钮之后会改变评论页面的布局，让其显示出来，而改变布局这一过程使用动画来过渡。

```objective-c
//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    [self updateComment];
    NSLog(@"comment: %@", self.comments);
    [self setupContent];
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, kWindowH, kWindowW, viewHeight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, kWindowH - viewHeight - UI_navBar_Height, kWindowW, viewHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    [_contentView setFrame:CGRectMake(0, kWindowH - viewHeight, kWindowW, viewHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, kWindowH, kWindowW, viewHeight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
}
```

因为我们的评论内容是使用后台数据库来存储的，因此需要使用url获取后台的数据库的内容，但是这一过程会有时间的延迟，获取数据和界面的显示是异步的，因此我会将评论的显示延迟几秒再显示界面，并不会给用户带来不好的体验。

```objective-c
- (void)methodOnePerformSelector{
    [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:0.5];
}
- (void)delayMethod{
    self.jumpView.comments = self.comments;
    NSLog(@"comments:%@",self.jumpView.comments);
    [self.jumpView showInView:self.view];
    [self.jumpView updateContent];
}
```

对于评论界面的设计，使用的是UITableView来展示信息，但是每一个cell的样式是我们自己定义的，每一个评论需要展示评论时间，用户名，用户头像，评论信息。因此需要分配好这几个内容的位置，使用的是Masonry第三方库编辑组件的位置。另一方面，考虑到用户需要登陆才能实现评论的设定，我在点击评论提交的按钮处设计了判断用户名是否为空的条件，如果为空则显示先登录的提示，同时不能提交评论。在这里，因为提交评论和获取评论相当于有两个延迟，因此我使用两个不同的延迟函数实现，延迟的时间不一样，尽可能的短以改善用户体验。

##### 新闻搜索功能

使用的是第三方库PYSearch，这个库提供了显示历史记录，查找匹配新闻的设计，只需要实现响应的代理函数即可：

```objective-c
-(void)searchButton{
    NSArray *hotSeaches = @[@"NBA", @"科技", @"民生", @"游戏", @"小说", @"音乐", @"影视"];
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"搜索新闻", @"搜索新闻") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        HomeDetailController* controller = [[HomeDetailController alloc] init];
        for (int i=0; i<self.articleList.count; i++) {
            if ([self.articleList[i][@"title"] containsString:searchText]) {
                controller.groupId = self.articleList[i][@"group_id"];
            }
        }
        [searchViewController.navigationController pushViewController:controller animated:YES];
    }];
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault;
    searchViewController.delegate = self;
    searchViewController.searchViewControllerShowMode = PYSearchViewControllerShowModePush;
    [self.navigationController pushViewController:searchViewController animated:YES];
}

- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    [self update];
    if (searchText.length) {
        
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i=0; i<self.articleList.count; i++) {
                if ([self.articleList[i][@"title"] containsString:searchText]) {
                    [searchSuggestionsM addObject: self.articleList[i][@"title"]];
                }
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}
```

这个功能不难实现，主要是使用containString的方法来匹配字符串，因为我比较的是新闻标题，因此只需要输入新闻的标题的部分内容就可以找到与之匹配的新闻标题，点击之后可以使用pushViewController跳转到对应的详情页面，使用的是新闻对应的groupid匹配到对应的新闻详情。

##### 收藏界面

简单的使用一个UITableView来实现，这里用到的是本地二进制文件存储的设计，并没有存储到后台数据库的打算，每次添加收藏的新闻之后就会调用二进制编码存储进文件中，然后显示的时候使用二进制界面再读取出来：

```objective-c
#pragma mark 获取沙盒地址

-(NSString*)documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    return documentsDirectory;
}

-(NSString*)dataFilePath{
    
    return [[self documentsDirectory]stringByAppendingPathComponent:@"Collections.plist"];
}
//保存文件
-(void)saveChecklists{
    
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    
    [archiver encodeObject:self.myCollectList forKey:@"Collections"];
    [archiver finishEncoding];
    
    [data writeToFile:[self dataFilePath] atomically:YES];
    
    
}
//读取文件
-(void)loadChecklists{
    
    NSString *path = [self dataFilePath];
    NSLog(@"path: %@", path);
    if([[NSFileManager defaultManager]fileExistsAtPath:path]){
        
        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        self.myCollectList = [unarchiver decodeObjectForKey:@"Collections"];
        
        [unarchiver finishDecoding];
    }else{
        
        self.myCollectList = [[NSMutableArray alloc]initWithCapacity:100];
    }
    
}
```

还使用了一个代理方法：

```objective-c
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.newsCollects.myCollectList removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.newsCollects saveChecklists];
}
```

这个tableView的代理方法的作用是可以在收藏列表中左滑删除收藏的新闻。

##### 关于用户信息页

这个页面主要是布局的设计，使用的是Masonry进行按钮，背景图等的布局。

这里比较值得关注的功能是缓存清理，主要的设计就是找到缓存文件，然后删除其中的内容，这里使用到了多线程异步处理，在主线程中显示缓存文件大小，然后异步处理缓存清理，这样就可以实时显示缓存的数据：

```objective-c
/** 清理缓存 */
- (void)cleanCaches {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"清理缓存" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
            NSFileManager *manager = [NSFileManager defaultManager];
            NSArray *files = [manager subpathsAtPath:cachePath];
            for (NSString *p in files) {
                NSError *error = nil;
                NSString *path = [cachePath stringByAppendingPathComponent:p];
                if ([manager fileExistsAtPath:path]) {
                    [manager removeItemAtPath:path error:&error];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
        [self showSuccessWithMsg:@"清理成功"];
        NSLog(@"%@", self.tempUsername);
        if(![self.tempUsername isEqualToString:@""]) {
            [InfoManager saveInfo:self.tempUsername image:self.tempImage];
        }
    }];
    [ac addAction:cancelAction];
    [ac addAction:ensureAction];
    [self presentViewController:ac animated:YES completion:nil];
}
```

#### 个人总结

##### 王亮岛的个人总结

本人承担了应用开发界面的整体框架搭建，新闻详情页，评论功能，新闻搜索功能，收藏功能，用户界面和清理缓存功能的设计。总体上感觉自己收获挺大的，但是还只是处于IOS的入门阶段，还有很多知识和一些应用需要学习，这次的开发只是初步使用了线程加载图片，但是还是有一些问题要了解。关于IOS的属性，这次实训我只是会基本使用了，但是他们什么时候用还是不太清楚。值得骄傲的是我能够熟练使用UITableView和对组件进行布局和设计了。

#### 人员分工与贡献度

王亮岛：承担了应用开发界面的整体框架搭建，新闻详情页，评论功能，新闻搜索功能，收藏功能，用户界面和清理缓存功能的设计。