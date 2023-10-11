# ========================================================
# 名称：WebStation
# 类型：静态函数库
# 简介：专用于生成静态网站的函数库
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-10 21:32:15
# 最后修改时间：2023年8月15日21:04:53
# ========================================================
class_name WebStation

# =================================== 基础页面 ===================================
# HTML页面框架代码
static func page(page_title:String,content:String) -> String:
	var html = """
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{page_title}</title>
	<link rel="stylesheet" href="index.css">
	<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(function(){
			//设置图片列数
			$("#col_nums").on("change",function(){
				var cols = $("#col_nums").val();//列数
				$(".img_list").css("column-count",cols);
			})
			//设置图片列数
			$("#bg_color").on("change",function(){
				var bg = $("#bg_color").val();
				$("body").css("background-color",bg);
			})
		})
	</script>
</head>
<body>

{content}

</body>
</html>
"""
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
const IMG_TYPES = ["webp","jpg","png","jpeg"] # 支持的图片格式
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
	return """/*==================================================
名称：index.css 
描述：专用于Godot静态网站生成的CSS样式表，结合WebStation函数库
作者：巽星石
创建时间：2023年8月10日20:20:08
最后修改时间：2023年8月26日12:55:00
================================================== */


:root{
	--line-color:rgba(58, 104, 255, 0.441);
	--bg--color: #242424;
}
body{
	background-color: #242424;
	background-image:
		linear-gradient(var(--line-color) 50%,transparent 50%),
		linear-gradient(90deg,var(--line-color) 50%,transparent 50%);
	background-size: 20px 20px;
}

/*-======================================== 默认样式清除 ========================================-*/
*{margin:0px;padding: 0px;}
ul,li{list-style: none;}
h1,h2,h3,h4,h5,h6{margin: 5px 0px;padding:0px 5px;}
a{text-decoration: none;color:#4babe6;}
a:hover{text-decoration: underline;color:#114362;}
/*-======================================== 一般样式设定  ========================================-*/
/*- 一般正文H1-H6设定 -*/
h1{border-bottom:1px solid #4babe6;}
h2{border-bottom: 1px solid #ffffff;
	color: #fff;
}

/*-======================================== 布局 ========================================-*/
/*- 左边栏，右主区 -*/
.layout_left_main{
	display: grid;
	grid-template-columns: 200px calc(100% - 200px - 20px);
	column-gap: 10px;
}
/*- 左边栏，右主区 -*/
.layout_main_right{
	display: grid;
	grid-template-columns: calc(100% - 200px - 20px) 200px;
	column-gap: 10px;
}
/*- 居中 -*/
.center_100pc{width:100%;}/*- 100% 居中 -*/
.center_90pc{width:90%;margin: 0px auto;}/*- 90% 居中 -*/
.center_80pc{width:80%;margin: 0px auto;}/*- 80% 居中 -*/
.center_1000px{width:1000px;margin: 0px auto;}/*- 1000像素 居中 -*/
.center_1200px{width:1200px;margin: 0px auto;}/*- 1000像素 居中 -*/
.center_1400px{width:1400px;margin: 0px auto;}/*- 1000像素 居中 -*/

/*- 分栏 -*/
.colm_layout{column-gap:5px;} /*- 统一分栏间隔 -*/
.col_2{column-count:2;}/*- 2栏 -*/
.col_3{column-count:3;}/*- 3栏 -*/
.col_4{column-count:4;}/*- 4栏 -*/
.col_5{column-count:3;}/*- 5栏 -*/
.col_6{column-count:4;}/*- 6栏 -*/
/*- 图片分栏瀑布流 -*/
.img_list img{
	border-radius: 5px;border:1px solid #f7f7f7;
	max-width: calc(100% - 20px);
	padding: 10px;
	background-color: #fff;
}

/*-======================================== 顶部菜单 ========================================-*/
.fix_top_menu{width:100%;height:40px;position: fixed;left: 0px;top:0px;}
.fix_top_menu h1,ul,li{display: inline;}
.fix_top_menu h1{border-bottom:none;font-size: 30px;color:#fff;}
.fix_top_menu a{display: inline-block;background-color: #310915;padding:5px;color: aliceblue;}

/*- 背景色：深红 -*/
.bg_dack_red{
	background-image: linear-gradient(45deg,#2196F3,#607D8B);
	border-bottom: 1px solid #00fff3;
} 
.pt50{padding-top: 50px;}/*- 顶部内边距50 用于有顶部菜单时正文区的显示修正 -*/
.icon{width:20px;border-radius: 0px;border:none;}

/*-======================================== 自定义区域 ========================================-*/

/*-===== 高亮区 =====-*/
/*
显示与语雀“高亮区”类似的效果。
<div class="heighlight_panel notice">
	<h3 class="title">注意</h3>
	<div class="content">
		<p>这里说的是一般情况。</p>
	</div>
</div>
其中heighlight_panel为一般高亮区设定，notice是具体的高亮区设定。
*/
.heighlight_panel{
	width:100%;
	border:1px solid #ccc;border-radius: 5px;
}
.heighlight_panel h3.title{padding: 2px 5px;margin: 0px;}
.heighlight_panel .content{padding:5px;}
/*- 注意 -*/
.notice{background-color: rgb(253 255 208);border:1px solid #e6eb80;}
.notice h3.title{color:#6e7127;}

/*-===== 带标题的面板 =====-*/
/*
一个带标题的面板，可以作为侧边栏或正文块使用。
<div class="title_panel">
  <h3 class="title">标题</h3>
  <div class="content">
	内容在这里
  </div>
</div>
*/
.title_panel{
	width:100%;
	border:1px solid rgb(252, 225, 255);
	border-radius: 5px;
	background-color: #fff;
}
.title_panel h3.title{
	border-bottom: 1px solid rgb(252, 225, 255);
	background-color: #ffe7ea;
	color: #761822;
	padding: 2px 5px;margin: 0px;
}
.title_panel .content{padding:5px;}

/*-===== 链接列表 =====-*/
.toolbar{
	width:200px;
	position: fixed;top:60px;right:5px;
}
.toolbar .content{display:grid;grid-template-columns: 100px auto;row-gap: 5px;}


/*-===== 图片链接 =====-*/
/*
一个以圆角矩形卡片显示的带封面和标题的链接。
<div class="cards">
<div class="card">
	<a href="https://www.baidu.com/">
		<img src="https://www.baidu.com/img/flexible/logo/pc/result@2.png">
		<h4>百度<h4>
	</a>
</div><div class="card">
	<a href="https://www.bilibili.com/">
		<img src="https://i0.hdslb.com/bfs/archive/c8fd97a40bf79f03e7b76cbc87236f612caef7b2.png">
		<h4>B站<h4>
	</a>
</div>
</div>
*/
.card{
	width:190px;display: inline-block;
	border-radius: 10px;
	margin-top:5px;
	background: #2f2f2f;
}

.card a{text-decoration: none;color: #a3a3a3;}
.card img{
	width:100%;aspect-ratio: 2;
	object-fit: cover;
	border-radius: 5px 5px 0px 0px;
	transition:object-position 1s;
}
.card img:hover{object-position: left bottom;}
.card h4{text-align: center;font-weight: normal;}

/*-===== 链接列表 =====-*/
/*
<ul class="link_list">
	<li><a href="https://www.baidu.com/" target="_blank">百度</a></li>
	<li><a href="https://www.bilibili.com/" target="_blank">B站</a></li>
</ul>
*/
.link_list,.link_list li{display: block;}"""
