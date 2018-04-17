/*
 * do_block_enable()
 *	Enables or disables all <input> elements within the given block element
 *
 * EXAMPLE
 * <fieldset id="blah_settings"><input.../><input..../></fieldset>
 * do_block_enable(mf.blah_settings, false);
 * The above call would set disable to true on all input elements contained within the given fieldset.
 */
function do_block_enable(block, enable)
{
	for (var c = 0; c < block.childNodes.length; ++c) {
		var child_element = block.childNodes[c];

		/*
		 * If the current element has children too, then we recurse into it
		 */
		if (child_element.hasChildNodes()) {
			do_block_enable(child_element, enable);
		}

		/*
		 * We only process input elements
		 */
		var tag_name = new String(child_element.tagName);
		if (tag_name.toUpperCase() != "INPUT") {
			continue;
		}
		child_element.disabled = !enable;
	}
}

/*
 * set_radio
 *	Sets the radio button whose value matches that give (unchecking all others in the group)
 * NOTE: Radio group 
 */
function set_radio(radio_group, value)
{
	/*
	 * Convert value to a string so that it will match properly on the radio.value property
	 */
	value = "" + value;

	/*
	 * Iterate through the radio groups radio buttons, activating the one with the matching value
	 */
	for (var i = 0; i < radio_group.length; i++) {
		if (radio_group[i].value == value) {
			radio_group[i].checked = true;
			return;
		}
	}
}

/*
 * is_number
 *	Return true if a value represents a number, else return false.
 */
function is_number(value)
{
	var str = value + "";
	return str.match(/^-?\d*\.?\d+$/) ? true : false;
}


/*
 * is_blank
 *	Return true if value is a blank (i.e. "").
 */
function is_blank(value)
{
	var str = value + "";
	return str.match(/^\s*$/) ? true : false;
}


/*
 * trim_string
 *	Remove leading and trailing blank spaces from a string.
 */
function trim_string(str)
{
	var trim = str + "";
	trim = trim.replace(/^\s*/, "");
	return trim.replace(/\s*$/, "");
}


/*
 * integer_to_bytearray
 *	Convert an integer value to a byte array of size 'length'.
 */
function integer_to_bytearray(value, length)
{
	var barray = [];
	for (var i = 0; i < length; i++) {
		barray[i] = (value >>> ((length - 1 - i) * 8)) & 0xFF;
	}
	return barray;
}


/*
 * bytearray_to_integer
 *	Convert a byte array to an integer (optional start and end indexes).
 */
function bytearray_to_integer(barray, start, end)
{
	if (typeof(start) == 'undefined') {
		start = 0;
	}
	if (typeof(end) == 'undefined') {
		end = barray.length;
	}
	var num = 0;
	for (var i = start; i < end; i++) {
		num = (num << 8) + barray[i];
	}
	return num;
}


/*
 * ipv4_to_integer
 *	Convert an IPv4 address dotted string to an integer.
 */
function ipv4_to_integer(ipaddr)
{
	var ip = ipaddr + "";
	var got = ip.match (/^\s*(\d+)\s*[.]\s*(\d+)\s*[.]\s*(\d+)\s*[.]\s*(\d+)\s*$/);
	if (!got) {
		return null;
	}
	var x = 0;
	var q = 0;
	for (var i = 1; i <= 4; i++) {
		q = parseInt(got[i], 10);
		if (q < 0 || q > 255) {
			return null;
		}
		x = x | (q << ((4 - i) * 8));
	}
	return x;
}


/*
 * integer_to_ipv4
 *	Convert an integer (signed or not) to an IPv4 address dotted string.
 */
function integer_to_ipv4(num)
{
	var ip = "";
	var q = 0;
	var n = 0;
	for (var i = 3; i >= 0; i--) {
		n = i * 8;
		q = (num & (0xFF << n)) >> n;
		if (q < 0) {
			q = q & 0xFF;
		}
		ip += q.toString(10);
		if (i > 0) {
			ip += ".";
		}
	}
	return ip;
}


/*
 * ipv4_to_unsigned_integer
 *	Convert an IPv4 address dotted string to an unsigned integer.
 */
