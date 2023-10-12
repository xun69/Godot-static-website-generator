# ========================================================
# 名称：WebStation
# 类型：静态函数库
# 简介：专用于生成静态网站的函数库
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-10 21:32:15
# 最后修改时间：2023年10月12日22:54:18
# ========================================================
class_name WebStation




# =================================== 基础页面 ===================================
# HTML页面框架代码
static func page(page_title:String,content:String) -> String:
	var myFile = preload("res://lib/myFile.gd").new()
	var html = myFile.loadString("res://lib/tmps/picStation/base.html")
	html = html.replace("{page_title}",page_title)
	html = html.replace("{content}",content)
	return html

# =================================== 顶部固定菜单 ===================================
# 固定布局的顶部菜单栏
static func fix_top_menu(links:Array,station_title:String) -> String:
	var link_list = link_list(links,"").replace(" class=\"link_list\"","")
	var center = center_1000px("<h1>%s</h1>\n%s" % [station_title,link_list])
	var html = """
<div class="fix_top_menu bg_dack_red">
	{content}
</div>
""".replace("{content}",center)
	return html

# =================================== 布局生成 ===================================
# 布局 - 左边栏,右主区
static func layout_left_main(left_content:String,main_content:String) -> String:
	var html = """
<div class="layout_left_main">
	<div class="left">
		{left_content}
	</div>
	<div class="main">
		{main_content}
	</div>
</div>"""
	html = html.replace("{left_content}",left_content)
	html = html.replace("{main_content}",main_content)
	return html

# 布局 - 左主区,右边栏
static func layout_main_right(main_content:String,right_content:String) -> String:
	var html = """<div class="layout_main_right">
	<div class="main">
		{main_content}
	</div>
	<div class="right">
		{left_content}
	</div>
</div>"""
	html = html.replace("{left_content}",right_content)
	html = html.replace("{main_content}",main_content)
	return html

# =================================== 居中 ===================================
# =================================== 百分比宽度
# 居中 - 100%宽
static func center_100pc(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_100pc{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)

# 居中 - 90%宽
static func center_90pc(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_90pc{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)

# 居中 - 80%宽
static func center_80pc(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_80pc{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)
# =================================== 固定宽度
# 居中 - 1000px宽
static func center_1000px(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_1000px{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)

# 居中 - 1200px宽
static func center_1200px(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_1200px{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)

# 居中 - 1400px宽
static func center_1400px(content:String,pt50:bool = false) -> String:
	var html = """<div class="center_1400px{pt50}">
	{content}
</div>""".replace("{content}",content)
	var pt50_str = " pt50" if pt50 else ""
	return html.replace("{pt50}",pt50_str)

# =================================== 自定义区域 ===================================
const IMG_TYPES = ["webp","jpg","png","jpeg","gif"] # 支持的图片格式
# 图片瀑布流页面 - 返回对应的html代码
# img_dir:       为具体的图片文件夹路径   = index_dir/img_dir_name/sub_dir
# url_base_path: 网页中使用的基础相对路径 = img_dir_name/sub_dir
static func img_list(img_dir:String,url_base_path:String,cols:int=2,support_formats:PackedStringArray = IMG_TYPES) -> String:
	# myFile实例
	var myFile = preload("res://lib/myFile.gd").new()
	# html
	var img_list_div ="<div class=\"colm_layout col_%d img_list\">\n{img_list}\n</div>\n" % clamp(cols,2,6)
	var item_html = "<img src=\"{src}\">\n"
	var html:String
	# 遍历所有支持的图片格式
	for format in support_formats:
		# 获取相应类型图片的文件名列表
		var files = myFile.get_sub_filter_files(img_dir,format)
		for file in files:
			html += item_html.replace("{src}","%s/%s" % [img_dir,file])
	return img_list_div.replace("{img_list}",html)
	
	

# 超链接列表
static func link_list(links:Array,target:String="_blank") -> String:
	var item_html ="\t<li><a href=\"{URL}\" target=\"%s\">{title}</a></li>\n" % target
	var ul_html ="<ul class=\"link_list\">\n{list}</ul>\n"
	var html:String
	for link in links:
		html += item_html.replace("{title}",link[0]).replace("{URL}",link[1])
	return ul_html.replace("{list}",html)

# 带标题的面板
static func title_panel(title,content) -> String:
	var html = """
<div class="title_panel">
	<h3 class="title">{title}</h3>
	<div class="content">
{content}
	</div>
</div>
"""
	html = html.replace("{title}",title)
	html = html.replace("{content}",content)
	return html

# 带标题和封面以及链接的卡片 - 图片链接
static func card_link_lists(gup_title:String,links:Array) -> String:
	var html = ""
	var cards = "<h2>%s</h2>\n<div class=\"cards\">\n{list}\n</div>\n" % gup_title
	var card = """
<div class="card">
	<a href="{URL}">
		<img src="{face}">
		<h4>{title}<h4>
	</a>
</div>
"""
	for link in links:
		html += card.replace("{title}",link[0]).replace("{URL}",link[1]).replace("{face}",link[2])

	return cards.replace("{list}",html)

# 高亮面板 - 注意
static func notice_panel(content:String) -> String:
	var html = """
<div class="heighlight_panel notice">
	<h3 class="title">注意</h3>
	<div class="content">
		<p>{content}</p>
	</div>
</div>
"""
	html = html.replace("{content}",content)
	return html

# 图片设置工具栏
static func img_toolbar() -> String:
	var html = """

<!--工具栏-->
<div class="title_panel toolbar">
	<h3 class="title">设置</h3>
	<div class="content">
		<!--设置图片分栏列数-->
		<span>显示列数</span>
		<select id="col_nums">
			<option value="1">1列</option>
			<option value="2" selected>2列</option>
			<option value="3">3列</option>
			<option value="4">4列</option>
			<option value="5">5列</option>
			<option value="6">6列</option>
		</select>
		<!--设置背景色-->
		<span>背景色</span>
		<select id="bg_color">
			<option value="#fff">白色</option>
			<option value="#4a4a4a" selected>深灰</option>
		</select>
	</div>
</div>

"""
	return html



# =================================== CSS样式表 ===================================
static func index_css() -> String:
	var myFile = preload("res://lib/myFile.gd").new()
	return myFile.loadString("res://lib/tmps/picStation/index.css")
