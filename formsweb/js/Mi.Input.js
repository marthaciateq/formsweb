﻿Mi.Input.checkbox = function (params) {
	var e = $('<input/>');
	e.MiInputCheckbox(params);
	return e;
}
Mi.Input.combo = function (params) {
    var multiple=""
    if ($.isPlainObject(params)) {
        if (params.multiple == "true") multiple='multiple="true"'
    }
   var e = $('<select '+multiple+'/>');
    e.MiInputCombo(params);
    return e;
}
Mi.Input.comboMiFill = function (e, data, params) {
    var option, keyValue = 0, keyText = 1;
    if ($.isPlainObject(params)) {
        if (params.value || params.value == 0) keyValue = params.value;
        if (params.text || params.text == 0) keyText = params.text;
    }
    for (var i = 0; i < data.length; i++) {
        if ($.type(data[i]) == 'string' || $.isNumeric(data[i])) {
            option = $('<option value=' + data[i] + ' />'); e.append(option);
            option.text(data[i]);
        } else if ($.isPlainObject(data[i]) || $.isArray(data[i])) {
            option = $('<option value=' + data[i][keyValue] + ' />'); e.append(option);
            option.text(data[i][keyText]);
        }
    }
}
Mi.Input.number = function (params) {
    var e = $('<input/>');
    e.MiInputNumber(params);
    return e;
}
Mi.Input.numberMiText = function (e) {
    return e.val();
}
Mi.Input.numberMiVal = function (e, value) {
    if ($.type(value) == 'undefined') return Mi.Convert.stringToNumber(e.val())
    else {
        if (!$.isNumeric(parseFloat(value))) e.val('')
        else e.val(Mi.Convert.numberToString(value, e.data('params').decimales, e.data('params').separador))
    }
}
Mi.Input.plugin = function ($) {
	$.fn.MiInputCheckbox = function (params) {
		if (!$.isPlainObject(params)) params = {};
		if (params.classNameOnlyOneSelect) params.classNameOnlyOneSelect = params.classNameOnlyOneSelect.toString();
		else params.classNameOnlyOneSelect = null;
		this.each(function () {
			if ($(this).prop('nodeName') == 'INPUT') {
			    $(this).addClass('MiInputCheckbox');
			    $(this).addClass('checkbox');
				$(this).prop('type', 'checkbox');
				if (params.classNameOnlyOneSelect) {
					$(this).addClass(params.classNameOnlyOneSelect);
					$(this).click(function () {
						var e = $(this), dobleClick = false, timeout = 400;
						if (!e.data('MiInputCheckbox.lastClickObject')) e.data('MiInputCheckbox.lastClickObject', { time: 0, handler: 0 });
						if ((new Date()).getTime() - e.data('MiInputCheckbox.lastClickObject').time < timeout) dobleClick = true;
						if (e.data('MiInputCheckbox.lastClickObject').handler) {
							clearTimeout(e.data('MiInputCheckbox.lastClickObject').handler);
							e.data('MiInputCheckbox.lastClickObject').handler = 0;
						}
						if (dobleClick) e.prop('checked', true);
						else if (e.prop('checked')) e.data('MiInputCheckbox.lastClickObject').handler = setTimeout(function () {
							$(document.body).find('.' + params.classNameOnlyOneSelect).each(function () {
								if (!e.is($(this))) $(this).prop('checked', false);
							});
						}, timeout);
						e.data('MiInputCheckbox.lastClickObject').time = (new Date()).getTime();
					});
				}
			}
		});
	}
	$.fn.MiInputCombo = function (params) {
	    if (!$.isPlainObject(params)) params = {};
	    this.each(function () {
	        if ($(this).prop('nodeName') == 'SELECT') {
	            $(this).addClass('form-control');
	            $(this).addClass('chzn-select');
	            $(this).data('MiFill', Mi.Input.comboMiFill);
	            $(this).data('params', params);
	        }
	    });
	}
	$.fn.MiInputNumber = function (params) {
	    if (!$.isPlainObject(params)) params = {};
	    if ($.type(params.mask) != 'string') params.mask = null;
	    if (!$.isNumeric(params.decimales)) params.decimales = null;
	    if (params.separador) params.separador = true;
	    this.each(function () {
	        if ($(this).prop('nodeName') == 'INPUT') {
	            $(this).addClass('MiInputNumber');
	            $(this).data('MiText', Mi.Input.numberMiText);
	            $(this).data('MiVal', Mi.Input.numberMiVal);
	            $(this).data('params', params);
	            if (params.mask != null) $(this).prop('placeholder', params.mask);
	            $(this).change(function () {
	                $(this).val(Mi.Convert.numberToString(Mi.Convert.stringToNumber($(this).val()), params.decimales, params.separador));
	            });
	            if (params.mask != null) $(this).change(function () {
	                if ($(this).val() == '') $(this).css('color', "yellow");
	                else $(this).css('color', "green");
	            });
	        }
	    });
	}
}