/*
* Debug工具，方便在输出屏幕上，调试代码信息
* 1）初始化Debug工具方法
* Debug.init(param)  参数:param 传1 表示初始化即开启debug模式，不传或传0初始化后，启动debug需要先调用debug.open()方法才可打印
*
* 2）输出打印信息
* Debug.print( message ) 日志输出方法，message即要输出的调式信息
*
* Debug.cls() 清屏方法
* */
var Debug =(function(){
    return {
        is_open: 0,
        empty: 1,
        args: [],
        div: null,
        box: null,
        init: function(flag) {
            var _div = document.createElement("div"),
                _box = document.createElement("div");
            _box.id = "debug_box";
            _div.id = "debug_div";
            if (0 < navigator.userAgent.indexOf("JETU")) {
                _box.style.cssText = "margin: 0;color: #00ff00; word-wrap: break-word; word-break: normal;";
                _div.style.cssText = "position:absolute;border: 1px solid green; right:38px;left:38px; top:38px; height:auto; font-size: 12px; z-index:99999; padding: 6px; background-color: rgba(0, 0, 0, 0.6);"
            } else {
                _box.style.margin = "0";
                _box.style.color = "#00ff00";
                _div.style.display = "none";
                _div.style.position = "absolute";
                _div.style.border = "1px solid green";
                _div.style.padding = "6px";
                _div.style.right = "38px";
                _div.style.left = "38px";
                _div.style.top = "38px";
                _div.style.height = "auto";
                _div.style.fontSize = "12px";
                _div.style.zIndex = "99999";
                _div.style.backgroundColor = "rgba(0, 0, 0, 0.6)"
            }
            _div.appendChild(_box);
            document.body.appendChild(_div);
            this.div = _div;
            this.box = _box;
            if(flag!=undefined&&flag){
                this.open();
            }
        },
        write: function() {
            if (0 == this.is_open) {
                return
            }
            if (null === this.div) {
                this.init()
            }
            var _msgs = [],
                _str = "",
                _args = this.args;
            for (var i = 0; i < _args.length; i++) {
                _msgs.push(this.parse(_args[i], 0))
            }
            if (!this.empty) {
                if (670 < this.div.offsetHeight) {
                    this.box.innerText = ""
                } else {
                    _str = "\r\n<br />------------------------------\r\n<br />" + _str
                }
            } else {
                this.div.style.display = "block"
            }
            this.box.innerHTML = this.box.innerHTML + _str + _msgs.join(",");
            this.args = [];
            this.empty = 0;
            return true
        },
        parse: function(variable_, level_) {
            var _str = "";
            if ("undefined" == typeof(variable_)) {
                _str += "[undefined]"
            } else {
                if (variable_ === null) {
                    _str += "[null]"
                } else {
                    if ("function" == typeof(variable_)) {
                        _str += "[function]" + variable_.toString()
                    } else {
                        if (variable_.nodeType && 1 == variable_.nodeType) {
                            _str += "[HTML node]"
                        } else {
                            if (variable_ instanceof Error) {
                                if (variable_.stack) {
                                    _str += '<span style="color:#ff0000">' + variable_.stack + "<span>"
                                } else {
                                    _str += '<span style="color:#ff0000">' + variable_.toString() + "<span>"
                                }
                            } else {
                                if (variable_ instanceof Array) {
                                    if (variable_[0] instanceof Array || variable_[0] instanceof Object) {
                                        _str += "[\r\n<br />";
                                        for (var i = 0; i < variable_.length; i++) {
                                            _str += new Array(level_ + 2).join("&nbsp;&nbsp;&nbsp;&nbsp;") + arguments.callee(variable_[i], level_ + 1);
                                            _str += "\r\n<br />"
                                        }
                                        _str += new Array(level_ + 1).join("&nbsp;&nbsp;&nbsp;&nbsp;") + "]"
                                    } else {
                                        _str = "[" + variable_.toString() + "]"
                                    }
                                } else {
                                    if (variable_ instanceof Object) {
                                        if (variable_.Infinity) {
                                            _str += "[Infinity Object]"
                                        } else {
                                            if (2 < level_) {
                                                _str += "[Object]"
                                            } else {
                                                _str += "{";
                                                try{

                                                // if (variable_ instanceof Event) {
                                                //     for (var i in variable_) {
                                                //         _str += "\r\n<br />";
                                                //         _str += new Array(level_ + 2).join("&nbsp;&nbsp;&nbsp;&nbsp;") + i + ":" + variable_[i]
                                                //     }
                                                // } else {
                                                    for (var i in variable_) {
                                                        _str += "\r\n<br />";
                                                        _str += new Array(level_ + 2).join("&nbsp;&nbsp;&nbsp;&nbsp;") + i + ":" + arguments.callee(variable_[i], level_ + 1)
                                                    }
                                                // }
                                                if ("undefined" == typeof(i)) {
                                                    _str += "}"
                                                } else {
                                                    _str += "\r\n<br />" + new Array(level_ + 1).join("&nbsp;&nbsp;&nbsp;&nbsp;") + "}"
                                                }
                                                }catch (e){
                                                    this.log("==============88888============"+e);
                                                }
                                            }

                                        }
                                    } else {
                                        if (!variable_ && 0 !== variable_ && "0" !== variable_) {
                                            _str += "[empty]"
                                        } else {
                                            _str += variable_
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return _str
        },
        clean: function() {
            if (null === this.div) {
                this.init()
            }
            this.div.style.display = "none";
            this.box.innerText = "";
            this.empty = 1;
            return true
        },
        open: function () {
            this.is_open = 1;
        },
        print: function () {
            this.args = arguments;
            this.write();
        },
        cls: function () {
            this.clean();
            this.args = arguments;
            this.write();
        },
        log: function (log_info) {
            var log_img = document.createElement("img");
            log_img.src = "JSConsole?logtype=normal&t=" + (new Date()).getTime() + "&msg=" + log_info;
        }
    };
})();