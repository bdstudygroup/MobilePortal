### IOS科研实训最终成果报告

#### 小组成员与指导老师

| 姓名   | 学号     | 指导老师 |
| ------ | -------- | -------- |
| 王亮岛 | 16340219 | 郑贵锋   |
| 王晶   |          | 郑贵锋   |
| 曲翔宇 |          | 郑贵锋   |
| 彭伟林 | 16340181 | 郑贵锋   |

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

##### 自动登录

在初步的版本，我们前端并没有考虑得那么多，只是将简单的UI给设计出来，但由于实际的需求，用户不可能每次打开app都要重新登录，为了提高用户的体验，我们决定添加用户登录功能，这个过程也是我们学习到的理论知识真正运用到实际的开发当中的一个应用。在这里，我们用到cookie对用户的登录状态进行管理。

在登录以后，将服务器传来的cookie设置在本地，并将有效字段提取出来保存在单例当中

```objc
NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
    if(error) {
        NSLog(@"Error: %@", error);
        return;
    }
    NSLog(@"%@", responseObject);
    NSString *imagePath = @"";
    NSInteger code = [responseObject[@"code"] integerValue];
    if(code == 200) {
        if([responseObject[@"data"][@"iconpath"] isEqual:[NSNull null]]) {
            [InfoManager saveInfo:@"username" image: @""];
        } else {
            NSString *url = responseObject[@"data"][@"iconpath"];
            NSLog(@"%@", url);
            imagePath = [@"http://172.19.3.119:8080/" stringByAppendingString:url];
            [InfoManager saveInfo:@"username" image: imagePath];
            NSLog(@"lll");
        }
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:self userInfo:@{@"type": @"login", @"username": username, @"image": imagePath}];
    } else {
        [self showAlertMessage:@"登陆失败！"];
    }

}];

[dataTask resume];
```

当再次打开app的时候，通过cookie获取token来向服务器请求用户数据，在cookie有效期内可以实现自动登录，并将用户信息拉取到本地，否则需要重新登录

```objc
- (void) checkCookie {
    //通过remeberMe拉取用户信息
     NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
     for (NSHTTPCookie *cookie in [cookieJar cookies]) {
         // NSLog(@"%@", cookie.name);
         if([cookie.domain isEqualToString:@"172.19.3.119"] && [cookie.name isEqualToString:@"rememberMe"]) {
             NSString *remeberMe = cookie.value;
             //请求用户信息
             NSMutableURLRequest* formRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:@"http://172.19.3.119:8080/userinfo/getUserInfo/" parameters:nil error:nil];
             [formRequest addValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
             [formRequest addValue:remeberMe forHTTPHeaderField:@"rememberMe"];
             AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
             AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializer];
             [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil]];
             manager.responseSerializer= responseSerializer;
             NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:formRequest uploadProgress:nil downloadProgress:nil completionHandler: ^(NSURLResponse*_Nonnull response,id _Nullable responseObject,NSError*_Nullable error){
                 NSLog(@"%@", responseObject);
                 if(error) {
                     NSLog(@"Error: %@", error);
                     [InfoManager cleanInfo];
                     return;
                 }
                 NSInteger code = [responseObject[@"code"] integerValue];
                 if(code == 200) {
                     //[self showAlertMessage:@"获取成功！"];
                     //NSLog(@"%@", responseObject);
                     if([responseObject[@"data"][@"userinfo"][@"iconpath"]isEqual:[NSNull null]]) {
                         [self.myBtn setBackgroundImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
                         [InfoManager saveInfo:responseObject[@"data"][@"userinfo"][@"username"] image:@""];
                     } else {
                         NSString *url = responseObject[@"data"][@"userinfo"][@"iconpath"];
                         NSString *imagePath = [@"http://172.19.3.119:8080/" stringByAppendingString:url];
                         [InfoManager saveInfo:responseObject[@"data"][@"userinfo"][@"username"] image:imagePath];
                         //set UI, 没有图片的时候默认
                         [self.myBtn setBackgroundImage:[self getImageFromURL:imagePath] forState:UIControlStateNormal];
                     }
                     self.label.text = responseObject[@"data"][@"userinfo"][@"username"];
                     self.isLogin = true;
                 } else {
                     [self showAlertMessage:@"获取失败！"];
                     [InfoManager cleanInfo];
                     self.isLogin = false;
                 }
             }];
             [dataTask resume];
        } else {
            self.isLogin = false;
            [self.myBtn setBackgroundImage:[UIImage imageNamed:@"login_portrait_ph"] forState:UIControlStateNormal];
            self.label.text = @"登陆/注册";
            [InfoManager cleanInfo];
        }
    }
}
```

每次需要向服务器请求数据的时候，通过单例获取到用户信息

