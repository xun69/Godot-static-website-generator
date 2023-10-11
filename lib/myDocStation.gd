# ========================================================
# 名称：myDocStation
# 类型：类
# 简介：用于生成多个markdown页面组成的HTML文档
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-26 14:42:44
# 最后修改时间：2023-08-26 14:42:44
# ========================================================

class_name myDocStation
extends WebStation

# =================================== 属性 ===================================
var station_title:String = ""          # 网站名
var station_subtitle:String = ""       # 网站子标题
var index_dir:String     = ""          # 网站根目录

# =================================== 依赖 ===================================
var myFile = preload("res://lib/myFile.gd").new()

# =================================== 实例化 ===================================
func _init(m_station_title:String,m_station_subtitle:String,m_index_dir:String) -> void:
	# 设置相关属性和路径
	station_title = m_station_title
	station_subtitle = m_station_subtitle
	index_dir = m_index_dir

# 创建网站
func create_station() -> void:
	# .md ->.html
	create_dir_doc_pages(index_dir)
	# 打开第一页
	var sub_files = myFile.get_sub_filter_files(index_dir,"md")
	var first_page = "%s/%s" % [index_dir,sub_files[0]]
	first_page = first_page.replace(".md",".html")
	myFile.shell_open(first_page) # 自动打开第一个文档
#	print(doc_tree(index_dir))
	pass


# 遍历生成docTree
func doc_tree(dir:String,depth:int = 0,path_deepth = 0):
	var tree:String = "%s<ul>\n" % "\t".repeat(depth)
	var ul_end = "%s</ul>\n" % "\t".repeat(depth)
	# 遍历所有.md文件
	var sub_files = myFile.get_sub_filter_files(dir,"md")
	for file in sub_files:
		var title = file.replace(".md","")
		var rel_dir = dir.replace(index_dir,"")
		if rel_dir.begins_with("/"):
			rel_dir = rel_dir.right(-1)
		if rel_dir != "":
			rel_dir += "/"
		tree += """%s<li><a href="%s%s%s.html">%s</a></li>\n""" % ["\t".repeat(depth+1),"../".repeat(path_deepth),rel_dir,title,title]
	
	# 遍历和递归子文件夹
	var sub_dirs = myFile.get_sub_dirs(dir)
	for s_dir in sub_dirs:
		if myFile.get_sub_filter_files("%s/%s" % [dir,s_dir],"md").size() != 0: # 如果文件夹下存在.md
			var sub_tree = doc_tree("%s/%s" % [dir,s_dir],depth+1,path_deepth)
			tree += """<li><span>%s</span>\n%s\n</li>\n""" % [s_dir,sub_tree]
	tree += ul_end
	return tree

# 创建单个文件夹下所有文档页面
func create_dir_doc_pages(dir:String,depth:int = 0):
	var doc_tree_html = doc_tree(index_dir,0,depth)
	# 遍历所有.md文件
	var sub_files = myFile.get_sub_filter_files(dir,"md")
	for file in sub_files:
		create_doc_page("%s/%s" % [dir,file],doc_tree_html,depth)
	# 遍历和递归子文件夹
	var sub_dirs = myFile.get_sub_dirs(dir)
	for s_dir in sub_dirs:
		create_dir_doc_pages("%s/%s" % [dir,s_dir],depth+1)
	

# 创建单个文档页面
func create_doc_page(md_path:String,doc_list:String,depth:int = 0):
	var page_title = md_path.get_file().replace(".md","")
	
	var md = myFile.loadString(md_path)
	md = md2HTML.parse(md)
	# 基础页面代码
	var html = basic_page(page_title,md,doc_list,depth)
	# 保存.html文件
	var save_path = md_path.replace(".md",".html")
	myFile.saveString(save_path,html)
	# 生成index.css文件
	var css_path = "%s/%s" % [index_dir,"index.css"]
	myFile.saveString(css_path,doc_index_css())
	# 拷贝heighlighter.js文件
	var js_from_path = "res://lib/highlight/highlight.min.js"
	var js_to_path = "%shighlight/%s" % [index_dir,"highlight.min.js"]
	# css文件
	var css_from_path = "res://lib/highlight/dark.min.css"
	var css_to_path = "%shighlight/%s" % [index_dir,"dark.min.css"]
	# 创建路径
	var dir = DirAccess.open(index_dir)
	dir.make_dir("highlight")
	# 拷贝
	myFile.copy(js_from_path,js_to_path)
	myFile.copy(css_from_path,css_to_path)
	

# 基础文档页面
func basic_page(page_title:String,content:String,doc_list:String,depth:int = 0):
	var html = """<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{page_title}</title>
	<link rel="stylesheet" href="{depth}index.css">
	<!-- 引入语法高亮 -->
	<link href="{depth}highlight/dark.min.css" rel="stylesheet">
	<script src="{depth}highlight/highlight.min.js"></script>
	<!-- 引入JQuery -->
	<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
	<script>
		$(function(){
			// 根据正文内容创建目录
			let content = "";
			$(".main h1,.main h2,.main h3").each(function(index,ele){
				$(this).before(`<a name ="ctn_${index}"></li>`)
				switch(ele.tagName){
					case "H1":
						content += `<li class="h1"><a href="#ctn_${index}">${ele.textContent}</a></li>`;
						break;
					case "H2":
						content += `<li class="h2"><a href="#ctn_${index}">${ele.textContent}</a></li>`;
						break;
					case "H3":
						content += `<li class="h3"><a href="#ctn_${index}">${ele.textContent.split("(")[0]}</a></li>`;
						break;
				}
			})
			$(".right ul").append(content);
			// 侧边栏子文件夹点击事件
			$(".doc_tree li>span").on("click",function(){
				$(this).next("ul").toggle();
			})
		})
	</script>
</head>
<body>
<!-- 左侧 -->
	<aside class="left">
		<div class="logo_box">
			<a href="#" class="logo_text">{station_title}</a>
			<span>{station_subtitle}</span>
		</div>
		<!-- 文档列表 -->
		<div class="doc_tree">
{doc_list}
		</div>

	</aside>
	<!-- 整体布局 -->
	<div class="layout center">
		<!-- 正文区 -->
		<div class="main">
{content}
		</div>
		
	</div>
	<!-- 右侧 - 文章目录区 -->
	<aside class="right">
		<h3>目录</h3>
		<ul>
			
		</ul>
	</aside>
	<!-- 实施语法高亮 -->
	<script>hljs.highlightAll();</script>
</body>
</html>"""
	html = html.replace("{page_title}",page_title).replace("{content}",content)
	html = html.replace("{doc_list}",doc_list).replace("{station_title}",station_title)
	html = html.replace("{station_subtitle}",station_subtitle)
	html = html.replace("{depth}","../".repeat(depth))
	return html

