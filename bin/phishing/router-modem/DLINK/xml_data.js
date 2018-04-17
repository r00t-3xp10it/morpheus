/*
 * xmlData class.
 *	Provides a mechanism to retrieve an XML document from the server and then extract its data.
 *
 * As a first it tries to use the XML DOM model for document retrieval.
 * Failing that, we revert to using the XMLHTTP model.
 */

/*
 * Constants for the XML DOM state changes.
 */
var XML_UNINITIALIZED = 0;
var XML_LOADING = 1;
var XML_LOADED = 2;
var XML_INTERACTIVE = 3;
var XML_COMPLETED = 4;

/*
 * Global level code that detects if the browser supports the DOMParser method.
 * If it doesn't then we make our own compatibility version!
 */
if (typeof DOMParser == "undefined") {
	DOMParser = function ()
	{
	}

	DOMParser.prototype.parseFromString = function (str, content_type)
	{
		if (typeof ActiveXObject != "undefined") {
			var d = new ActiveXObject("MSXML.DomDocument");
			d.loadXML(str);
			return d;
		}
		if (typeof XMLHttpRequest != "undefined") {
			var req = new XMLHttpRequest;
			req.open("GET", "data:" + (contentType || "application/xml") +
					";charset=utf-8," + encodeURIComponent(str), false);
			if (req.overrideMimeType) {
				req.overrideMimeType(contentType);
			}
			req.send(null);
			return req.responseXML;
		}
		return null;
	}
}

function xmlDataObject_getDocument()
{
	if (this.xmlDoc.responseXML != null)
		return this.xmlDoc.responseXML;
	return this.xmlDoc;
}

/*
 * xmlDataObject_getElementData()
 *
 * Use the W3C DOM method for finding a tag and
 * returning the data content.
 */
function xmlDataObject_getElementData(tag_name)
{
	/*
	 * Slight difference depending on Mozilla/IE and Opera on how we get the XML elements
	 */
	var tag = null;
	try {
		tag = this.xmlDoc.getElementsByTagName(tag_name);
	} catch (e) {
		try {
			tag = this.xmlDoc.responseXML.getElementsByTagName(tag_name);
		} catch (ee) {
			return null;
		}
	}

	try {
		if (tag.length == 0) {
			return null;
		}
		var node = tag[0].firstChild;
		if (node == null) {
			return null;
		}
		return node.nodeValue;
	} catch (e) {
		return null;
	}
}

/*
 * xmlDataObject_createXMLDocument()
 *	Creates the object used to retrieve the XML resource
 *
 * Returns true if able to create an XML retrieval document, else false.
 */
