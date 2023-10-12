# ========================================================
# 名称：myDocStation
# 类型：类
# 简介：用于生成多个markdown页面组成的HTML文档
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-26 14:42:44
# 最后修改时间：2023年10月12日22:54:31
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
	var html = myFile.loadString("res://lib/tmps/docStation/base.html")
	html = html.replace("{page_title}",page_title).replace("{content}",content)
	html = html.replace("{doc_list}",doc_list).replace("{station_title}",station_title)
	html = html.replace("{station_subtitle}",station_subtitle)
	html = html.replace("{depth}","../".repeat(depth))
	return html

func doc_index_css():
	return myFile.loadString("res://lib/tmps/docStation/index.css")
