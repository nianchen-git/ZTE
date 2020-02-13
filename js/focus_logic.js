window.focus_logic = new Object();
(function () {

    function Page() {
        this.areas = new Array();
        this.curAreaIndex = 0;


        this.move = function (direction) {

            this.moveDirection(direction); //方向键事件

            this._dir(direction);
            var targets = this.areas[this.curAreaIndex].move(direction);	//值为undefined时表示焦点区域内移动,值为num时表示跨区域焦点移动反回下一个区域在集合中的下标,值为Array时表示将移动到指定区域的指定位置
            if (targets != undefined) {
                var tmpNextArea;
                if (_isArray(targets)) {
                    tmpNextArea = targets[0];
                    this.areas[tmpNextArea].curDomIndex = targets[1] >= this.areas[tmpNextArea].domsCount ? (this.areas[tmpNextArea].domsCount - 1) : targets[1];
                } else {
                    tmpNextArea = targets;
                    if (this.curAreaIndex != this.areas[tmpNextArea].childAreaIndex) {
                        this.areas[tmpNextArea].curDomIndex = 0;
                    }
                    ;
                }
                ;
                if (this.areas[tmpNextArea].domsCount <= 0) return;
                this.setCurrentFocus(tmpNextArea);
            }
            ;
        };

        this.pageTurn = function (num) {
            this.areas[this.curAreaIndex].pageTurn(num, this.curAreaIndex);
        };

        this.dirEvent = undefined;	//方向键事件,当前区域没有定义方向键事件执行
        this._dir = function (direction) {
            if ((!!this.areas[this.curAreaIndex]._dir(direction)) && this.dirEvent != undefined) {
                this.dirEvent(direction);
            }
            ;
        };

        this.okEvent = undefined;	//点击确定键执行的function,如果当前区域没有定义ok事件则执行当前页的ok事件
        this.ok = function () {
            if ((!!this.areas[this.curAreaIndex].ok()) && this.okEvent != undefined) {
                this.okEvent();
            }
            ;
        };

        this.backEvent = undefined;	//点击返回键执行的function,如果当前区域没有定义返回事件则执行当前页的返回事件
        this._back = function () {
            if ((!!this.areas[this.curAreaIndex]._back()) && this.backEvent != undefined) {
                this.backEvent();
            }
            ;
        };

        this.moveDirectionEvent = undefined;		//方向键事件0，1，2，3   上下左右
        this.moveDirection = function (direction) {
            if ((!!this.areas[this.curAreaIndex].moveDirection(direction)) && this.moveDirectionEvent != undefined) {
                this.moveDirectionEvent(direction);
            }
            ;
        };

        this.numInputEvent = undefined;	//输入数字执行的function,如果当前区域没有定义数字输入事件则执行当前页的数字输入事件
        this.numInput = function (num) {
            if ((!!this.areas[this.curAreaIndex].numInput(num)) && this.numInputEvent != undefined) {
                this.numInputEvent(num);
            }
            ;
        };

        this.setCurrentFocus = function (_curAreaIndex, _curDomIndex) {

            if (this.curAreaIndex != _curAreaIndex) {
                this.clearFocus(this.curAreaIndex, this.areas[this.curAreaIndex].curDomIndex);
                this.areas[_curAreaIndex].preAreaIndex = this.curAreaIndex;
                this.areas[this.curAreaIndex].objFocusHidden();
                if (this.areas[this.curAreaIndex].areaOutEvent != undefined) {
                    this.areas[this.curAreaIndex].areaOutEvent();
                }
                ;
                this.curAreaIndex = _curAreaIndex;
                this.areas[this.curAreaIndex].objFocusVisible();
            }
            ;

            if (_curDomIndex != undefined) {
                this.areas[this.curAreaIndex].objFocusVisible(_curDomIndex);
                this.areas[_curAreaIndex].setCurrentFocus(_curDomIndex, "appoint");
            } else {
                this.areas[_curAreaIndex].setCurrentFocus("", "cross");
            }
            ;
        };

        this.clearFocus = function (_curAreaIndex, _curDomIndex) {
            this.areas[_curAreaIndex].clearFocus(_curDomIndex);
        };

        //设置栏目和节目的区域关系
        this.setAreaMembership = function (parentAreaid, childAreaId) {
            this.areas[parentAreaid].childAreaIndex = childAreaId;
            this.areas[childAreaId].parentAreaIndex = parentAreaid;
        };
    };

    function Area(row, colum, doms, areaDirections, curDomIndex,turnDirection) {
        this.row = row;
        this.colum = colum;
        this.doms = doms;
        this.areaDirections = areaDirections;	//区域之间的移动规则,定义上左下右移动逻辑的数组
        this.curIndex = undefined;	//当前区域在page.areas数组中的下标
        this.curDomIndex = curDomIndex == undefined ? 0 : curDomIndex;	//区域内默认焦点
        this.preDomIndex = this.curDomIndex;	//当前焦点的上一个焦点
        this.childAreaIndex = undefined;	//当前区域如果是栏目,则此值表示当前栏目下的内容所在的区域
        this.parentAreaIndex = undefined;	//当前区域的父栏目区域
        this.preAreaIndex = undefined;	//焦点移动到当前区域之前的区域的index
        this.domsMaxLength = this.row * this.colum;	//区域内最多能加载dom的个数
        this.objFocus = undefined;	//设置焦点移动的滑动效果["menu_top_focus",[20,125],[101,0],10)]个参数分别表示焦点框id,横向平移的各项属性[每次移动步长,初始left属性值],纵向移动的各项属性[步长，初始top值],移动到下个焦点的总时长
        this.domNavId = undefined;

        this.dataCount = undefined;	//区域内需要载入的数据的总个数
        this.domsCount = this.row * this.colum;	//区域内dom元素的数量,对于翻页造成区域内dom元素少于row*colum的情况，需要重新赋值
        this.pageNumber = 1;		//当前区域所展示的页码
        this.pageTotal = undefined;	//区域总页数

        //封装文字跑马灯效果参数
        this.dataList = undefined;
        this.normalTxtAttr = undefined;
        this.cutTxtAttr = undefined;
        this.domTxtId = undefined;
        this.listFlag = undefined;	//dataList是否是取的全部数据1表示是，0表示取的当页数据

        this.areaOutEvent = undefined;	//焦点移出区域执行此事件


        this.focusEvent = undefined;	//区域中dom元素获得焦点时执行此事件
        this.pageTurnEvent = undefined;	//翻页事件,焦点逻辑处理完之后调用
        this.turnDirection = turnDirection;//自定义翻页事件方向，0为上下，1为左右,-1为禁止方向键翻页,
        this.pageTurn = function (num, _curAreaIndex) {
            if (this.pageTotal == undefined || this.pageTotal <= 1) return;
            this.preDomIndex = this.curDomIndex;
            if (num != undefined) {
                if (typeof (num) == "string") {
                    this.pageNumber = parseInt(num);
                } else {
                    this.pageNumber = this.pageNumber + num;
                    if (this.pageNumber > this.pageTotal) {
                        this.pageNumber = 1;
                    } else if (this.pageNumber <= 0) {
                        this.pageNumber = this.pageTotal;
                    }
                    ;
                }
                ;
            }
            ;

            this.domsCount = this.pageTotal == this.pageNumber ? ((this.dataCount - 1) % (this.domsMaxLength) + 1) : this.domsMaxLength;

            this.curDomIndex = this.curDomIndex >= this.domsCount ? (this.domsCount - 1) :(_curAreaIndex != undefined && _curAreaIndex == this.curIndex?0:this.curDomIndex);//为实现页面pageTurnEvent方法实时获取curDomIndex

            if (this.pageTurnEvent != undefined) {
                this.pageTurnEvent();
            };

            this.setDomsTxt();
            if (_curAreaIndex != undefined && _curAreaIndex == this.curIndex) {
                this.clearFocus(this.preDomIndex);//为防止采用翻页键翻页，页面之前的焦点无法清除的问题；
                this.setCurrentFocus(0, "pageTurn");
            };
            
            this.refreshDom();
        };

        this.move = function (direction) {
            var targets = this.doms[this.curDomIndex].move(direction);
            if (targets != undefined && _isArray(targets)) {
                if (targets.length == 1) {
                    if (this.areaDirections[direction] != -1) {
                        targets.unshift(this.areaDirections[direction]);
                    } else {
                        targets.unshift(this.curIndex);
                    }
                    ;
                }
                ;
                if (this.curIndex == targets[0]) {
                    this.clearFocus(this.curDomIndex);
                }
                ;
                return targets;
            }
            ;
            var dir = direction % 2;	//等于0为纵向移动，等于1为横向移动;
            var step = dir == direction ? -1 : 1;	//移动步伐，-1向左者向上，1向右或向下
            var cross;	//判断焦点是否要移动至下一个区域,true(移至下一个区域),false(区域内移动);
            //计算cross的值
            if (dir == 0) {
                if (step == 1) {
                    if (this.domsCount) {
                        cross = (this.curDomIndex + 1 + step * this.colum) > this.domsCount;
                    } else {
                        cross = (this.curDomIndex + 1 + step * this.colum) > this.domsMaxLength;
                    }
                    ;
                } else {
                    cross = (this.curDomIndex + step * this.colum) < 0;
                }
                ;
            } else {
                if (step == 1) {
                    if (this.domsCount) {
                        cross = (this.curDomIndex + step >= this.domsCount) || (this.curDomIndex % this.colum == (this.colum - 1));
                    } else {
                        cross = this.curDomIndex % this.colum == (this.colum - 1);
                    }
                    ;
                } else {
                    cross = this.curDomIndex % this.colum == 0;
                }
                ;
            }
            ;

            if (!cross) {
                var tmpDomIndex = this.curDomIndex;
                if (dir == 0) {
                    this.curDomIndex = this.curDomIndex + step * this.colum;
                } else {
                    this.curDomIndex = this.curDomIndex + step;
                }
                ;
                this.clearFocus(tmpDomIndex);
                this.setCurrentFocus("", "inside");
            } else {
                if (this.areaDirections[direction] != -1) {
                    return this.areaDirections[direction];
                } else {
                    if (this.dataCount != undefined) {
                        var tmpDomIndex = this.curDomIndex;
                        var _row = Math.ceil(this.domsCount / this.colum);	//得到当前数据填充的行数
                        if ((_row <= 1 && dir == 0 && this.pageTotal == 1) || (this.colum == 1 && dir == 1) || (this.domsCount == 1 && this.pageTotal == 1)||this.turnDirection!=undefined&& this.pageTotal == 1) return;
                        if (dir == 0) {
                            if (this.row == 1||this.turnDirection!=undefined&&this.turnDirection) return;
                            if (step == 1) {
                                if (this.pageTotal == 1) {
                                    if (Math.ceil((this.curDomIndex + 1) / this.colum) < _row) {
                                        this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                    } else {
                                        this.curDomIndex = this.curDomIndex % this.colum;
                                    }
                                    ;
                                    this.pageNumber = 1;
                                } else{
                                    this.curDomIndex = this.curDomIndex % this.colum;
                                    this.pageNumber = this.pageNumber == this.pageTotal ? 1 : (this.pageNumber + step);
                                }
                                ;
                            } else {
                                if (this.pageNumber == 1) {
                                    if (this.pageTotal == 1) {
                                        this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                    } else{
                                        this.curDomIndex = (this.dataCount - 1) % (this.domsMaxLength);
                                    }
                                    ;
                                    this.pageNumber = this.pageTotal;
                                } else{
                                    this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                    this.pageNumber = this.pageNumber + step;
                                }
                                ;
                            }
                            ;
                        } else {
                            if(this.turnDirection!=undefined&&!this.turnDirection||this.turnDirection==-1){
                                return;
                            }else if(this.turnDirection){
                                if (step == 1) {
                                    if (this.pageTotal == 1) {
                                        if (Math.ceil((this.curDomIndex + 1) / this.colum) < _row) {
                                            this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                        } else {
                                            this.curDomIndex = this.curDomIndex % this.colum;
                                        }
                                        ;
                                        this.pageNumber = 1;
                                    } else{
                                        this.curDomIndex = this.curDomIndex % this.colum==(this.colum-1)?this.curDomIndex:0;
                                        this.pageNumber = this.pageNumber == this.pageTotal ? 1 : (this.pageNumber + step);
                                    }
                                    ;
                                } else {
                                    if (this.pageNumber == 1) {
                                        if (this.pageTotal == 1) {
                                            this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                        } else{
                                            this.curDomIndex = (this.dataCount - 1) % (this.domsMaxLength);
                                        }
                                        ;
                                        this.pageNumber = this.pageTotal;
                                    } else{
                                        // this.curDomIndex = this.curDomIndex % this.colum + (this.row - 1) * this.colum;
                                        this.pageNumber = this.pageNumber + step;
                                    }
                                    ;
                                }
                                ;

                            }else{
                                this.curDomIndex = this.curDomIndex + step;
                                if (this.curDomIndex >= this.domsCount) {
                                    this.curDomIndex = 0;
                                    this.pageNumber = this.pageNumber == this.pageTotal ? 1 : (this.pageNumber + step);
                                } else if (this.curDomIndex < 0) {
                                    if (this.pageNumber == 1) {
                                        this.curDomIndex = (this.dataCount - 1) % (this.domsMaxLength);
                                        this.pageNumber = this.pageTotal;
                                    } else {
                                        this.curDomIndex = this.domsMaxLength - 1;
                                        this.pageNumber = this.pageNumber + step;
                                    }
                                    ;
                                }
                                ;
                            }
                            
                        }
                        ;
                        this.pageTurn();
                        this.curDomIndex = this.curDomIndex >= this.domsCount ? (this.domsCount - 1) : this.curDomIndex;
                        this.clearFocus(tmpDomIndex);
                        this.setCurrentFocus("", "circle");
                    }
                    ;
                }
                ;
            }
            ;
        };

        this.dirEvent = undefined;	//方向键事件,当前焦点没有定义方向键事件执行
        this._dir = function (direction) {
            if (!!this.doms[this.curDomIndex]._dir(direction)) {
                if (this.dirEvent != undefined) {
                    return this.dirEvent(direction);
                } else {
                    return true;
                }
                ;
            } else {
                return false;
            }
            ;
        };

        this.okEvent = undefined;	//如果当前焦点没有定义ok事件，则执行此区域的ok事件
        this.ok = function () {
            if (!!this.doms[this.curDomIndex].ok()) {
                if (this.okEvent != undefined) {
                    return this.okEvent();
                } else {
                    return true;
                }
                ;
            } else {
                return false;
            }
            ;
        };

        this.backEvent = undefined;	//如果当前焦点没有定义返回事件，则执行此区域的返回事件
        this._back = function () {
            if (!!this.doms[this.curDomIndex]._back()) {
                if (this.backEvent != undefined) {
                    return this.backEvent();
                } else {
                    return true;
                }
                ;
            } else {
                return false;
            }
            ;
        };

        this.moveDirectionEvent = undefined;		//方向键事件0，1，2，3   上下左右
        this.moveDirection = function (direction) {
            if (!!this.doms[this.curDomIndex].moveDirection(direction)) {
                if (this.moveDirectionEvent != undefined) {
                    return this.moveDirectionEvent(direction);
                } else {
                    return true;
                }
                ;
            } else {
                return false;
            }
            ;
        };

        this.numInputEvent = undefined;	//输入数字执行的function,如果当前焦点没有定义数字输入事件则执行当前区域的数字输入事件
        this.numInput = function (num) {
            if (!!this.doms[this.curDomIndex].numInput(num)) {
                if (this.numInputEvent != undefined) {
                    return this.numInputEvent(num);
                } else {
                    return true;
                }
                ;
            } else {
                return false;
            }
            ;
        };

        this.setCurrentFocus = function (_curDomIndex, _type) {
            if (_curDomIndex !== "") {
                this.clearFocus(this.curDomIndex);
                this.curDomIndex = _curDomIndex;
            }
            ;
            this.doms[this.curDomIndex].changeStyle(true, this.objFocus);

            if (!!this.doms[this.curDomIndex]._focus()) {
                if (this.focusEvent != undefined) {
                    this.focusEvent(_type);		//_type有五个值"appoint"表示page对象调用setCurrentFocus方法指定焦点移动到某个点的情况,"cross"表示焦点跨区域移动的情况,"pageTurn"表示翻页时的焦点移动,"inside"表示区域内的焦点移动的情况,"circle"表示区域内焦点的循环移动的情况(例如1排3列的区域内,焦点在0号位置再向上移动焦点会移动到2号位置)
                }
                ;
            }
            ;
        };

        this.clearFocus = function (_curDomIndex) {
            this.preDomIndex = _curDomIndex;
            this.doms[_curDomIndex].changeStyle(false);
        };

        this.setDataCount = function (num, domNavId) {
            this.dataCount = num;
            this.domsMaxLength = this.colum * this.row;
            this.pageTotal = Math.ceil(this.dataCount / (this.colum * this.row));
            if (this.pageTotal == 0) {
                this.domsCount = 0;
                this.pageTotal = 1;
            } else {
                this.domsCount = this.pageTotal == this.pageNumber ? ((this.dataCount - 1) % (this.domsMaxLength) + 1) : this.domsMaxLength;
            }
            ;
            if (domNavId != undefined) {
                this.domNavId = domNavId;
            }
            ;
            this.refreshDom();
        };

        this.refreshDom = function () {
            for (var i = 0; i < this.domsMaxLength; i++) {
                var _element;
                if (this.domNavId != undefined) {
                    _element = $(this.domNavId + i);
                } else {
                    _element = this.doms[i].element;
                }
                ;
                if (_element != undefined && _element != "" && _element != null && _element != "null") {
                    try {
                        if (this.domsCount > i) {
                            _element.style.visibility = "visible";
                        } else {
                            _element.style.visibility = "hidden";
                        }
                        ;
                    } catch (e) {
                        console.log("refreshDom---this.domsCount:" + this.domsCount + "--i:" + i);
                    }
                    ;
                }
                ;
            }
            ;
        };

        this.objFocusHidden = function () {
            if (this.objFocus != undefined) {
                $(this.objFocus[0]).style.visibility = "hidden";
            }
            ;
        };

        this.objFocusVisible = function (_curDomIndex) {
            var tempDomIndex = _curDomIndex == undefined ? this.curDomIndex : _curDomIndex;
            if (this.objFocus != undefined) {
                $(this.objFocus[0]).style.left = (parseInt(this.doms[tempDomIndex].element.style.left) + (this.objFocus[1][1] == undefined ? 0 : this.objFocus[1][1])) + "px";
                $(this.objFocus[0]).style.top = (parseInt(this.doms[tempDomIndex].element.style.top) + (this.objFocus[2][1] == undefined ? 0 : this.objFocus[2][1])) + "px";
                $(this.objFocus[0]).style.visibility = "visible";
            }
            ;
        };

        this.setAttrForDomsTxt = function (dataList, normalTxtAttr, cutTxtAttr, listFlag, domTxtId) {
            this.dataList = dataList;
            this.normalTxtAttr = normalTxtAttr;
            this.cutTxtAttr = cutTxtAttr;
            this.listFlag = listFlag;
            this.domTxtId = domTxtId;
            this.setDomsTxt(false);
        };

        this.setDomsTxt = function (first_in) {
            if (this.listFlag != undefined) {
                var _offset = (this.pageNumber - 1) * this.domsMaxLength * this.listFlag;
                for (var i = 0; i < this.domsMaxLength; i++) {
                    try {
                        if (i < this.domsCount) {
                            if (this.normalTxtAttr == -1 || this.cutTxtAttr == -1) {
                                this.doms[i].normalTxt = this.dataList[0][i + _offset];
                                this.doms[i].cutTxt = this.dataList[1][i + _offset];
                            } else {
                                this.doms[i].normalTxt = this.dataList[i + _offset][this.normalTxtAttr];
                                this.doms[i].cutTxt = this.dataList[i + _offset][this.cutTxtAttr];
                            }
                            ;
                            if (this.domTxtId != undefined) {
                                this.doms[i].domTxtId = this.domTxtId + i;
                            }
                            ;
                            if (!first_in) {
                                $(this.doms[i].domTxtId).innerHTML = this.doms[i].cutTxt;
                            }
                            ;
                        } else {
                            this.doms[i].normalTxt = undefined;
                            this.doms[i].cutTxt = undefined;
                        }
                        ;
                    } catch (e) {
                        console.log("setDomsTxt---dataList:" + this.dataList);
                        console.log("_offset:" + _offset + "--i:" + i + "--this.pageNumber:" + this.pageNumber);
                        console.log(e.message + ":" + e.name);
                    }
                    ;
                }
                ;
            }
            ;
        };

        this.setMarqueeWidth = function (_width) {
            for (var i = 0; i < this.domsMaxLength; i++) {
                this.doms[i].marquee = _width + "px";
            }
            ;
        };
    };

    function Dom(domId, focusClassName, blurClassName) {
        this.domId = domId;
        this.focusClassName = focusClassName;
        this.blurClassName = blurClassName;
        this.curIndex = undefined;
        this.moveRule = undefined;	//单独定义此dom的移动规则，以数组的形式表示,如[-1,-1,[3],[1,4]]按[上,左,下,右]的顺序分别定义各个方向的目标焦点,-1表示按初始逻辑移动焦点,[3]中3表示下个区域的domIndex,下个区域的index的值由初始定义值;[1,4]中1表示下个区域的index,4表示下个区域的domIndex;
        this.element = $(this.domId);

        //处理文字跑马灯效果参数
        this.domTxtId = domId;
        this.cutTxt = undefined;
        this.normalTxt = undefined;
        this.marquee = "auto";

        this.t_x = "";
        this.t_y = "";

        this.move = function (direction) {
            if (this.moveRule != undefined && _isArray(this.moveRule) && this.moveRule[direction] != -1) {
                return this.moveRule[direction];
            }
            ;
        };

        this.dirEvent = undefined;	//方向键事件
        this._dir = function (direction) {
            if (this.dirEvent != undefined) {
                return this.dirEvent(direction);
            } else {
                return true;
            }
            ;
        };

        this.okEvent = undefined;	//焦点点击事件
        this.ok = function () {
            if (this.okEvent != undefined) {
                return this.okEvent();
            } else {
                return true;
            }
            ;
        };

        this.backEvent = undefined;	//返回事件
        this._back = function () {
            if (this.backEvent != undefined) {
                return this.backEvent();
            } else {
                return true;
            }
            ;
        };

        this.moveDirectionEvent = undefined;		//方向键事件0，1，2，3   上下左右
        this.moveDirection = function (direction) {
            if (this.moveDirectionEvent != undefined) {
                return this.moveDirectionEvent(direction);
            } else {
                return true;
            }
            ;
        };

        this.numInputEvent = undefined;	//输入数字执行的function
        this.numInput = function (num) {
            if (this.numInputEvent != undefined) {
                return this.numInputEvent(num);
            } else {
                return true;
            }
            ;
        };

        this.focusEvent = undefined;	//当前dom元素获得焦点后执行此事件
        this._focus = function () {
            if (this.focusEvent != undefined) {
                return this.focusEvent();
            } else {
                return true;
            }
            ;
        };

        this.changeStyle = function (focusFlag, _objFocus) {
            if (focusFlag) {
                if (_objFocus != undefined) {
                    this.slithier(_objFocus);
                }
                ;
                if (this.focusClassName != "" && this.focusClassName != undefined) {
                    // this.element.className = this.focusClassName;
                    setClassName(this.element, this.focusClassName);
                }
                ;
                if (this.normalTxt != undefined && this.normalTxt != this.cutTxt) {
                    $(this.domTxtId).innerHTML = "<marquee width='" + this.marquee + "'>" + this.normalTxt + "</marquee>";
                }
                ;
            } else {
                if (this.blurClassName != "" && this.blurClassName != undefined) {
                    // this.element.className = this.blurClassName;
                    setClassName(this.element, this.blurClassName);
                }
                ;
                if (this.cutTxt != undefined) {
                    $(this.domTxtId).innerHTML = this.cutTxt;
                }
                ;
            }
            ;
        };

        //滑动效果
        this.slithier = function (_objFocus) {
            var _domStyle;
            if (_isArray(_objFocus[0])) {
                _domStyle = $(_objFocus[0][1]).style;
            } else {
                _domStyle = this.element.style;
            }
            ;
            //x轴参数
            var step_x = _objFocus[1] == undefined ? 1 : (_objFocus[1][0] == undefined ? 1 : _objFocus[1][0]);
            var targetLeft = parseInt(_domStyle.left == "" ? "0" : _domStyle.left) + (_objFocus[1][1] == undefined ? 0 : _objFocus[1][1]);
            var curLeft = parseInt($(_objFocus[0]).style.left);
            //y轴参数
            var step_y = _objFocus[2] == undefined ? 1 : (_objFocus[2][0] == undefined ? 1 : _objFocus[2][0]);
            var targetTop = parseInt(_domStyle.top == "" ? "0" : _domStyle.top) + (_objFocus[2][1] == undefined ? 0 : _objFocus[2][1]);
            var curTop = parseInt($(_objFocus[0]).style.top);

            var time_x = undefined;
            var time_y = undefined;
            if (targetLeft != curLeft) {
                time_x = Math.round(_objFocus[3] / (Math.abs(targetLeft - curLeft) / step_x));
                slithierMove_x();
            }
            ;
            if (targetTop != curTop) {
                time_y = Math.round(_objFocus[3] / (Math.abs(targetTop - curTop) / step_y));
                slithierMove_y();
            }
            ;

            function slithierMove_x() {
                if (step_x == 0 && _objFocus[3] != 0) return;
                var leftDir = targetLeft > curLeft ? 1 : -1;
                curLeft += leftDir * step_x;
                if ((curLeft >= targetLeft && leftDir == 1) || (curLeft <= targetLeft && leftDir == -1) || _objFocus[3] == 0) {
                    curLeft = targetLeft;
                } else {
                    clearTimeout(this.t_x);
                    this.t_x = setTimeout(slithierMove_x, time_x);
                }
                ;
                $(_objFocus[0]).style.left = curLeft + "px";
            };
            function slithierMove_y() {
                if (step_y == 0 && _objFocus[3] != 0) return;
                var topDir = targetTop > curTop ? 1 : -1;
                curTop += topDir * step_y;
                if ((curTop >= targetTop && topDir == 1) || (curTop <= targetTop && topDir == -1) || _objFocus[3] == 0) {
                    curTop = targetTop;
                } else {
                    clearTimeout(this.t_y);
                    this.t_y = setTimeout(slithierMove_y, time_y);
                }
                ;
                $(_objFocus[0]).style.top = curTop + "px";
            };
        };
    };

    function loadElements(row, colum, domId, focusClassName, blurClassName, areaDirections, curDomIndex, turnDirection) {
        var tmpDoms = new Array();
        for (var i = 0; i < row * colum; i++) {
            var tmpDom = new focus_logic.dom(domId + i, focusClassName, blurClassName);
            tmpDom.curIndex = i;
            tmpDoms.push(tmpDom);
        }
        ;
        var tmpArea = new focus_logic.area(row, colum, tmpDoms, areaDirections, curDomIndex, turnDirection);
        tmpArea.curIndex = focus_logic.page.areas.length;
        focus_logic.page.areas.push(tmpArea);
        return tmpArea;
    };
    document.onkeydown = keyDown;
    //有盒子不支持onkeydown 768虚拟事件的可使用document.onkeypress代替
    /*	document.onkeypress = keyPress;
     function keyPress(event){
     var key_code = event.which || event.keyCode;
     };*/

    function keyDown(event) {
        if (event == undefined) {
            event = window.event;
        }
        ;
        var key_code = event.which || event.keyCode;
        switch (key_code) {
            case 48:
                focus_logic.page.numInput(0);
                break;
            case 49:
                focus_logic.page.numInput(1);
                break;
            case 50:
                focus_logic.page.numInput(2);
                break;
            case 51:
                focus_logic.page.numInput(3);
                break;
            case 52:
                focus_logic.page.numInput(4);
                break;
            case 53:
                focus_logic.page.numInput(5);
                break;
            case 54:
                focus_logic.page.numInput(6);
                break;
            case 55:
                focus_logic.page.numInput(7);
                break;
            case 56:
                focus_logic.page.numInput(8);
                break;
            case 57:
                focus_logic.page.numInput(9);
                break;
            case 87: //w
            case 38://KEY_UP
                focus_logic.page.move(0);
                break;
            case 65: //a
            case 37: //KEY_LEFT
                focus_logic.page.move(1);
                break;
            case 83: //s
            case 40://KEY_DOWN
                focus_logic.page.move(2);
                break;
            case 68: //d
            case 39: //KEY_RIGHT
                focus_logic.page.move(3);
                break;
            case 13://KEY_OK,enter
                focus_logic.page.ok();
                break;
            case 32:    // 空格
            case 8://KEY_BACK
            case 280://中兴
                focus_logic.page._back();
                break;
            case 188:
            case 33://KEY_PAGEUP
                focus_logic.page.pageTurn(-1);
                break;
            case 190:
            case 34://KEY_PAGEDOWN
                focus_logic.page.pageTurn(1);
                break;
            case 275://KEY_RED
                doRedirectKey("red");
                break;
            case 276://KEY_GREEN
                doRedirectKey("green");
                break;
            case 277://KEY_YELLOW
                doRedirectKey("yellow");
                break;
            case 278://KEY_BLUE
                doRedirectKey("blue");
                break;
            case 113: //F2
            case 292://KEY_HOME
            case 290://KEY_MENU
            case 272://UT STB KEY_MENU
                //doRedirectKey("menu");
				_window.top.mainWin.document.location = "portal.jsp";
                break;
			case 36://zte
				_window.top.mainWin.document.location = "portal.jsp";
				break;
            case 768:
                try {
                    if (window.goUtility != undefined) {
                        window.goUtility();
                    }
                    ;
                } catch (e) {
                }
                ;
                break;
            default:
                try {
                    if (window.keyEvent != undefined) {
                        window.keyEvent(key_code);
                    }
                    ;
                } catch (e) {
                }
                ;
                break;
        }
        ;
        return 0;
    };

    function setClassName(elem, setValue) {
        try {
            elem.setAttribute("class", setValue);
        } catch (e) {
            var att = document.createAttribute("class");
            att.value = setValue;
            elem.setAttributeNode(att);
        }

    };
    /**
     * @description 四色键和首页键,需要用到时在页面重新定义focus_logic.doRedirectKey即可
     */
    function doRedirectKey(key) {
        if (pageFlow != undefined) {
            _pageData.position = null;
            pageFlow.clear();
        }
        switch (key) {
            case "menu":
                break;
            case "red":
                break;
            case "green":
                break;
            case "yellow":
                break;
        }
    };

    /**
     * @description 以id获取dom元素
     */
    function $(id) {
        return document.getElementById(id);
    };

    
    function _isArray(o) {
        return Object.prototype.toString.call(o) === '[object Array]';
    }

    var _in_ajax = window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();

    function getDataByAjax(url, successMethed, param) {
        if (url != undefined && url != null && url != "") {
            var temp = url.split("?");
            url = temp[0];
            if (temp.length > 1) {
                url += "?" + encodeURI(temp[1]);
            }
            ;
        }
        ;
        _in_ajax.open("POST", url, false);
        _in_ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
        //_in_ajax.setRequestHeader("Cookie", document.cookie);	//针对某些老盒子ajax请求返回302的问题(导致获取不到数据)可以将此行注释打开,最好使用Authentication.CTCGetConfig("STBType")方法判断一下盒子型号再打开注释
        _in_ajax.setRequestHeader("X-Requested-With", "XMLHttpRequest");
        _in_ajax.send(null);

        if (_in_ajax.readyState == 4) {
            if (_in_ajax.status == 200) {
                if (successMethed != undefined) {
                    successMethed(_in_ajax.responseText, param);
                }
                ;
            }
            ;
        }
        ;
    };

    window["$"] = $;
    window.focus_logic["getDataByAjax"] = getDataByAjax;
    window.focus_logic["doRedirectKey"] = doRedirectKey;
    window.focus_logic["dom"] = Dom;
    window.focus_logic["area"] = Area;
    window.keyDown = keyDown;
    window.focus_logic["loadElements"] = loadElements;
    window.setClassName = setClassName;	
    window.focus_logic["page"] = new Page();

})();
