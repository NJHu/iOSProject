// h5 页面需要把这个 JS 引入, 安卓也可以用这个

const messageHandlers = {};
// 自定义协议头, 本质还拦截
const CUSTOM_PROTOCOL_SCHEME = 'njhu_h5_scheme';
const responseCallbacks = {};

function _createMessageIframe (src) {
    
    const messagingIframe = document.createElement('iframe');
    messagingIframe.style.display = 'none';
    messagingIframe.src = src;
    
    document.documentElement.appendChild(messagingIframe);
    setTimeout(function () {
               document.documentElement.removeChild(messagingIframe);
               }, 0);
}

// JS 发送消息, data: json   responseCallback: 回调
function send (data, responseCallback) {
    _doSend({data: data}, responseCallback);
}

// JS 注册原生的事件, handlerName: 原生的方法名字标识   handler: 回调
function registerHandler (handlerName, handler) {
    messageHandlers[handlerName] = handler;
}

// 获取回调的代码
function getHandler (handlerName) {
    return messageHandlers[handlerName];
}

// js 调用原生的方法,handlerName: 原生方法标识, data: 传递给原生的 字典,  responseCallback执行后的回调
function callHandler (handlerName, data, responseCallback) {
    _doSend({handlerName: handlerName, data: data}, responseCallback);
}

//
function _doSend (message, responseCallback) {
    if (responseCallback) {
        const callbackId = 'cb_' + new Date().getTime();
        responseCallbacks[callbackId] = responseCallback;
        message.callbackId = callbackId;
    }
    const messageQueueString = JSON.stringify(message);
    _createMessageIframe(CUSTOM_PROTOCOL_SCHEME + '://__return_message__/' + encodeURIComponent(messageQueueString));
}

function _dispatchMessageFromApp (messageJSON) {
    
    messageJSON = messageJSON.replace(/(\t)/g, '    ');
    messageJSON = messageJSON.replace(/(\r\n)|(\n)/g, '<br>');
    const message = JSON.parse(messageJSON);
    var responseCallback;
    if (message.responseId) {
        responseCallback = responseCallbacks[message.responseId];
        if (!responseCallback) {
            return;
        }
        responseCallback(message.responseData);
        delete responseCallbacks[message.responseId];
    } else {
        if (message.callbackId) {
            const callbackResponseId = message.callbackId;
            responseCallback = function (responseData) {
                _doSend({responseId: callbackResponseId, responseData: responseData});
            };
        }
        var handler;
        if (message.handlerName) {
            handler = messageHandlers[message.handlerName];
        }
        if (handler) {
            handler(message.data, responseCallback);
        }
    }
    
}


_createMessageIframe(CUSTOM_PROTOCOL_SCHEME + '://__init_app__');



const app = {
    startPage: startPage,
    startAction: startAction,
    get: get,
    set: set,
    close: close,
    send: send,
    registerHandler: registerHandler,
    getHandler: getHandler,
    callHandler: callHandler,
    _dispatchMessageFromApp: _dispatchMessageFromApp
};

// =================================WKBridgeTool 已经注册啦
// 调用app原生页面
function startPage (data) {
    callHandler('startPage', data, null);
}

// 调用app原生功能或事件（app原生类的静态方法）,
function startAction (data, responseCallback) {
    callHandler('startAction', data, responseCallback);
}

// 获取app本地存储的数据, keys为要获取数据数组key： ["username", "password"]
function get (keys, responseCallback) {
    callHandler('get', keys, responseCallback);
}

// 保存数据到app原生, data 为要保存到app本地的数据： {"username":"xxx", "password":"xxx"}
function set (data) {
    callHandler('set', data, null);
}

// 关闭h5
function close () {
    callHandler('close', '', null);
}





