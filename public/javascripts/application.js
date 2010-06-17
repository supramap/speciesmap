// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggle_display(ele)
{
	if ($(ele).style.visibility == "hidden") {
		$(ele).style.display = "block";
		$(ele).style.visibility = "visible";
	} else {
		$(ele).style.display = "none";
		$(ele).style.visibility = "hidden";
	}
}
