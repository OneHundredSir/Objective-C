>前言

本篇主要是围绕我自己弄的demo,根据我写的一篇[IAP内购入门详谈](http://www.jianshu.com/p/eb0fdd387f31)进行实战,如果有什么不足的地方,希望能给我提出建议,好让我更改哈


>正文    注意只能用于**真机**测试!!!!!!!

还是先分连个目录简单梳理下逻辑,以实战为主

**配置:**
1. 配置成自己游戏的bundleID `目的:为了识别绑定的游戏!这样就可以不用私钥了`
- 配置证书(注意这部分需要先在证书部分设置允许内购哈)`入门不细讲`
- Xcode打开内购开关

**开发逻辑**
1. 商品请求,设置一个set添加商品
- 设置沙盒环境
- 进行IAP请求,同时修改请求回调!

---
>**配置:**
1.配置成自己游戏的bundleID `目的:为了识别绑定的游戏!这样就可以不用私钥了`

![设置bundleID](http://upload-images.jianshu.io/upload_images/1730495-ad32c2d0074db8a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

2.配置证书(注意这部分需要先在证书部分设置允许内购哈)`基础不细讲`

![设置bundleID](http://upload-images.jianshu.io/upload_images/1730495-ad32c2d0074db8a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.Xcode打开内购开关
![打开内购](http://upload-images.jianshu.io/upload_images/1730495-7fd74d1f79ce4028.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
>**开发逻辑**
请先导入MJExtension和IAPHelper两个库,可以cocopod也可以直接和我demo一样把数据上传

1.商品请求,设置一个set添加商品
```
以商品ID为:"com.zeustel.fish.coin130"作为例子

    if(![IAPShare sharedHelper].iap) {
        NSSet* dataSet = [[NSSet alloc] initWithObjects:@"com.zeustel.fish.coin130", nil];
        
        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];
    }


```
2.设置沙盒环境
```
    //设置是否为沙盒路径
    [IAPShare sharedHelper].iap.production = NO;

```

3.进行IAP请求,同时修改请求回调!

```
//进行内购以及相关回调,请注意,这一步的时候一定要退出真机的apple账号!不然没法登陆测试账号
    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response > 0 ) {
             SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];
             NSLog(@"商品信息 -> %@",product.mj_keyValues);
//             product.mj_JSONString
             self.iapLabel.text = [NSString stringWithFormat:@"商品信息 -> \n%@",product.mj_JSONString];
             [[IAPShare sharedHelper].iap buyProduct:product
                                        onCompletion:^(SKPaymentTransaction* trans){
                                            
                                            if(trans.error)
                                            {
                                                NSLog(@"此处错误");
                                                NSLog(@"Fail %@",[trans.error localizedDescription]);
                                                self.iapLabel.text = [trans.error localizedDescription];
                                                
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStatePurchased) {
                                                //这里输入公共秘钥
                                                [[IAPShare sharedHelper].iap checkReceipt:trans.transactionReceipt AndSharedSecret:@"912bb173d02c46dfabfea25f63f493b6" onCompletion:^(NSString *response, NSError *error) {
                                                    
                                                    //Convert JSON String to NSDictionary
                                                    NSDictionary* rec = [IAPShare toJSON:response];
                                                    
                                                    if([rec[@"status"] integerValue]==0)
                                                    {
                                                        NSLog(@"购买成功");
                                                        self.iapLabel.text = @"购买成功";
                                                        [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];
                                                        NSLog(@"SUCCESS %@",response);
                                                        NSLog(@"Pruchases %@",[IAPShare sharedHelper].iap.purchasedProducts);
                                                        
                                                        self.iapLabel.text = [NSString stringWithFormat:@"SUCCESS %@ \nPruchases %@",response,[IAPShare sharedHelper].iap.purchasedProducts];
                                                        
                                                    }
                                                    else {
                                                        NSLog(@"Fail");
                                                        self.iapLabel.text = @"Fail";
                                                    }
                                                }];
                                            }
                                            else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                NSLog(@"Fail");
                                                self.iapLabel.text = @"Fail";
                                            }
                                        }];//end of buy product
         }
     }];

```
废话不说,上演示实例

![操作实例](http://upload-images.jianshu.io/upload_images/1730495-aa6061f44fabe5aa.gif?imageMogr2/auto-orient/strip)

>香蕉家githubDemo下载,喜欢记得给我点赞哈

