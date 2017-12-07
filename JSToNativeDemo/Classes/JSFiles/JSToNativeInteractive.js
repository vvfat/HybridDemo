//引入JS文件
//document.write('<script src="../scripts/ipu/JSToNativeCommon.js"><\/script>')
document.write('<script src="JSToNativeCommon.js"><\/script>')
//****************************对外提供js方法定义区**********************************
/**备注:以下方法只作为实例提供给common.js文件书写**/
//设置页面标题
function setPageTitle (title)
{
    sendMessage('setPageTitle:',title)
}

//返回按钮
function  backButtonAction()
{
    sendMessage('backButtonAction');
}
//关闭加载框
function  hideHUD()
{
    sendMessage('hideHUD');
}
//显示加载框
function  showHUD()
{
    sendMessage('showHUD');
}

function showToast(msg)
{
    sendMessage('showToast:',msg);
}
//当前页面刷新
function refresh() {
  sendMessage('refresh');
}
//跳转到下一个页面
function  openPage (pagePath, jsonParam, title, isInter,isEncrpty){
     var jsParam = {'pagePath':pagePath,'isInter':isInter,'isEncrpty':isEncrpty};
    if(jsonParam) jsParam.param = jsonParam;
    if(title) jsParam.title = title;
    sendMessage('openPage:',jsParam);
}

function openNativePage (className,jsonParam,title){
    var jsParam = {'className':className};
    if(jsonParam) jsParam.param = jsonParam;
    if(title) jsParam.title = title;
    sendMessage('openNativePage:',jsParam);

}

/**
 *  通过OC端发送请求
 *
 *  @param url        请求url
 *  @param jsonObj    请求参数
 *  @param isEncrpty  是否加密
 *  @param cache      true,使用缓存
 *  @param jsCallback
 *
 */
function postRequestFromJS (url,jsonObj,isEncrpty,cache,jsCallback)
{
    if(url == null) return;//url无效
    var jsParam = {'url':url};
    //一定要判断jsonObj是否有值，否则会导致发送消息失败
    if(jsonObj) jsParam.param = jsonObj;
    jsParam.isEncrpty = isEncrpty;
    jsParam.cache = cache;
    sendMessage('postRequestFromJS:completion:', jsParam, jsCallback);
}



//回退
function popByCount (count,needReload){
    if(count==null){
        count=0;
    }
    if(needReload==null){
        needReload = false;
    }
    var jsonParam = {'count':count,'needReload':needReload};
    sendMessage('popByCount:',jsonParam);
}




//设置右上角按钮
function setRightBarItem(title){
    sendMessage('setRightBarItem:',title);
}

//设置左上角按钮
function setLeftBarItem(){
    sendMessage('setLeftBarItem');
}

//设置左上角返回按钮

function setLeftBackItem(){
    sendMessage('setLeftBackItem');
}
//获取参数
function getValueFromJSParam(key,jsCallback){
    sendMessage('getValueFromJSParam:',key,jsCallback);
}

//获取url参数
function getUrlParam(key,jsCallback){
    sendMessage('getUrlParam:',key,jsCallback);
}

function testMethods(){

    sendMessage('testMethod:params2:params3:block:','abc');

}


 

/*
var clickObj =new function(){
    this.leftButtonClick = function(){
        alert('你点击了左侧原生按钮！');
        backButtonAction();
    };
    
    this.rightButtonClick = function(){
        alert('你点击了右侧原生按钮！');

    };
};

*/
 
//****************************oc2Js方法注册区域**********************************

var kEventActionToJS = 'kEventActionToJS'; //原生按钮被点击


//注册原生按钮点击事件
function ocToJs_EventAction(){
    ocToJs_registerHandler(kEventActionToJS,function(jsonParam){
        //这里可以根据业务编辑您的代码
        var key = jsonParam.key;
        var value = jsonParam.value;
        if  (key == 'right'){
            clickObj.rightButtonClick();
        }else{
            clickObj.leftButtonClick();
        }
    });
}

//注册所有事件
function bridgeRegisterHandler(){
    //接收原生到JS的消息
    ocToJs_EventAction();
}
 