function ipv4_to_unsigned_integer(ipaddr)
{
	var ip = ipaddr + "";
	var got = ip.match (/^\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*$/);
	if (!got) {
		return null;
	}
	var x = 0;
	var q = 0;
	for (var i = 1; i <= 4; i++) {
		q = parseInt(got[i], 10);
		if (q < 0 || q > 255) {
			return null;
		}
		x = x * 256 + q;
	}
	return x;
}


/*
 * ipv4_to_bytearray
 *	Convert an IPv4 address dotted string to a byte array
 */
function ipv4_to_bytearray(ipaddr)
{
	var ip = ipaddr + "";
	var got = ip.match (/^\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*[.]\s*(\d{1,3})\s*$/);
	if (!got) {
		return 0;
	}
	var a = [];
	var q = 0;
	for (var i = 1; i <= 4; i++) {
		q = parseInt(got[i],10);
		if (q < 0 || q > 255) {
			return 0;
		}
		a[i-1] = q;
	}
	return a;
}


/*
 * bytearray_to_ipv4()
 *	Convert a byte array to an IP address dotted string (optional start index).
 */
function bytearray_to_ipv4(array, start)
{
	if (typeof(start) == 'undefined') {
		start = 0;
	}
	if (array.length < 4) {
		return null;
	}
	var ip = "";
	var q = 0;
	for (var i = 0; i < 4; i++) {
		q = array[i + start];
		if (q < 0 || q > 255) {
			return null;
		}
		ip += q.toString(10);
		if (i < 3) {
			ip += ".";
		}
	}
	return ip;
}


/*
 * is_ipv4_valid
 *	Check is an IP address dotted string is valid.
 */
function is_ipv4_valid(ipaddr)
{
	var ip = ipv4_to_bytearray(ipaddr);
	if (ip === 0) {
		return false;
	}
	return true;
}


/*
 * is_port_valid
 *	Check if a port is valid.
 */
function is_port_valid(port)
{
	return (is_number(port) && port >= 0 && port < 65536);
}

/*
 * is_mac_valid()
 *	Check if a MAC address is in a valid form.
 *	Allow 00:00:00:00:00:00 and FF:FF:FF:FF:FF:FF if optional argument is_full_range is true.
 */
function is_mac_valid(mac, is_full_range)
{
	var macstr = mac + "";
	var got = macstr.match(/^[0-9a-fA-F]{2}[:-]?[0-9a-fA-F]{2}[:-]?[0-9a-fA-F]{2}[:-]?[0-9a-fA-F]{2}[:-]?[0-9a-fA-F]{2}[:-]?[0-9a-fA-F]{2}$/);
	if (!got) {
		return false;
	}
	macstr = macstr.replace (/[:-]/g, '');
	if (!is_full_range && (macstr.match(/^0{12}$/) || macstr.match(/^[fF]{12}$/))) {
		return false;
	}

	return true;
}

/*
 * is_mac_null()
 *	Check if a MAC address is 00:00:00:00:00:00 or null.
 */
function is_mac_null(mac)
{
	if (is_blank(mac)) {
		return true;
	}
	if(!is_mac_valid(mac, true)) {
		return false;
	}
	var macstr = mac.replace(/[:-]/g, '');
	return macstr.match(/^[0]{12}$/) ? true : false;
}

/*
 * is_mac_broadcast()
 *	Check if a MAC address is FF:FF:FF:FF:FF:FF.
 */
function is_mac_broadcast(mac)
{
	if(!is_mac_valid(mac, true)) {
		return false;
	}
	var macstr = mac.replace(/[:-]/g, '');
	return macstr.match(/^[fF]{12}$/) ? true : false;
}

/*
 * is_mac_multicast()
 *	Check if a MAC address is a multicast.
 */
function is_mac_multicast(mac)
{
	if(!is_mac_valid(mac)) {
		return false;
	}
	var macstr = mac.replace (/[:-]/g, '');
	var octet = new Number("0x" + mac.substring(0,2));
	return (octet & 1) ? true : false;
}

/*
 * are_values_equal()
 *	Compare values of types boolean, string and number. The types may be different.
 *	Returns true if values are equal.
 */