function xmlDataObject_createXMLDocument()
{
	/*
	 * Create a variable that _is_ this object so that the anonymous
	 * functions can access it
	 */
	var xmlDataInstance = this;

	/*
	 * Create an XML DOM for retrieving the data
	 */
	if ((typeof document.implementation == "object") && (typeof document.implementation.createDocument == "function")) {
		/*
		 * This is Mozilla (and others) compatible and is the preferred standard for retrieving an XML document.
		 */
		this.xmlDoc = document.implementation.createDocument("", "", null);

		/*
		 * Opera browsers do not support this method, however, even though they say they can!
		 */
		if (typeof this.xmlDoc.load != "undefined") {
			/*
			 * Supported properly
			 */
			this.xmlDoc.onload = function () {
				/*
				 * Loading can complete in error!
				 * If there is no data then ignore (wait for timeout).
				 */
				if (xmlDataInstance.xmlDoc.firstChild == null) {
					return;
				}

				/*
				 * Mozilla sets this in case of invalid XML.
				 */
				if (xmlDataInstance.xmlDoc.firstChild.nodeName == 'parsererror') {
					return;
				}

				/*
				 * Clear the timeout and signal success
				 */
				window.clearTimeout(xmlDataInstance.timeoutId);
				xmlDataInstance.timeoutId = 0;
				xmlDataInstance.dataReadyFunc(xmlDataInstance);
			}
			return true;
		}

		/*
		 * Drop through and try Microsoft and Opera
		 */
		this.xmlDoc = null;
	}
	
	/*
	 * Try IE and Opera flavours
	 */
	try {
		this.xmlDoc = new ActiveXObject("MSXML2.FreeThreadedDOMDocument.4.0");
	} catch (e) {
		try {
			this.xmlDoc = new ActiveXObject("MSXML2.FreeThreadedDOMDocument.3.0");
		} catch (e2) {
			try {
				this.xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			} catch (e3) {
				try {
					this.xmlDoc = new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e4) {
					try {
						this.xmlDoc = new ActiveXObject("Microsoft.XMLHTTP");
					} catch (e5) {
						try {
							this.xmlDoc = new XMLHttpRequest();
						} catch (e6) {
							/*
							 * Old unsupported browser.
							 */
							return false;
						}
					}
				}
			}
		}
	}

	this.xmlDoc.onreadystatechange = function () {
		if (xmlDataInstance.xmlDoc.readyState == XML_COMPLETED) {
			if (xmlDataInstance.operaRepeatedCompletionCallBugFix) {
				return;
			}

			/*
			 * Opera browsers have a repeated call bug
			 */
			xmlDataInstance.operaRepeatedCompletionCallBugFix = true;

			/*
			 * Some browsers have a status field that reports the GET HTML status.
			 * GGG - For some reason IE does not generate an exception that can be caught with try...catch for this field
			 */
			if (typeof xmlDataInstance.xmlDoc.status != "undefined") {
				if (xmlDataInstance.xmlDoc.status != 200) {
					/*
					 * Rely on timeout
					 */
					return;
				}
			} else {
				/*
				 * For browsers that do not have a status field, see if there are any XML elements
				 */
				try {
					if (xmlDataInstance.xmlDoc.firstChild == null) {
						/*
						 * Rely on timeout
						 */
						return;
					}
				} catch (ee) {
					try {
						if (xmlDataInstance.xmlDoc.responseXML.firstChild == null) {
							/*
							 * Rely on timeout
							 */
							return;
						}
					} catch (eee) {
						/*
						 * Rely on timeout
						 */
						return;
					}
				}
			}

			window.clearTimeout(xmlDataInstance.timeoutId);
			xmlDataInstance.timeoutId = 0;
			xmlDataInstance.dataReadyFunc(xmlDataInstance);
		}
	}
	return true;
}

/*
 * xmlDataObject_initialiseFromString()
 *	Using the given string, initialise the instance XML document.
 */
function xmlDataObject_initialiseFromString(xml_string)
{
	var parser = new DOMParser();
	this.xmlDoc = parser.parseFromString(xml_string, "text/xml");
}

/*
 * xmlDataObject_retrieveData()
 *	Begin retrieval.
 *
 * Returns false if unable to perform XML retrieval.
 */
function xmlDataObject_retrieveData()
{
	/*
	 * Ensure document retrieval is possible
	 */
	if (this.xmlDoc == null) {
		return false;
	}

	/*
	 * Create a local variable that is an anonymous function to be evaluated when the timeout occurs.
	 * The anonymous function will have access to the xmlDataObject instance!
	 */
	var xmlDataInstance = this;
	var fnx = function() {
		/*
		 * Destroy the existing document.
		 */
		if (xmlDataInstance.xmlDoc.abort) {
			xmlDataInstance.xmlDoc.abort();
		}
		xmlDataInstance.operaRepeatedCompletionCallBugFix = false;

		/*
		 * Invoke the timeout callback function
		 */
		xmlDataInstance.dataTimeoutFunc(xmlDataInstance);

		/*
		 * Timer has stopped
		 */
		this.timeoutId = 0;
	}
	this.timeoutId = window.setTimeout(fnx, this.timeoutMillis);

	/*
	 * Reset the opera bug fix flag
	 */
	this.operaRepeatedCompletionCallBugFix = false;

	/*
	 * Start the loading of the resource
	 */
	try {
		/*
		 * XML model
		 */
		this.xmlDoc.async="true";
		this.xmlDoc.load(this.dataURL);
	} catch (e) {
		try {
			/*
			 * HTTP XML request.
			 */
			this.xmlDoc.open('GET', this.dataURL, true);

			/*
			 * Safari 1.3 bug - need to force Safari to always reload
			 */
			if (this.xmlDoc.setRequestHeader) {
				this.xmlDoc.setRequestHeader('If-Modified-Since', 'Wed, 15 Nov 1995 00:00:00 GMT');
			}

			/*
			 * Issue the request
			 */
		 	this.xmlDoc.send();
		} catch (ee) {
			/*
			 * Rely on timeout
			 */
			return false;
		}
	}
	return true;
}