```objc
- (void)jumpToLogin{
    if(!([InfoManager getUsername] == nil)) {
        [self showAlertMessage:@"你已经登陆!"];
    } else {
        RegisterLoginController *controller = [[RegisterLoginController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}
```

在需要手动登录的情况下，通过通知的方式传递页面信息

```objc
[[NSNotificationCenter defaultCenter] postNotificationName:@"userInfo" object:self userInfo:@{@"type": @"login", @"username": username, @"image": imagePath}];
```

```objc
//注册通知
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInfo:) name:@"userInfo" object:nil];
```

##### 首页信息展示

首页信息展示其实实现起来非常简单，就是一个简单的UITableView来展示新闻信息，但这里其实是可以有很多可以优化的地方来提高用户体验的，但由于头条提供的api的拉取信息的部分限制比较大，对于随机拉取或者推荐这些做起来难道会比较大。

- 针对cell本身的优化

  首先是针对UITableViewCell的设计，对拉取到的新闻信息的标题进行分析，我们大致可以将cell设计成下面三种格式：

  - 无图：拉取到的新闻的标题仅仅包含文字的情况下使用。
  - 单图：拉取到的新闻标题包含1张图或者2张图的情况下使用。
  - 多图：拉取到的新闻标题包含3张图或者以上的情况下使用。

  由于每条新闻标题文字的长度会不一样，有些标题显示需要占1行，有些标题则需要占2行，显然，设计成一种固定高度的cell是不合适的，所以我们添加了一个自适应的功能，cell可以更加需要显示内容的多少来确定cell的高度，但这样设计又会存在另外一个问题，那就是高度的计算，由于每次显示cell的时候都需要计算一下cell的高度，这个计算的过程会影响到渲染cell的效率，为了解决这个问题，我根据UItableView渲染的生命周期的特点，在cell初次计算出cell的高度的时候，我就把cell的高度缓存起来，在再次显示的时候不用再次计算，减少了重复的计算。具体是在heightForRowAtIndexPath代理方法中设置UITableViewAutomaticDimension可以进行高度自适应，条件是cell的布局使用AutoLayout，如果高度已经被缓存，那么就直接取，否则就计算高度。

  ```objc
  NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.articleList];
  NSMutableArray *tempHeight = [[NSMutableArray alloc]initWithCapacity:articleFeed.count];
  [temp addObjectsFromArray:articleFeed];
  [self.cacheHeight addObjectsFromArray:tempHeight];
  self.articleList = temp;
  ```

  ```objc
  -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
  {
      return [self.cacheHeight[indexPath.row] floatValue]?:UITableViewAutomaticDimension;
  }
  ```

  同时在estimatedHeightForRowAtIndexPath代理方法中设置一个估计的高度

  ```objc
  -(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
  {
      return 100;
  }
  ```

