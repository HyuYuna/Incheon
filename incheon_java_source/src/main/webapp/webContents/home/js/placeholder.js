$(function() {
	var placeholder = $("input[placeholder]");

	function makePlaceHolder(){
		placeholder.each(function(i) {
			var parHeight = placeholder.eq(i).css("height");
			var parLineHeight = placeholder.eq(i).css("lineHeight");
			var parPadd = placeholder.eq(i).css("padding");
			var parWidth = placeholder.eq(i).css("width");
			var parTxtIn = placeholder.eq(i).css("textIndent");
			var line_height = placeholder.eq(i).css("line-height");
			var parColor = placeholder.eq(i).css("color");
			var parFont = placeholder.eq(i).css("fontFamily");
			var parFontSize = placeholder.eq(i).css("fontSize");
			placeholder.eq(i).wrap("<div class='placehold' style='position:relative; display:inline-block; *display:inline; *zoom:1;'></div>");
			$(".placehold").eq(i).append("<span>"+placeholder.eq(i).attr("placeholder")+"</span>");
			placeholder.eq(i).next().css({
					"height":parHeight,
					"lineHeight":parLineHeight,
					"padding":parPadd,
					"width":parWidth,
					"textIndent":parTxtIn,
					"line-height":line_height,
					"color":parColor,
					"fontSize":parFontSize,
					"fontFamily":parFont,
					"position":"absolute",
					"left":0,
					"top":0,
					"display":"block"
				});
		});
	}
	makePlaceHolder();

	placeholder.each(function(i) {
		var holderVal=placeholder.eq(i).val().length;
		if(holderVal==0){
			$(this).next("span").show();
		}
		placeholder.bind("focusin",function(){
			$(this).next("span").hide();
			placeholder.not(this).filter(function(index){return $(this).val().length==0}).next("span").show();
		})
	});

	$(".placehold span").click(function(){
		$(this).prev().focus();
	})

})