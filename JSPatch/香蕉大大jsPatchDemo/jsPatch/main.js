//  作者:香蕉大大  简书地址：http://www.jianshu.com/users/a3ae6d7c68b6/latest_articles
//  微信个人技术公众号：大大家的IOS说（一起用碎片时间学习最新最有用的IOS资料）
//  微信个人账号：hundreda


defineClass("ViewController", {
         tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
         var cell = tableView.dequeueReusableCellWithIdentifier("cell")
         if (!cell) {
         cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
         }
         cell.textLabel().setText("1")
         return cell
         },
}
)