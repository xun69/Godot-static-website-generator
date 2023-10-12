# ========================================================
# 名称：主场景
# 类型：tscn
# 简介：静态网站生成的主界面
# 作者：巽星石
# Godot版本：v4.1.2.stable.official [399c9dc39]
# 创建时间：2023年10月11日19:26:45
# 最后修改时间：2023年10月12日21:55:28
# ========================================================

extends Control

# md文档  ==> html文档 - 表单元素
@onready var doc_name_txt = %docNameTxt
@onready var sub_title_txt = %subTitleTxt
@onready var root_dir_txt = %rootDirTxt
@onready var file_dialog = %FileDialog
# 本地图片文件夹 ==> 图片库静态站 - 表单元素
@onready var album_name_txt = %albumNameTxt
@onready var alnum_root_dir_txt = %alnumRootDirTxt
@onready var img_dir_name_txt = %imgDirNameTxt
@onready var links_txt = %linksTxt
# Godot项目所有.gd文件 ==> .md文档 - 表单元素
@onready var gd_root_dir_txt = %gdRootDirTxt
@onready var gd_2_md_root_dir_txt = %gd2mdRootDirTxt


# ================================= 信号处理 ================================= 

# 设定文档根目录
func _on_set_dir_btn_pressed():
	# 打开文件对话框
	file_dialog.popup_centered_ratio()
	# 选中文件夹后
	file_dialog.connect("dir_selected",func(dir):
		root_dir_txt.text = dir
	)


# 生成文档
func _on_create_doc_btn_pressed():
	# 文档标题，副标题，根目录
	var doc = myDocStation.new(doc_name_txt.text,sub_title_txt.text,root_dir_txt.text)
	doc.create_station()

# 生成图片库
func _on_create_album_btn_pressed():
	# 常用网址
	var links = get_links()
	
	var station = myPicStation.new(album_name_txt.text,alnum_root_dir_txt.text,img_dir_name_txt.text,links)
	station.create_station()

# 设定图库根目录
func _on_album_set_dir_btn_pressed():
	# 打开文件对话框
	file_dialog.popup_centered_ratio()
	# 选中文件夹后
	file_dialog.connect("dir_selected",func(dir):
		alnum_root_dir_txt.text = dir
	)

# 选择Godot项目根目录
func _on_gd_set_dir_btn_pressed():
	# 打开文件对话框
	file_dialog.popup_centered_ratio()
	# 选中文件夹后
	file_dialog.connect("dir_selected",func(dir):
		gd_root_dir_txt.text = dir
	)

# 选择Godot项目导出MD文档根目录
func _on_gd_2_md_set_dir_btn_pressed():
	# 打开文件对话框
	file_dialog.popup_centered_ratio()
	# 选中文件夹后
	file_dialog.connect("dir_selected",func(dir):
		gd_2_md_root_dir_txt.text = dir
	)

# 基于Godot项目生成.md文档
func _on_create_md_doc_btn_pressed():
	var md = gd2MD.new(gd_root_dir_txt.text,gd_2_md_root_dir_txt.text)
	md.do_it()


# ================================= 自定义函数 =================================

# 返回指定路径的文件夹名
func get_dir_name(dir_path:String) -> String:
	var count = dir_path.get_slice_count("/")
	var idx = count - 2 if dir_path.ends_with("/") else count - 1
	return dir_path.get_slice("/",idx)

# 根据输入的链接字符串生成并返回可以使用的二维数组结构
func get_links() -> Array: 
	var arr:Array = []
	if links_txt.text == "":
		return arr
	var links_str:String = links_txt.text
	for link in links_str.split("\n"):
		arr.append(link.split(","))
	return arr