/*
 * xmlDataObject_stopRetrieval()
 *	Stop retrieval (if in progress).
 */
function xmlDataObject_stopRetrieval()
{
	/*
	 * Destroy the existing document.
	 */
	if (this.xmlDoc.abort) {
		this.xmlDoc.abort();
	}
	this.operaRepeatedCompletionCallBugFix = false;
	if (this.timeoutId != 0) {
		window.clearTimeout(this.timeoutId);
		this.timeoutId = 0;
	}
}

/*
 * xmlDataObject()
 *	Create an XML data object.
 *
 * Used to retrieve data from the server in XML format.
 * The given function is invoked when the data is retrieved.
 */
function xmlDataObject(dataReadyFunc, dataTimeoutFunc, timeoutMillis, dataURL)
{
	/*
	 * Initialise properties.
	 */
	this.dataReadyFunc = dataReadyFunc;
	this.dataTimeoutFunc = dataTimeoutFunc || xmlDataObject_dataTimeoutFunc;
	this.dataURL = dataURL;
	this.timeoutMillis = timeoutMillis || 6000;
	this.extendedTimeoutMillis = 20000;
	this.timeoutId = 0;
	this.xmlDoc = null;

	this.operaRepeatedCompletionCallBugFix = false;		/* To fix opera bug on getting called back more than once */
		
	/*
	 * Initialize the public methods
	 */
	this.retrieveData = xmlDataObject_retrieveData;
	this.stopRetrieval = xmlDataObject_stopRetrieval;
	this.getElementData = xmlDataObject_getElementData;
	this.getDocument = xmlDataObject_getDocument;
	this.initialiseFromString = xmlDataObject_initialiseFromString;

	/*
	 * Initialise private methods
	 */
	this.createXMLDocument = xmlDataObject_createXMLDocument;

	/*
	 * Create our XML retrieval document
	 * NOTE: We only create one and constantly re-use it.
	 */
	this.createXMLDocument();

	/*
	 * Register this instance with a function that is to be invoked when the browser closes.
	 * NOTE: We use the onunload event to stop XML transfers as this could hold up web browsing while
	 * outstanding transfers complete.
	 */
	var xmlDataInstance = this;
	var fnx = function() {
		xmlDataInstance.stopRetrieval();
	}
	add_onunload_listener(fnx);
}

/*
 * XSLT Processor class.
 * This class encapsulates the differences between Firefox's and IE's XSLT interfaces,
 * providing an external interface that is consistent across browsers. The general
 * method for using this class is as follows:
 * 1) Create an xsltProcessingObject
 * 2) Retrieve its data and wait for a callback
 * 3) In the callback function, apply a transformation on an XML data object and
 * 	apply the results to an existing HTML element.
 *
 * Here is the complete code for a typical usage:
 *
 * var xmlData = // Some XMLDocument - use xmlDataObject or XMLDocument, for example.
 * var xslt = new xsltProcessingObject(dataReady, timeout, 6000, "/transform.xslt");
 * function PageLoad()
 * {
 * 	xslt.retrieveData();
 * }
 *
 * function dataReady()
 * {
 * 	var parentNode = window.document.getElementById("xslt_target");
 * 	xslt.transform(xmlData, window.document, parentNode);
 * 	parentNode.style.display = ""; // Make it visible
 *    // Now the transformation results have been added to parentNode
 * }
 *
 * function timeout()
 * {
 * 	alert("Timeout");
 * }
 *
 * // More scripting and HTML here...
 *
 * <body onload="PageLoad">
 * // More HTML here...
 * <div id="xslt_target" style="display:none"></div>
 * // More HTML here...
 */