function are_values_equal(val1, val2)
{
	/* Make sure we can handle these values. */
	switch (typeof(val1)) {
	case 'boolean':
	case 'string':
	case 'number':
		break;
	default:
		// alert("are_values_equal does not handle the type '" + typeof(val1) + "' of val1 '" + val1 + "'.");
		return false;
	}

	switch (typeof(val2)) {
	case 'boolean':
		switch (typeof(val1)) {
		case 'boolean':
			return (val1 == val2);
		case 'string':
			if (val2) {
				return (val1 == "1" || val1.toLowerCase() == "true" || val1.toLowerCase() == "on");
			} else {
				return (val1 == "0" || val1.toLowerCase() == "false" || val1.toLowerCase() == "off");
			}
			break;
		case 'number':
			return (val1 == val2 * 1);
		}
		break;
	case 'string':
		switch (typeof(val1)) {
		case 'boolean':
			if (val1) {
				return (val2 == "1" || val2.toLowerCase() == "true" || val2.toLowerCase() == "on");
			} else {
				return (val2 == "0" || val2.toLowerCase() == "false" || val2.toLowerCase() == "off");
			}
			break;
		case 'string':
			if (val2 == "1" || val2.toLowerCase() == "true" || val2.toLowerCase() == "on") {
				return (val1 == "1" || val1.toLowerCase() == "true" || val1.toLowerCase() == "on");
			}
			if (val2 == "0" || val2.toLowerCase() == "false" || val2.toLowerCase() == "off") {
				return (val1 == "0" || val1.toLowerCase() == "false" || val1.toLowerCase() == "off");
			}
			return (val2 == val1);
		case 'number':
			if (val2 == "1" || val2.toLowerCase() == "true" || val2.toLowerCase() == "on") {
				return (val1 == 1);
			}
			if (val2 == "0" || val2.toLowerCase() == "false" || val2.toLowerCase() == "off") {
				return (val1 === 0);
			}
			return (val2 == val1 + "");
		}
		break;
	case 'number':
		switch (typeof(val1)) {
		case 'boolean':
			return (val1 * 1 == val2);
		case 'string':
			if (val1 == "1" || val1.toLowerCase() == "true" || val1.toLowerCase() == "on") {
				return (val2 == 1);
			}
			if (val1 == "0" || val1.toLowerCase() == "false" || val1.toLowerCase() == "off") {
				return (val2 === 0);
			}
			return (val1 == val2 + "");
		case 'number':
			return (val2 == val1);
		}
		break;
	default:
		return false;
	}
}


/*
 * do_expanse_collapse
 *	Expanse (unhide) or collapse (hide) a block in the page when e.g. clicking on an element,
 *	and change the value of this element (or any other).
 *	elt_id: id of the element that will have its value changed
 *	alt_val: new value for eltid
 *	toggle_id: id of the element that will be hidden or unhidden.
 *
 *	Example of usage:
 *	<input type="button" id="testbt" value="Expand" onclick="do_expanse_collapse(this.id, 'Collapse', 'hidethediv');" />
 *	<div id="hidethediv"> ... </div>
 */
function do_expanse_collapse(elt_id, alt_val, toggle_id)
{
	/* Show or hide the element. */
	var elt = document.getElementById(toggle_id);
	if (!elt) {
		return;
	}
	if (elt.style.display != 'none') {
		elt.style.display = 'none';
	} else {
		elt.style.display = '';
	}

	if (alt_val === "") {
		return;
	}

	elt = document.getElementById(elt_id);
	if (!elt) {
		return;
	}

	/* If this element doesn't have this attribute, create it. */
	if (!elt.getAttribute('alt_value')) {
		var node = document.createAttribute('alt_value');
		node.value = alt_val;
		/* For Safari. */
		if (node.value != alt_val) {
			node.nodeValue = alt_val;
		}
		elt.setAttributeNode(node);
	}

	/* Swap the element's value and alt_value. */
	var attr = elt.getAttribute('alt_value');
	elt.setAttribute('alt_value', elt.value);
	elt.value = attr;
}


/*
 * add_onload_listener
 *	Add a listener function to the window.onload event.
 */
function add_onload_listener(func)
{
	if (typeof(window.addEventListener) != 'undefined') {
		// DOM level 2
		window.addEventListener('load', func, false);
	} else if (typeof(window.attachEvent) != 'undefined') {
		// IE
		window.attachEvent('onload', func);
	} else {
		if (typeof(window.onload) != 'function') {
			window.onload = func;
		} else {
			var oldfunc = window.onload;
			window.onload = function() {
				oldfunc();
				func();
			};
		}
	}
}