func doc_index_css():
	return """/* 清除 */
*{padding:0px;margin: 0px;}

a{text-decoration: none;color:#444;}
h1,h2,h3,h4,h5,h6{word-wrap: break-word;word-break: break-all;}


/* 变量 */
:root{
	--base-color:#0f3b52;
	--font-color:rgb(216, 216, 216);
}
/* =========================== 布局 =========================== */
.layout{width:calc(100% - 400px);margin: 0px auto;}
/* 左侧 */
.left{
	position: fixed;background-color: var(--base-color);
	top:0px;left: 0px ;width:200px;	height: 100%;
	border-right: 1px solid #ccc;
}
/* logo区 */
.logo_box{
	height:auto;
	border-bottom: 1px dashed #379b98;;
	color: var(--font-color);
	padding:10px;
}
a.logo_text{
	display: block;color:#fff;
	text-align: center;vertical-align:middle;
	font-size: 30px;
}
.logo_box span{
	display: block;color:#fff;
	text-align: center;vertical-align:middle;
	font-size: 10px;
}
/* 文档列表区 */
.doc_tree{height: 100%;width: 100%;overflow: auto;}
.doc_tree ul{padding-left: 1em;}
.doc_tree>ul{padding-left: 0em;}
.doc_tree li{list-style:none;}
.doc_tree li a{
	display: block;
	padding:5px;color:#fff;text-decoration: none;
}
.doc_tree li a:hover{
	background-color:#fff;color: #444;
}
/* 文件夹节点 */
.doc_tree li>span{
	display: block;width: 100%;
	padding:5px;
	color:#e7f247;
	border:1px solid #e7f24700;
}
.doc_tree li>span:hover{
	border-bottom:1px solid #e7f247;
}
/* 正文区 */
.main{background-color: #fff;padding: 30px;}
/* 文章标题 */
.main h1{
	margin-bottom: 10px;
}
.main h2{
	margin: 10px 0px;
	font-size: 20px;
}
.main h3{
	margin: 10px 0px;
	color: #286fae;
}
.main p{
	line-height: 1.5lh;
}
/* 右侧 - 正文目录 */
.right{
	position: fixed;top:0px;right: 0px ;
	width:180px;height: 100%;
	background-color: #fff;
	padding: 5px;border-left: 1px solid #ccc;
	
}
.right h3{margin-bottom: 10px;}
.right ul{
	overflow-y: auto;width:180px;height:calc(100% - 60px);
}
/* 滚动条 */
.right ul::-webkit-scrollbar{
	width:3px;background-color: #eee;
}
/* 滚动条 */
.right ul::-webkit-scrollbar-thumb{
	width:3px;background-color: #ccc;
}
.right li{list-style:none;line-height: 1.3lh;}
.right li a{color:#4d4d4d;}
.right li a:hover{color:rgb(0, 166, 255); border-bottom: 2px solid rgb(0, 166, 255);}
.right li.h1{font-weight: bold;}
.right li.h2{font-weight:normal;text-indent: 1em;}
.right li.h3{font-weight:normal;text-indent: 2em;font-size: smaller;}

pre{margin: 0px;padding: 0px;}
/* 行内代码 */
.inline_code{
	padding:0px 5px;margin:0px 2px;
	border:1px solid #ccc;
	background-color: #eee;
	border-radius: 5px;
	font-size: smaller;
}
/* 代码块 */
.code_block{
	padding:5px;margin: 5px;
	border:1px solid #ccc;
	background-color: #eee;
	border-radius: 5px;
	font-size: smaller;
	overflow-x: auto;
}
.code_block pre{text-wrap: wrap;}
/* 正文图片 */
.main img{
	display: block;margin: 15px auto;
	max-width: 100%;
	border-radius: 5px;
	/* border: 1px solid #ccc; */
	filter: drop-shadow(2px 4px 6px #ccc);
}
/* 正文表格 */
.main table,.main tr,.main td{
	border:1px solid #cfeded;border-spacing: 0px;
	border-collapse: collapse;padding: 6px;
	font-size: smaller;
}

.main table{
	margin:5px 0px;
	min-width: 100%;
}
/* 奇数行 */
.main tr:nth-child(odd) {
	background-color:#e5ffff;
}
/* 第一行 */
.main tr:nth-child(1) {
	text-align: center;
	font-weight: bold;
	background-color:#61abab;
}
.main tr:nth-child(1) td{
	border: 1px solid #679898;
}
/* 打印样式 */
@media print{
	/* 隐藏左右边栏 */
	.left,.right{display: none;}
	/*  */
	.layout{width:100%;}
}"""