function xsltProcessingObject(dataReadyFunc, dataTimeoutFunc, timeoutMillis, dataURL)
{
	// This allows anonymous functions called from a different object scope to be
	// able to access the <this> variable.
	var copy = this; 

	this.platformMoz = (document.implementation && document.implementation.createDocument);
	this.platformIE6 = (!this.platformMoz && document.getElementById && window.ActiveXObject);
	this.xsltUrl = dataURL;
	this.dataReady = dataReadyFunc;
	this.retrieveData = xslt_RetrieveData;
	this.transform = xslt_Transform;
	this.sheetReady = function(xmlDoc)
	{
		/*
		 * When the document has finished loading, we first initialize the parser
		 * (by compiling the stylesheet), and then tell the client that we are ready
		 * to perform transformations.
		 */
		copy.initParser(xmlDoc);
		copy.dataReady(xmlDoc); // Call the client's callback function
	};
	
	this.initParser = xslt_InitParser;
	this.createEmptyDocument = xslt_createEmptyDocument;
	this.data = new xmlDataObject(this.sheetReady, dataTimeoutFunc, timeoutMillis, dataURL);
	this.addParameter = xslt_AddParameter;
	this.processor = null;
}

/*
 * Compile the stylesheet into an executible form. If this function is called after
 * the stylesheet has been compiled, it will be thrown away and recompiled.
 */
function xslt_InitParser(xsltDocument)
{
	var doc = xsltDocument.getDocument();
	if (this.platformMoz) {
		this.processor = new XSLTProcessor();
		this.processor.importStylesheet(doc);
	} else if (this.platformIE6) {
		var xslTemplate = xslt_CreateActiveXTemplate();
		if (!xslTemplate) {
			throw "No XSLT Support";
		}
		xslTemplate.stylesheet = doc;
		this.processor = xslTemplate.createProcessor();
	} else {
		throw "No XSLT Support";
	}
}

/*
 * xslt_AddParameter()
 *	Applications to call only in the 'ready' callback.
 */
function xslt_AddParameter(param_name, param_value)
{
	if (this.processor != null) {
		if (this.platformMoz) {
			this.processor.setParameter(null, param_name, param_value);
		} else if (this.platformIE6) {
			this.processor.addParameter(param_name, param_value);
		}
	}
}

/*
 * xmlDataObject_dataTimeoutFunc()
 *	retry retrieval but will timeout less frequently
 */
function xmlDataObject_dataTimeoutFunc()
{
	this.timeoutMillis = this.extendedTimeoutMillis;
	this.retrieveData();
}

function xslt_RetrieveData()
{
	// Pass the retrieval request on to our internal data.
	this.data.retrieveData();
}

/*
 * Check several versions of the MSXML XSLTemplate ActiveX object to see which are
 * supported. Return the most current available version, or null if none can be found.
 */
function xslt_CreateActiveXTemplate()
{
	try {
		return new ActiveXObject("Msxml2.XSLTemplate.4.0");
	} catch (e) {}
	try {
		return new ActiveXObject("Msxml2.XSLTemplate.3.0");
	} catch (e) {}	
	try {
		return new ActiveXObject("Msxml2.XSLTemplate");
	} catch (e) {}	
	return null;
}