/*
 * add_onunload_listener
 *	Add a listener function to the window.onunload event.
 */
function add_onunload_listener(func)
{
	if (typeof(window.addEventListener) != 'undefined') {
		window.addEventListener('unload', func, false);
	} else if (typeof(window.attachEvent) != 'undefined') {
		window.attachEvent('onunload', func);
	} else {
		if (typeof(window.onunload) != 'function') {
			window.onload = func;
		} else {
			var oldfunc = window.onunload;
			window.onunload = function() {
				oldfunc();
				func();
			};
		}
	}
}

/*
 * set_form_always_modified
 *	 Always set the custom attribute "modified" to "true. 
 */
function set_form_always_modified(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return;
	}
	df.setAttribute('modified', "true");
}

/*
 * set_form_default_values
 *	Save a form's current values to a custom attribute.
 */
function set_form_default_values(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return;
	}
	for (var i = 0, k = df.elements.length; i < k; i++) {
		var obj = df.elements[i];
		if (obj.getAttribute('modified') == 'ignore') {
			continue;
		}
		var name = obj.tagName.toLowerCase();
		if (name == 'input') {
			var type = obj.type.toLowerCase();
			if ((type == 'text') || (type == 'textarea') || (type == 'password') || (type == 'hidden')) {
				obj.setAttribute('default', obj.value);
				/* Workaround for FF error when calling focus() from an input text element. */
				if (type == 'text') {
					obj.setAttribute('autocomplete', 'off');
				}
			} else if ((type == 'checkbox') || (type == 'radio')) {
				obj.setAttribute('default', obj.checked);
			}
		} else if (name == 'select') {
			var opt = obj.options;
			for (var j = 0; j < opt.length; j++) {
				opt[j].setAttribute('default', opt[j].selected);
			}
		}
	}
	df.setAttribute('saved', "true");
}


/*
 * is_form_modified
 *	Check if a form's current values differ from saved values in custom attribute.
 *	Function skips elements with attribute: 'modified'= 'ignore'. 
 */
function is_form_modified(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return false;
	}
	if (df.getAttribute('modified') == "true") {
		return true;
	}
	if (df.getAttribute('saved') != "true") {
		return false;
	}

	for (var i = 0, k = df.elements.length; i < k; i++) {
		var obj = df.elements[i];
		if (obj.getAttribute('modified') == 'ignore') {
			continue;
		}
		var name = obj.tagName.toLowerCase();
		if (name == 'input') {
			var type = obj.type.toLowerCase();
			if (((type == 'text') || (type == 'textarea') || (type == 'password') || (type == 'hidden')) &&
					!are_values_equal(obj.getAttribute('default'), obj.value)) {
				return true;
			} else if (((type == 'checkbox') || (type == 'radio')) && !are_values_equal(obj.getAttribute('default'), obj.checked)) {
				return true;
			}
		} else if (name == 'select') {
			var opt = obj.options;
			for (var j = 0; j < opt.length; j++) {
				if (!are_values_equal(opt[j].getAttribute('default'), opt[j].selected)) {
					return true;
				}
			}
		}
	}
	return false;
}


/*
 * reset_form()
 *	Reset a form with previously saved default values.
 *	Function skips elements with attribute: 'modified'= 'ignore'. 
 */
function reset_form(form_id)
{
	var df = document.forms[form_id];
	if (!df) {
		return;
	}
	if (df.getAttribute('saved') != "true") {
		return;
	}

	for (var i = 0, k = df.elements.length; i < k; i++) {
		var obj = df.elements[i];
		if (obj.getAttribute('modified') == 'ignore') {
			continue;
		}
		var name = obj.tagName.toLowerCase();
		var value;
		if (name == 'input') {
			var type = obj.type.toLowerCase();
			if ((type == 'text') || (type == 'textarea') || (type == 'password') || (type == 'hidden')) {
				obj.value = obj.getAttribute('default');
			} else if ((type == 'checkbox') || (type == 'radio')) {
				value = obj.getAttribute('default');
				switch (typeof(value)) {
				case 'boolean':
					obj.checked = value;
					break;
				case 'string':
					if (value == "1" || value.toLowerCase() == "true" || value.toLowerCase() == "on") {
						obj.checked = true;
					}
					if (value == "0" || value.toLowerCase() == "false" || value.toLowerCase() == "off") {
						obj.checked = false;
					}
					break;
				}
			}
		} else if (name == 'select') {
			var opt = obj.options;
			for (var j = 0; j < opt.length; j++) {
				value = obj[j].getAttribute('default');
				switch (typeof(value)) {
				case 'boolean':
					obj[j].selected = value;
					break;
				case 'string':
					if (value == "1" || value.toLowerCase() == "true" || value.toLowerCase() == "on") {
						obj[j].selected = true;
					}
					if (value == "0" || value.toLowerCase() == "false" || value.toLowerCase() == "off") {
						obj[j].selected = false;
					}
					break;
				}
			}
		}
	}
}