- 针对滑动时用户体验的优化

  在默认的UITableView的实现当中，只有当用户拉取到最后一行的时候才会触发拉取更多的实现，但是这样的用户体验非常的差，因为刷新后需要从网络当中拉取用户数据，网络时延有时候是让人难以接受的。为了解决这个问题，我在UITableView滑动的时候增加了一个判断，在已经拉取的数据并且还未展示的数据不足以显示下一屏的时候，我会从网络拉取一次新的数据，这样用户就可以一直滑动，基本不会感受到网络的时延。

  ```objc
  - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      NSArray *arr = [[NSArray alloc]initWithArray:self.articleList[indexPath.row][@"image_infos"]];
      NSError *err = nil;
      NSString *cellID = [NSString stringWithFormat:@"cellID:%ld", indexPath.row];
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
      if(!cell) {
          if([arr count] == 0) {
              cell = [[NoImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
              ((NoImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
          } else if([arr count] == 1 || [arr count] == 2) {
              cell = [[OneImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
              ((OneImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
              
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[0] options:kNilOptions error:&err];
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
              NSString *url = json[@"url_prefix"];
              url = [url stringByAppendingString:json[@"web_uri"]];
              [((OneImageTableViewCell*)cell).headImageView setImageWithURL:url];
          } else {
              cell = [[ThreeImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
              NSMutableArray *url_arr = [[NSMutableArray alloc]init];
              for(int i = 0; i < 3; i++) {
                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[i] options:kNilOptions error:&err];
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                  NSString *url = json[@"url_prefix"];
                  url = [url stringByAppendingString:json[@"web_uri"]];
                  [url_arr addObject:url];
              }
              ((ThreeImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
              [((ThreeImageTableViewCell*)cell).imageFirst sd_setImageWithURL:url_arr[0]];
              [((ThreeImageTableViewCell*)cell).imageSecond sd_setImageWithURL:url_arr[1]];
              [((ThreeImageTableViewCell*)cell).imageThird sd_setImageWithURL:url_arr[2]];
              //push data
              NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
              NSInteger nextRow = indexPath.row + visibleRows.count;
              if(self.articleList.count - indexPath.row < visibleRows.count) {
                  [self.tableView.mj_footer beginRefreshing];
              }
          }
          //高度缓存
          CGFloat height = [cell systemLayoutSizeFittingSize:CGSizeMake(tableView.frame.size.width, 0) withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:UILayoutPriorityFittingSizeLevel].height;
          NSNumber *heightNum = [[NSNumber alloc]initWithFloat:height];
          self.cacheHeight[indexPath.row] = heightNum;
      } else {
          if([arr count] == 0) {
              ((NoImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
          }else if([arr count] == 1 || [arr count] == 2) {
              //NSLog(@"%d", self.articleList[indexPath.row][@"image_infos"].count);
              ((OneImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
              
              NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[0] options:kNilOptions error:&err];
              NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
              NSString *url = json[@"url_prefix"];
              url = [url stringByAppendingString:json[@"web_uri"]];
              //NSLog(@"%@", url);
              
              [((OneImageTableViewCell*)cell).headImageView setImageWithURL:url];
          }else{
              NSMutableArray *url_arr = [[NSMutableArray alloc]init];
              for(int i = 0; i < 3; i++) {
                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr[i] options:kNilOptions error:&err];
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                  NSString *url = json[@"url_prefix"];
                  url = [url stringByAppendingString:json[@"web_uri"]];
                  [url_arr addObject:url];
              }
              ((ThreeImageTableViewCell*)cell).content.text = self.articleList[indexPath.row][@"title"];
              [((ThreeImageTableViewCell*)cell).imageFirst sd_setImageWithURL:url_arr[0]];
              [((ThreeImageTableViewCell*)cell).imageSecond sd_setImageWithURL:url_arr[1]];
              [((ThreeImageTableViewCell*)cell).imageThird sd_setImageWithURL:url_arr[2]];
              //push data
              NSArray *visibleRows = [self.tableView indexPathsForVisibleRows];
              NSInteger nextRow = indexPath.row + visibleRows.count;
              if(self.articleList.count - indexPath.row < visibleRows.count) {
                  [self.tableView.mj_footer beginRefreshing];
              }
          }
      }
      return cell;
  }
  ```

##### 用户信息管理

对于用户信息的管理，由于需要在不同的页面获取到当前已登录的用户的信息，这里采用NSUserDefaults对用户信息进行管理

```objc
+(void)saveInfo:(NSString *)username image : (NSString *)image
{
    NSError *error = nil;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSData *usernameData = [NSKeyedArchiver archivedDataWithRootObject:username requiringSecureCoding:false error:&error];
    NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:image requiringSecureCoding:false error:&error];
    [userDefaults setObject:usernameData forKey:USERNAME_KEY];
    [userDefaults setObject:imageData forKey:IMAGE_KEY];
    [userDefaults synchronize];
}
```

在获取信息的时候通过调用getUsername获取用户的信息等等。

```objc
+(NSString *)getUsername
{
    NSError *error;
    NSSet *codingClasses = [NSSet setWithArray:@[ [NSDictionary class],[NSArray class] ]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *usernameData = [userDefaults objectForKey:USERNAME_KEY];
    NSString *username = [NSKeyedUnarchiver unarchivedObjectOfClass:codingClasses.class fromData:usernameData error:&error];
    [userDefaults synchronize];
    return username;
}
```

#### 个人总结

##### 王亮岛的个人总结

本人承担了应用开发界面的整体框架搭建，新闻详情页，评论功能，新闻搜索功能，收藏功能，用户界面和清理缓存功能的设计。总体上感觉自己收获挺大的，但是还只是处于IOS的入门阶段，还有很多知识和一些应用需要学习，这次的开发只是初步使用了线程加载图片，但是还是有一些问题要了解。关于IOS的属性，这次实训我只是会基本使用了，但是他们什么时候用还是不太清楚。值得骄傲的是我能够熟练使用UITableView和对组件进行布局和设计了。

##### 彭伟林的个人总结

一个学期过去了，对于学习一门开发来说，时间确实是远远不够的，这个学期其实也就是为我们指明了方向，那些知识是比较重要的。其实几个月来，掌握的知识只是毛皮而已，更多的是个人的能力得到了锻炼，编程能力与团队合作的能力都在这次的项目当中得到锻炼。在这个过程当中，很多知识都是现学现用，针对新闻标题的情况设计了较为负责的UITableViewCell，然后对其进行了一定的优化，这部分还是比较熟练的。

#### 人员分工与贡献度

王亮岛：承担了应用开发界面的整体框架搭建，新闻详情页，评论功能，新闻搜索功能，收藏功能，用户界面和清理缓存功能的设计。

彭伟林：承担了登录注册界面和功能的实现，前端自动登录功能和前端用户信息的管理，首页新闻信息的拉取与展示，UITableView的优化。