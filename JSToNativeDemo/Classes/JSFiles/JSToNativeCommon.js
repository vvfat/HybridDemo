
//应该与OC文件中注册的名称统一
var kConnectToNative = 'kConnectToNative';

function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
                                  callback(WebViewJavascriptBridge)
                                  }, false)
    }
}

    connectWebViewJavascriptBridge
    (
         function(bridge)
         {
            bridge.init(null);
            //接收来自OC的数据,必须先注册事件
            bridgeRegisterHandler();
     
    });

//js2oc公共方法调用区

/**
 *  构造传递给OC端的参数
 *
 *  @param key        对应OC端的方法名称
 *  @param value      对应OC端方法的参数
 *  @param jsCallback 回调方法的返回值
 */
function sendMessage (key,value,jsCallback){
    var jsParam  = {'key':key};
    if(value) jsParam.value = value;
     sendMessageToOC (jsParam,jsCallback );
}

/**
 *  调用OC端方法
 *
 *  @param jsonValue  方法及参数
 *  @param jsCallback 回调
 *
 */
function sendMessageToOC(jsonValue,jsCallback){
    
    connectWebViewJavascriptBridge(function(bridge) {
        bridge.callHandler(kConnectToNative,jsonValue , jsCallback);
    });
}

//注册oc2Js_公共方法
/**
 *  注册事件
 *
 *  @param handlerName      事件名称
 *  @param callbackFunction 回调函数
 *
 */
function ocToJs_registerHandler(handlerName,callbackFunction){
    connectWebViewJavascriptBridge(function(bridge) {
        bridge.registerHandler(handlerName,callbackFunction)
    });
}