/*
 * is_mac_octet_valid
 * 	Check if the MAC address is out of range [00-FF]
 */
function is_mac_octet_valid(mac)
{
	if (mac.value.length == 1) {
		mac.value = "0" + mac.value;
	}

	var d1 = parseInt(mac.value.charAt(0), 16);
	var d2 = parseInt(mac.value.charAt(1), 16);

	if (isNaN(d1) || isNaN(d2)) {
		mac.value = mac.defaultValue;
		return false;
	}
	return true;
}


var warnings_xslt_retriever;
var config_warnings_retriever;

/*
 * warnings_xslt_retriever_ready()
 *	Invoked by the XSL processor when the stylesheet is loaded and ready
 */
function warnings_xslt_retriever_ready(xml_document)
{
	/*
	 * Get the node into which the warnings translation will be shown
	 */
	var warnings_section = document.getElementById("warnings_section");
	if (warnings_section.style.display == "") {
		/*
		 * Already shown, don't show again
		 */
		return;
	}

	var warnings_section_content = document.getElementById("warnings_section_content");

	/*
	 * Translate the warnings document into the warnings area of the screen
	 */
	warnings_xslt_retriever.transform(config_warnings_retriever.getDocument(), window.document, warnings_section_content);

	/*
	 * Make the warnings division visible
	 */
	warnings_section.style.display = "";
}

/*
 * warnings_xslt_retriever_timeout()
 *	Invoked when the XSL stylesheet times out on loading
 */
function warnings_xslt_retriever_timeout(xml_document)
{
	/*
	 * Keep trying, but less often
	 */
//  GGG - This alert wont render because the extension is .js	alert("<!--# tr tag='YM188' -->Warnings have been raised as a result of configuration changes.\nThe system is unable to generate a list of those warnings right now, but will retry.<!--# endtr -->");
	window.setTimeout("warnings_xslt_retriever.retrieveData()", 20000);
}

/*
 * config_warnings_retriever_ready()
 *	Invoked when the XML data retriever has loaded the warnings document
 */
function config_warnings_retriever_ready(xml_document)
{
	/*
	 * Check if any warnings.
	 */
	if (xml_document.getElementData("warn") === null) {
		return;
	}

	/*
	 * Start an XSL translation that will generate a displayable view of warnings.
	 * NOTE: This XSL processing object is global so can be used in the callbacks.
	 */
	warnings_xslt_retriever = new xsltProcessingObject(warnings_xslt_retriever_ready, warnings_xslt_retriever_timeout, 6000, "/warning.sxsl");
	warnings_xslt_retriever.retrieveData();
}

/*
 * watcher_warnings_check()
 *	Render any warnings to the user.
 */
function watcher_warnings_check(warnings_str)
{
	config_warnings_retriever = new xmlDataObject(null, null, 0, null);
	config_warnings_retriever.initialiseFromString(warnings_str);
	config_warnings_retriever_ready(config_warnings_retriever);
}

/*
 * copy_select_options(from_select, to_select )
 *	copy options from the given select element. Do not copy the first option which is the descriptive 
 *      label such as <option value="-1">Computer Name</option>
 *
 * NOTE: Attempts to preserve the current selection, or reverts to "-1" if the selection has disappeared.
 */
