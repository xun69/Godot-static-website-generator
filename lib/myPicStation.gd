# ========================================================
# 名称：myPicStation
# 类型：类
# 简介：基于WebStation，创建本地图片库静态网站的类
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-15 21:29:58
# 最后修改时间：2023-08-15 21:29:58
# ========================================================
class_name myPicStation
extends WebStation

# =================================== 依赖 ===================================
var myFile = preload("res://lib/myFile.gd").new()


# =================================== 属性 ===================================
# 网站目录结构
# index_dir -- 网站根目录
#     img_root_dir -- 图片根目录名 -- 将检测其一级子文件夹用于生成分类
#         sub_dir  -- 图片分类目录
#              dir -- 具体的图片集目录 
var station_title:String = ""          # 网站名
var index_dir:String     = ""          # 网站根目录
var img_root_dir_name:String  = ""     # 图片根目录名 -- 将以此目录为一级目录进行图片库生成
var img_root_dir:String  = ""          # 图片根目录的完整路径

# 顶部导航菜单
var pages_link = [
	["主页","index.html"], # 返回主页
]

# 常用网址
var links = []

# =================================== 实例化 ===================================
func _init(m_station_title:String,m_index_dir:String,m_img_root_dir_name:String,m_links:Array) -> void:
	# 设置相关属性和路径
	station_title = m_station_title
	index_dir = m_index_dir
	img_root_dir_name = m_img_root_dir_name
	links = m_links
	# 生成相关路径
	img_root_dir = "%s/%s" % [index_dir,img_root_dir_name] # 图片根目录的完整路径

# 生成网站
func create_station() -> void:
	# 生成图片根目录下所有子文件夹的瀑布流页面
	create_img_dirs_pages()
	# 生成主页
	create_index_page()

# =================================== 图片浏览页面生成 ===================================
# 生成指定图片根目录下所有子文件夹中图片的瀑布流页面
func create_img_dirs_pages():
	# 获取 图片根目录 - 子文件夹 列表
	var gup_dirs = myFile.get_sub_dirs(img_root_dir)
	# 遍历一级子文件夹 - 图片分类
	for gup_dir in gup_dirs:
		create_group_dir_page("%s/%s" % [img_root_dir,gup_dir])
		
# 创建单个分类文件夹下所有子文件夹的页面
func create_group_dir_page(gup_dir:String):
	# 获取图片分组目录的子文件夹列表
	var sub_dirs = myFile.get_sub_dirs(gup_dir)
	# 遍历一级子文件夹 - 具体图片文件夹
	for dir in sub_dirs:
		var img_dir = "%s/%s" % [gup_dir,dir]        # 具体的图片子文件夹
		var url_base_dir = "%s/%s" % [gup_dir,dir] # 网页中图片使用的相对路径
		var html_save_path = "%s/%s.html" % [img_root_dir,dir] # 网页保存路径
		# 生成图片页面 - （图片页面标题,图片根目录,html页面保存路径,网页中图片使用的基础相对路径）
		create_img_list_page(dir,img_dir,html_save_path,url_base_dir,2)

# 创建图片页面
# （图片页面标题,图片根目录,html页面保存路径,网页中使用的基础相对路径）
func create_img_list_page(page_title:String,img_dir_path:String,save_path:String,url_base_dir:String,cols=2):
	# 1.创建页面结构代码
	var menu = fix_top_menu(pages_link,page_title) # 顶部导航菜单
	var img_toolbar = img_toolbar() # 图片列表工具栏
	var main = img_list(img_dir_path,url_base_dir,cols) # 图片列表
	var center = center_1000px(main,true) # 居中布局
	var html = page(page_title,menu + img_toolbar + center) # 整体页面框架
	# 修正css引用路径
	html = html.replace("<link rel=\"stylesheet\" href=\"index.css\">","<link rel=\"stylesheet\" href=\"..\\index.css\">")
	# 修正主页链接路径
	html = html.replace("\"index.html\"","\"..\\index.html\"")
	# 2.保存网页
	myFile.saveString(save_path,html)


# =================================== 创建首页 ===================================
# 创建首页
func create_index_page():
	# ------------------ 1.创建图片分组列表
	
	var main = ""
	# 获取 图片根目录 - 子文件夹 列表
	var gup_dirs = myFile.get_sub_dirs(img_root_dir)
	# 遍历一级子文件夹 - 图片分类
	for gup_dir in gup_dirs:
		var card_links_arr = []
		# 获取图片分组目录的子文件夹列表
		var gup_dir_path = "%s/%s" % [img_root_dir,gup_dir]
		var sub_dirs = myFile.get_sub_dirs(gup_dir_path)
		# 遍历一级子文件夹 - 具体图片文件夹
		for dir in sub_dirs:
			var img_dir = "%s/%s" % [gup_dir_path,dir]        # 具体的图片子文件夹
			img_dir = img_dir.replace("/","\\")
			# 获取封面
			var face:String = ""
			var imgs:PackedStringArray = []
			for type in IMG_TYPES:
				var files = myFile.get_sub_filter_files(img_dir,type)
				imgs.append_array(files)
			face = imgs[0] if imgs.size() >0 else ""
			
			card_links_arr.append([dir, "%s/%s.html" % [img_root_dir_name,dir],img_dir + "/" + face])
		main += card_link_lists(gup_dir,card_links_arr) # 卡片列表
	# 获取网站根目录下已经生成的所有html文件名
	


	var menu = fix_top_menu([["主页","index.html"]],station_title)
	
	# 常用网址
	var urls = link_list(links)
	var right = title_panel("常用网址",urls)
	
	var layout = layout_main_right(main,right)

	var center = center_1000px(layout,true)

	var html = page(station_title,menu + center)

	# 生成index.css
	var css_path = "%s/index.css" % index_dir
	myFile.saveString(css_path,index_css())
	
	# 生成index.html
	var save_path = "%s/index.html" % index_dir
	myFile.saveString(save_path,html)
	myFile.shell_open(save_path)
