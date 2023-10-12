# ========================================================
# 名称：md2HTML
# 类型：静态函数库
# 简介：提供MarkDown到HTML的基础解析
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-15 23:36:59
# 最后修改时间：2023年8月27日00:42:49
# ========================================================
class_name md2HTML
extends H5Creator

# =================================== Markdown解析 ===================================
# Markdown --> HTML
static func parse(md:String):
	
	# Markdown:代码块 --> HTML:span.code_block
	md = parse_code_block(md)
	# Markdown:H1~H6 --> HTML:H1~H6
	for i in range(6,0,-1):
		md = parse_h(i,md)
	
	# Markdown:**text** --> HTML:<b>text</b>
	md = parse_bold(md)
	# Markdown:图片 --> HTML:图片
	md = parse_img(md)
	# Markdown:超链接 --> HTML:超链接
	md = parse_link(md)
	# Markdown:table --> HTML:table
	md = parse_table(md)
	md = md.replace("\n\n<tr><td>","<table><tr><td>")
	md = md.replace("</tr>\n\n","</table>")
		
	
	# Markdown:行内代码 --> HTML:span.inline_code
	md = parse_inline_code(md)
	# Markdown:ul --> HTML:ul
	md = parse_ul(md)
	
	md = md.replace("\n\n","<p>\n")
	md = md.replace("---","<hr>")
	# 还原代码块中特殊的替换
	md = special_reduction(md)
	
	return md

# Markdown:H1~H6 --> HTML:H1~H6
static func parse_h(level:int,md:String):
	
	var reg = RegEx.new()
	reg.compile("%s (.*)" % "#".repeat(level))
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_title = mat.get_string()
			var title = mat.get_string(1)
			md = md.replace(md_title,H(level,title))
	return md

# Markdown:ul --> HTML:ul
static func parse_ul(md:String):
	
	var reg = RegEx.new()
	reg.compile("- (.*)")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_ul = mat.get_string()
			var title = mat.get_string(1)
			md = md.replace(md_ul,double_tag("li",title))
	return md

# Markdown:table --> HTML:table
static func parse_table(md:String):

	var reg = RegEx.new()
	var result:Array[RegExMatch]
	# 去除 | --- |形式
	reg.compile("|\\s*[-]+.*\\s*|\n".replace("|","\\|"))
	result = reg.search_all(md)
	if result:
		for mat in result:
			var md_line = mat.get_string()
			md = md.replace(md_line,"")
	# 匹配普通行
	reg.compile("|(.*)|".replace("|","\\|"))
	result = reg.search_all(md)
	if result:
		for mat in result:
			var md_td = mat.get_string()
			var text = special_replace(mat.get_string(1))
			var tr = "<tr><td>%s</tr>" % text
			tr = tr.replace("|","<td>")
			md = md.replace(md_td,tr)
	
	return md


# Markdown:**text** --> HTML:<b>text</b>
static func parse_bold(md:String):
	
	var reg = RegEx.new()
	reg.compile("[\\*]{2}(.+)[\\*]{2}")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_bold = mat.get_string()
			var content = mat.get_string(1)
			md = md.replace(md_bold,double_tag("b",content))
	return md



# Markdown:行内代码 --> HTML:span.inline_code
static func parse_inline_code(md:String):
	
	var reg = RegEx.new()
	reg.compile("`([^`]+)`")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_inline = mat.get_string()
			var code = mat.get_string(1)
			var span = "<span class=\"inline_code\">%s</span>" % code
			md = md.replace(md_inline,span)
	return md

# Markdown:代码 --> HTML:span.code_block
static func parse_code_block(md:String):
	
	var reg = RegEx.new()
	reg.compile("`{3}.*\n([\\w\\W]+?)`{3}")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_code = mat.get_string()
			var code = mat.get_string(1).xml_escape()
			# 特殊替换
			code = special_replace(code)
			# 构造pre
			var cd = double_tag("code",code)
			var pre = double_tag("pre",cd)
			var div = double_tag("div",pre,"class=\"code_block\"")
			md = md.replace(md_code,div)
	return md

# 特殊替换
static func special_replace(md:String):
	md = md.replace("# ","{#} ") # Godot注释
	md = md.replace("- ","{-} ") # -
	md = md.replace("\n\n","{n}")
	md = md.replace("---","{-}")
	return md

# 还原特殊的替换
static func special_reduction(md:String):
	md = md.replace("{#} ","# ")
	md = md.replace("{-} ","- ")
	# 还原
	md = md.replace("{n}","\n\n")
	md = md.replace("{-}","---")
	return md

# Markdown:超链接 --> HTML:超链接
static func parse_link(md:String,target:String = "_blank"):
	
	var reg = RegEx.new()
	reg.compile("\\[(.*)\\]\\((.*)\\)")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_url = mat.get_string()
			var title = mat.get_string(1)
			var url = mat.get_string(2)
			if url.ends_with(".md"):
				url = url.replace(".md",".html")
				md = md.replace(md_url,A(url,title))
			else:
				md = md.replace(md_url,A(url,title,"target=\"%s\"" % target))
	return md

# Markdown:图片 --> HTML:图片
static func parse_img(md:String,target:String = "_blank"):
	
	var reg = RegEx.new()
	reg.compile("!\\[(.*)\\]\\((.*)\\)")
	
	var result:Array[RegExMatch] = reg.search_all(md)
	if result:
		for mat in result:
			var md_img = mat.get_string()
			var desc = mat.get_string(1)
			var src = mat.get_string(2)
			md = md.replace(md_img,img(src,"alt=\"%s\"" % desc))
	return md