function copy_select_options(from_select, to_select)
{
		/*
		 * Disable the select element so that it does not conflict with any user-interaction
		 */
		var saved_state = to_select.disabled;

		if (!saved_state) {
			to_select.disabled = true;
		}

		/*
		 * Remember the selection value of this pulldown, if any
		 */
		var current_value_selection = null;
		if (to_select.selectedIndex) {
			var current_selected_index = to_select.selectedIndex;
			current_value_selection = to_select.value;
		} else {
			current_value_selection = "-1";
		}

		/*
		 * Clear the select options as we are now going to refresh the list
		 * 	Keep the descriptive label
		 */
		for (var k = to_select.options.length - 1; k > 0; k--) {
			to_select.options[k] = null;
		}

		/*
		 * Copy options from the new select
		 * 	Don't touch the descriptive label, start from entry 1
		 * 	opt.text = "Computer Name"; opt.value = "-1";
		 */
		var selected_index = 0;
		for (var entry = 1; entry < from_select.options.length; ++entry) {
			to_select.options.add(new Option(from_select.options[entry].text, from_select.options[entry].value));

			/*
			 * If the previously selected value matches this entry then we remeber the
			 * index of it so that we can restore the selected position
			 */
			if (from_select.options[entry].value == current_value_selection) {
				selected_index = entry;
			}
		}

		/*
		 * Restore the selected position
		 */
		to_select.selectedIndex = selected_index;

		/*
		 * Re-enable the select element
		 */
		to_select.disabled = saved_state;
}

/* 
 * Hide SSI #tr tags for local debug 
 *   Usage:
 *		function page_load()
 *		{
 *			if ("<!--#echo var='$(DUMMY)' -->" !== "") {
 *				hide_all_ssi_tr();
 *				return;
 *			}
 *		}
 */
function strip_ssi_tr (string)
{
	var clean = string.replace(/<!--#\s*tr\s.*?-->/g, '');
	return clean.replace(/<!--#\s*endtr\s*-->/g, '');
}

function hide_all_ssi_tr()
{
	document.title = strip_ssi_tr(document.title);
	for (var i = 0; i < document.forms.length; i++) {
		var df = document.forms[i];
		for (var j = 0; j < df.elements.length; j++) {
			var dfe = df.elements[j];
			if (dfe.type == 'button' || dfe.type == 'submit' || dfe.type == 'reset') {
				dfe.value = strip_ssi_tr(dfe.value);
			}
		}
	}
}

/*
 * has_class(element, class_name)
 *	Tests whether the specified HTML element has a particular CSS class.
 */
function has_class(element, class_name)
{
	if (!element.className) {
		element.className = "";
		return false;
	}

	/*
	 * This regex is similar to \bclassName\b, except that \b does not
	 * treat certain legal CSS characters as "word characters": notably,
	 * the . and - characters.
	 */
	var regex = new RegExp("(^|\\s)\\s*" + class_name + "\\s*(\\s|$)");
	return regex.test(element.className);
}

/*
 * remove_class(element, class_name)
 *	Remove the requested CSS class from an HTML element. If the element does not
 *	currently have the requested class, this function does nothing.
 */
function remove_class(element, class_name)
{
	if (!element.className) {
		element.className = "";
		return;
	}

	/*
	 * This regex is similar to \bclassName\b, except that \b does not
	 * treat certain legal CSS characters as "word characters": notably,
	 * the . and - characters.
	 */
	var regex = new RegExp("(^|\\s)\\s*" + class_name + "\\s*(\\s|$)");
	element.className = element.className.replace(regex, "$1$2");
}

/*
 * add_class(element, class_name)
 *	Add the requested CSS class from an HTML element. If the element 
 *	already has the requested class, this function does nothing.
 */
function add_class(element, class_name)
{
	if (has_class(element, class_name)) {
		return;
	}
	element.className += (element.className == "" ? "" : " ") + class_name;
}

/*
 * disable_form_field(field, disable)
 *	This function is used to enable and disable form fields. It operates by modifying
 *	the Javascript "disabled" property along with the CSS "disabled" class at
 *	the same time. This allows the Web designer to control the display of disabled
 *	form elements easily.
 *
 *	If <disable> is true or false, then the <field>.disable is set to that value.
 *	Otherwise, <field>.disable is toggled.
 */
function disable_form_field(field, disable)
{
	if (disable != true && disable != false) {
		disable = !field.disabled;
	}
	if (disable) {
		add_class(field, "disabled");
	} else {
		remove_class(field, "disabled");
	}
	field.disabled = disable;
}
