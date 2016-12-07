Mi = {
	webHome: '/',
	AJAX: {},
	Convert: {},
	Cookie: {},
	Input: {
	    Combos: {}
	},
	Modal: {},
	JSON: {},
	Menu: {},
	Template: {},
	Util: {}
}
document.writeln('<link rel="shortcut icon" href="' + Mi.webHome + 'img/icon.png" type="image/png" />\
	<script type="text/javascript" src="' + Mi.webHome + 'js/jquery-2.1.4.min.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.AJAX.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Convert.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Cookie.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Modal.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Input.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Input.Combos.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.JSON.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Menu.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Template.js"></script>\
	<script type="text/javascript" src="' + Mi.webHome + 'js/Mi.Util.js"></script>\
    <script src="' + Mi.webHome + 'js/bootstrap.min.js"></script>');

Mi.treeNode = function (params, content) {
    var e = $('<div/>');
    if ($.type(content) == 'string') e.text(content);
    else if (content instanceof $) e.append(content);
    e.MiTreeNode(params);
    return e;
}
Mi.table = function (params) {
    var e = $('<table/>');
    e.MiTable(params);
    return e;
}
Mi.tableMiSelection = function (e, params, selection) {
    if (!$.isPlainObject(params)) params = {};
    if (params.onlyFirst) params.onlyFirst = true;
    else params.onlyFirst = false;
    var i = 0;
    e.children('tbody').children('tr').children('td').children('.MiInputCheckbox').each(function () {
        if ($(this).prop('checked')) {
            if (!params.onlyFirst) selection.push($(this).parent().parent().get(0));
            else if (i == 0) selection.push($(this).parent().parent().get(0));
            else $(this).prop('checked', false);
            i++;
        }
    });
}

