// h5 页面需要把这个 JS 引入, 安卓也可以用这个

const messageHandlers = {};
// 自定义协议头, 本质还拦截
const CUSTOM_PROTOCOL_SCHEME = 'njhu';
const responseCallbacks = {};

// 假的 frame
function _createMessageIframe (src) {

    const messagingIframe = document.createElement('iframe');
    messagingIframe.style.display = 'none';
    messagingIframe.src = src;
    
    document.documentElement.appendChild(messagingIframe);
    setTimeout(function () {
               document.documentElement.removeChild(messagingIframe);
               }, 0);
}

// JS 注册原生的事件, handlerName: 原生的方法名字标识   handler: 回调
function registerHandler (handlerName, handler) {
    messageHandlers[handlerName] = handler;
    console.log(messageHandlers);
}


// js 调用原生的方法,handlerName: 原生方法标识, data: 传递给原生的 字典,  responseCallback执行后的回调
function callHandler (handlerName, data, responseCallback) {
    _doSend({handlerName: handlerName, data: data}, responseCallback);
}

// 包装数据
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
    console.log(messageJSON);
    messageJSON = messageJSON.replace(/(\t)/g, '    ');
    messageJSON = messageJSON.replace(/(\r\n)|(\n)/g, '<br>');
    const message = JSON.parse(messageJSON);
    
    if (message.responseId) {
        var responseCallback;
        responseCallback = responseCallbacks[message.responseId];
        if (!responseCallback) {
            return;
        }
        responseCallback(message.responseData);
        delete responseCallbacks[message.responseId];
    } else {
        var messageCallback;
        if (message.callbackId) {
            const callbackResponseId = message.callbackId;
            messageCallback = function (responseData) {
                _doSend({responseId: callbackResponseId, responseData: responseData});
            };
        }
        var handler;
        console.log(message.handlerName);
        console.log(messageHandlers);
        if (message.handlerName) {
            handler = messageHandlers[message.handlerName];
        }
        console.log(handler);
        if (handler) {
            handler(message.data, messageCallback);
        }
    }
    
}

const app = {
    callHandler: callHandler,
    _dispatchMessageFromApp: _dispatchMessageFromApp,
    registerHandler: registerHandler
};



