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



 require('UIAlertView');
defineClass('ViewController', {
    tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
        var alert = UIAlertView.alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("提示", "恭喜弹出", null, "确定", null);
        alert.show();
    },
});