Mi.plugin = function ($) {
    $.fn.MiFill = function (data, params) {
        this.each(function () {
            if ($.type($(this).data('MiFill')) == 'function') $(this).data('MiFill')($(this), data, params);
        });
    }
    $.fn.MiSelection = function (params) {
        var selection = $();
        this.each(function () {
            if ($.type($(this).data('MiSelection')) == 'function') $(this).data('MiSelection')($(this), params, selection);
        });
        return selection;
    }
    $.fn.MiTreeNode = function (params, element) {
        if (params == 'expand') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    $(this).data('MiTreeNode_estado', 'expand');
                    $(this).MiTreeNode('refresh');
                }
            });
        } else if (params == 'expandAll') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    $(this).find('.MiTreeNode').MiTreeNode('expand');
                }
            });
        } else if (params == 'collapse') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    $(this).data('MiTreeNode_estado', 'collapse');
                    $(this).MiTreeNode('refresh');
                }
            });
        } else if (params == 'collapseAll') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    $(this).find('.MiTreeNode').MiTreeNode('collapse');
                }
            });
        } else if (params == 'append') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    $(this).children('div').eq(1).append(element);
                    $(this).MiTreeNode('refresh');
                }
            });
        } else if (params == 'remove') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    var nodoPadre = $(this).MiTreeNode('parent');
                    $(this).remove();
                    nodoPadre.MiTreeNode('refresh');
                }
            });
        } else if (params == 'refresh') {
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    if ($(this).children('div').eq(1).children().length == 0) {
                        $(this).children('img').eq(0).hide();
                        $(this).children('img').eq(1).hide();
                        $(this).children('img').eq(2).show();
                        $(this).children('div').eq(1).hide();
                    } else if ($(this).data('MiTreeNode_estado') == 'collapse') {
                        $(this).children('img').eq(0).hide();
                        $(this).children('img').eq(1).show();
                        $(this).children('img').eq(2).hide();
                        $(this).children('div').eq(1).hide();
                    }
                    else {
                        $(this).children('img').eq(0).show();
                        $(this).children('img').eq(1).hide();
                        $(this).children('img').eq(2).hide();
                        $(this).children('div').eq(1).show();

                    }
                }
            });
        } else if (params == 'parent') {
            var result = $(document.body).children('#wertyuidfghjk23456');
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    result = $(this).parent().parent('.MiTreeNode');
                }
            });
            return result;
        } else if (params == 'children') {
            var result = $(document.body).children('#wertyuidfghjk23456');
            this.each(function () {
                if ($(this).hasClass('MiTreeNode')) {
                    result = $(this).children('div').eq(1).children('.MiTreeNode');
                }
            });
            return result;
        } else {
            if (!$.isPlainObject(params)) params = {};
            if ($.type(params.imgSize) != 'string' && $.type(params.imgSize) != 'number') params.imgSize = $(window).height() * 0.03;
            if ($.type(params.imgSize) != 'string' && $.type(params.imgSize) != 'number') params.imgSize = $(window).height() * 0.03;
            if (params.initialStatus != 'collapse') params.initialStatus = 'expand';
            this.each(function () {
                if ($(this).prop('nodeName') == 'DIV') {
                    $(this).addClass('MiTreeNode');
                    var content = $('<div/>'), tmp = [];
                    for (var i = 0; i < this.childNodes.length; i++) tmp.push(this.childNodes[i]);
                    for (var i = 0; i < tmp.length; i++) content.append(tmp[i]);
                    content.css({
                        //display: 'inline-block',
                        'min-width': $(window).width() * 0.15,
                        'vertical-align': 'middle',
                        'text-align': 'left',
                        'padding-left': $(window).height() * 0.01,
                        'padding-right': $(window).height() * 0.01,
                        'padding-top': $(window).height() * 0.005,
                        'padding-bottom': $(window).height() * 0.005,
                        'border-radius': $(window).height() * 0.01,
                        border: 'solid 1px #226179' 
                    });
                    $(this).append($('<img src="' + Mi.webHome + 'imgs/collapse.png"/>\
							<img src="' + Mi.webHome + 'imgs/expand.png"/>\
							<img src="' + Mi.webHome + 'imgs/transparent.png"/>\
							<div/>\
							<div/>'));
                    var imgCollapse = $(this).children('img').eq(0);
                    var imgExpand = $(this).children('img').eq(1);
                    var imgNothing = $(this).children('img').eq(2);
                    var div1 = $(this).children('div').eq(0);
                    div1.append(content);
                    var div2 = $(this).children('div').eq(1);
                    $(this).css({
                        'text-align': 'left',
                        'padding-top': $(window).height() * 0.01
                    });
                    $(this).children('img').css({
                        'vertical-align': 'middle',
                        width: $(window).height() * 0.025,
                        height: $(window).height() * 0.025
                    });
                    imgCollapse.css({
                        cursor: 'pointer'
                    });
                    imgCollapse.click(function () { $(this).parent().MiTreeNode('collapse'); });
                    imgExpand.css({
                        cursor: 'pointer'
                    });
                    imgExpand.click(function () { $(this).parent().MiTreeNode('expand'); });
                    div1.css({
                        display: 'inline-block',
                        'padding-left': $(window).width() * 0,
                        'vertical-align': 'middle'
                    });
                    div2.css({
                        'padding-left': $(window).width() * 0.02
                    });
                    $(this).MiTreeNode(params.initialStatus);
                }
            });
        }
    }
    $.fn.MiTable = function (params) {
        function fill(section, data, cols) {
            var tr, td
            for (var row in data) {
                tr = $('<tr/>')
                tr.appendTo(section)
                tr.data('row', data[row]);
                if (!cols) for (var col in data[row]) {
                    td = $('<td/>')
                    if (data[row][col] instanceof $) {
                        if (data[row][col].length == 1) {
                            if (data[row][col].eq(0).prop('nodeName') == 'TD') td = data[row][col];
                            else data[row][col].appendTo(td);
                        } else data[row][col].appendTo(td);
                    }
                    else if (data[row][col] == null);
                    else $(document.createTextNode(data[row][col])).appendTo(td)
                    td.appendTo(tr)
                } else for (var col in cols) {
                    td = $('<td></td>')
                    if (data[row][cols[col]] instanceof $) {
                        if (data[row][cols[col]].length == 1) {
                            if (data[row][cols[col]].eq(0).prop('nodeName') == 'TD') td = data[row][cols[col]];
                            else data[row][cols[col]].appendTo(td);
                        } else data[row][cols[col]].appendTo(td);
                    }
                    else if (data[row][cols[col]] == null);
                    else $(document.createTextNode(data[row][cols[col]])).appendTo(td)
                    td.appendTo(tr)
                }
            }
        }
        if (!$.isPlainObject(params)) params = {};
        if (!$.isPlainObject(params.head)) params.head = {};
        if (!$.isArray(params.head.data)) params.head.data = null;
        if (!$.isArray(params.head.cols)) params.head.cols = null;
        if (!$.isPlainObject(params.body)) params.body = {};
        if (!$.isArray(params.body.data)) params.body.data = null;
        if (!$.isArray(params.body.cols)) params.body.cols = null;
        if (!$.isPlainObject(params.foot)) params.foot = {};
        if (!$.isArray(params.foot.data)) params.foot.data = null;
        if (!$.isArray(params.foot.cols)) params.foot.cols = null;
        if ($.type(params.addCheckbox) != 'boolean') params.addCheckbox = false;
        if ($.type(params.noClassNameOnlyOneSelect) != 'boolean') params.noClassNameOnlyOneSelect = false;
        if (params.addCheckbox) {
            var tmp = [], row, colName, classNameOnlyOneSelect, checkbox;
            if (!params.noClassNameOnlyOneSelect) classNameOnlyOneSelect = 'MiTable_classNameOnlyOneSelect' + (new Date()).getMilliseconds();
            for (var i = 0; i < params.body.data.length; i++) {
                if ($.isArray(params.body.data[i])) {
                    colName = 0;
                    row = [Mi.Input.checkbox({ classNameOnlyOneSelect: classNameOnlyOneSelect })]; tmp.push(row);
                    for (var j = 0; j < params.body.data[i].length; j++)
                        row.push(params.body.data[i][j]);
                } else if ($.isPlainObject(params.body.data[i])) {
                    colName = 'MiTableCheckbox';
                    row = { MiTableCheckbox: Mi.Input.checkbox({ classNameOnlyOneSelect: classNameOnlyOneSelect }) }; tmp.push(row);
                    for (var j = 0 in params.body.data[i])
                        row[j] = params.body.data[i][j];
                }
            }
            params.body.data = tmp;
            if ($.isArray(params.body.cols)) {
                tmp = [];
                tmp.push(colName);
                for (var i = 0; i < params.body.cols.length; i++)
                    tmp.push(params.body.cols[i]);
                params.body.cols = tmp;
            }
            tmp = [];
            for (var i = 0; i < params.head.data.length; i++) {
                if (i == params.head.data.length - 1) {
                    checkbox = Mi.Input.checkbox();
                    checkbox.click(function () {
                        $(this).parent().parent().parent().parent().children('tbody').children('tr').children('td').children('.' + classNameOnlyOneSelect).prop('checked', $(this).prop('checked'));
                    });
                    if ($.isArray(params.head.data[i])) {
                        colName = 0;
                        row = [checkbox]; tmp.push(row);
                        for (var j = 0; j < params.head.data[i].length; j++)
                            row.push(params.head.data[i][j]);
                    } else if ($.isPlainObject(params.head.data[i])) {
                        colName = 'MiTableCheckbox';
                        row = { MiTableCheckbox: checkbox }; tmp.push(row);
                        for (var j = 0 in params.head.data[i])
                            row[j] = params.head.data[i][j];
                    }
                } else tmp.push(params.head.data[i]);
            }
            params.head.data = tmp;
            if ($.isArray(params.head.cols)) {
                tmp = [];
                tmp.push(colName);
                for (var i = 0; i < params.head.cols.length; i++)
                    tmp.push(params.head.cols[i]);
                params.head.cols = tmp;
            }
        }
        this.each(function () {
            if ($(this).prop('nodeName') == 'TABLE') {
                $(this).addClass('table table-striped');
                $(this).data('MiSelection', Mi.tableMiSelection);
                $(this).children().remove();
                $(this).append('<thead/><tbody/><tfoot/>');
                fill($(this).children().eq(0), params.head.data, params.head.cols);
                fill($(this).children().eq(1), params.body.data, params.body.cols);
                fill($(this).children().eq(2), params.foot.data, params.foot.cols);
               
            }
        });
    }
    $.fn.MiVal = function (value) {
        var returnValue = [];
        this.each(function () {
            if ($.type($(this).data('MiVal')) == 'function')
                if ($.type(value) == 'undefined') {
                    returnValue.push($(this).data('MiVal')($(this), value));
                } else {
                    $(this).data('MiVal')($(this), value)
                }
        })
        if (returnValue.length == 0) return null
        else if (returnValue.length == 1) return returnValue[0]
        else return returnValue;
    }
}

Mi.MiTextVal = function (e, value) {
    if ($.type(value) == 'undefined') {
        if (e.val().trim() == '') return null
        else return e.val().trim()
    } else {
        if (value == null) e.val('')
        else e.val(value)
    }
}

Mi.MiNumberMiVal = function (e, value) {
    if ($.type(value) == 'undefined') return Mi.Convert.stringToNumber(e.val())
    else {
        if (!$.isNumeric(parseFloat(value))) e.val('')
        else e.val(Mi.Convert.numberToString(value, e.data('params').decimales, e.data('params').separador))
    }
}