/*
 * This function performs an XSLT translation. The XSLT stylesheet must already be
 * stored inside this xsltProcessingObject; it is an error to call this function
 * before being notified, via the callback passed to the constructor, that this
 * XSLT object has finished loading.
 * The xmlDoc parameter must be an XMLDOMDocument, or equivalent ActiveX object. The
 * ownerDocument must be supplied as well, and it must the a top-level document which
 * will contain the HTML generated by applying the XSLT. If the target argument is
 * present, then it must be a descendant of the ownerDocument as well.
 * The target parameter is optional, and if specified must be a DOM node to which
 * all elements generated by the XSLT transformation should be attached. If a target
 * is specified, then all nodes are appended to it as if by calls to target.appendChild(),
 * and no value is returned. If no target is specified, then this function makes a
 * "best effort" attempt to create a parent element for the nodes to live in, and
 * returns that node. This creation is not guaranteed to work, because there is no
 * single HTML element which can legally contain any other arbitrary HTML element.
 * As a rule, this attempted creation will usually work in Firefox, and usually fail
 * in Internet Explorer, so use it at your own risk.
 */
function xslt_Transform(xmlDoc, ownerDocument, target)
{
	if (this.platformMoz) {
		var fragment = this.processor.transformToFragment(xmlDoc, ownerDocument);
		if (!target) {
			return fragment;
		}
		target.appendChild(fragment);
		return;
		
		/*
		 * This section is left here to demonstrate how one could convert Firefox's
		 * output to a string instead of converting IE's output to a node list.
		 * It is commented out to keep it from being executed, however.
		 */
		/*
			var tempHolder = document.createElement("span");
			tempHolder.appendChild(fragment);
			return tempHolder.innerHTML;
		*/
	} else if (this.platformIE6) {
		// Try the IE way
		this.processor.input = xmlDoc;
		this.processor.transform();
		var output = this.processor.output;

		if (target) {
			if (output != null && output.length > 0) {
				    target.innerHTML += output;
			}
			return;
		}
		
		var result = ownerDocument.createElement('span');
		result.outerHTML = output;
		return result;
	}
}

/*
 * Create an empty DOM Document using the correct interface for the current browser.
 * If no suitable interface for document creation can be found, this function will
 * return null.
 */
function xslt_createEmptyDocument()
{
	if (this.platformMoz) {
		/*
		 * This is Mozilla (and others) compatible and is the preferred standard for retrieving an XML document.
		 */
		return document.implementation.createDocument("", "", null);
	}
	
	/*
	 * Try IE and Opera flavours
	 */
	try {
		return new ActiveXObject("MSXML2.FreeThreadedDOMDocument.4.0");
	} catch (e) {}
	try {
		return new ActiveXObject("MSXML2.FreeThreadedDOMDocument.3.0");
	} catch (e) {}
	try {
		return new ActiveXObject("Microsoft.XMLDOM");
	} catch (e) {}
	try {
		return new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {}
	try {
		return new ActiveXObject("Microsoft.XMLHTTP");
	} catch (e) {}
	try {
		return new XMLHttpRequest();
	} catch (e) {}
	return null;
}

function xml_data_js_loaded() { return true; }

/*
 * We must check for XPath implementation; some browsers support it but do not
 * enable it by default. This code activates it if it exists. (This code is written
 * in the global scope so that it executes as the page loads).
 */
if ((typeof document.implementation == "object") && (typeof document.implementation.hasFeature == "function")) {
	if (document.implementation.hasFeature("XPath", "3.0")) {
		// Opera does not have XMLDocument
		if (typeof(XMLDocument) == "undefined") {
			XMLDocument = Document;
		}
		// prototying the XMLDocument
		XMLDocument.prototype.selectNodes = function(cXPathString, xNode) {
			if(!xNode) {
				xNode = this;
			} 
			var oNSResolver = this.createNSResolver(this.documentElement);
			var aItems = this.evaluate(cXPathString, xNode, oNSResolver, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
			var aResult = [];
			for (var i = 0; i < aItems.snapshotLength; i++) {
				aResult[i] =  aItems.snapshotItem(i);
			}
			return aResult;
		}

		// prototying the Element
		Element.prototype.selectNodes = function(cXPathString) {
			if (this.ownerDocument.selectNodes) {
			  return this.ownerDocument.selectNodes(cXPathString, this);
			} else {
				throw "For XML Elements Only";
			}
		}
	}
}
