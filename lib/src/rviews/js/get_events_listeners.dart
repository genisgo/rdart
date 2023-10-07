part of 'nativeJs.dart';

ScriptElement getEventListeners() {
  ScriptElement getEventListeners = ScriptElement();
  getEventListeners.innerHtml = """  (function () {
      'use strict';

      // save the original methods before overwriting them
      Element.prototype._addEventListener = Element.prototype.addEventListener;
      Element.prototype._removeEventListener = Element.prototype.removeEventListener;

      /**
       * [addEventListener description]
       * @param {[type]}  type       [description]
       * @param {[type]}  listener   [description]
       * @param {Boolean} useCapture [description]
       */
      Element.prototype.addEventListener = function (type, listener, useCapture = false) {
        // declare listener
        this._addEventListener(type, listener, useCapture);

        if (!this.eventListenerList) this.eventListenerList = {};
        if (!this.eventListenerList[type]) this.eventListenerList[type] = [];

        // add listener to  event tracking list
        this.eventListenerList[type].push({ type, listener, useCapture });
      };

      /**
       * [removeEventListener description]
       * @param  {[type]}  type       [description]
       * @param  {[type]}  listener   [description]
       * @param  {Boolean} useCapture [description]
       * @return {[type]}             [description]
       */
      Element.prototype.removeEventListener = function (type, listener, useCapture = false) {
        // remove listener
        this._removeEventListener(type, listener, useCapture);

        if (!this.eventListenerList) this.eventListenerList = {};
        if (!this.eventListenerList[type]) this.eventListenerList[type] = [];

        // Find the event in the list, If a listener is registered twice, one
        // with capture and one without, remove each one separately. Removal of
        // a capturing listener does not affect a non-capturing version of the
        // same listener, and vice versa.
        for (let i = 0; i < this.eventListenerList[type].length; i++) {
          if (this.eventListenerList[type][i].listener === listener && this.eventListenerList[type][i].useCapture === useCapture) {
            this.eventListenerList[type].splice(i, 1);
            break;
          }
        }
        // if no more events of the removed event type are left,remove the group
        if (this.eventListenerList[type].length == 0) delete this.eventListenerList[type];
      };


      /**
       * [getEventListeners description]
       * @param  {[type]} type [description]
       * @return {[type]}      [description]
       */
      Element.prototype.getEventListeners = function (type) {
        if (!this.eventListenerList) this.eventListenerList = {};

        // return reqested listeners type or all them
        if (type === undefined) return this.eventListenerList;
        return this.eventListenerList[type];
      };
     
    })();


    //iniEvent();

    
    function iniEvent() {
      setTimeout(() => {
        var print = (e) => {
          console.log(e);
        }
        var btns = document.querySelectorAll("button");

        btns.forEach(element => {

          var f = element.getEventListeners("click");
          var lt = f.length;
          for (let index = 0; index < lt - 1; index++) {

            f.forEach((e) => {
              element.removeEventListener(e.type, e.listener, e.useCapture)
              console.log("delete \${e}")
            })

          }

        });
      }, 1);

      console.log("eventtttt")
    }
setBootstrap()
  function  setBootstrap(){
     const bootstrap = document.createElement('script');
      
      bootstrap.setAttribute("src", "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js",)
     
      bootstrap.setAttribute("integrity", "sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL")

      bootstrap.setAttribute("crossorigin", "anonymous")
      document.head.appendChild(bootstrap)}

    """;
  return getEventListeners;
}
