# ========================================================
# 名称：主场景
# 类型：tscn
# 简介：静态网站生成的主界面
# 作者：巽星石
# Godot版本：v4.1.2.stable.official [399c9dc39]
# 创建时间：2023年10月11日19:26:45
# 最后修改时间：2023年10月11日21:26:51
# ========================================================

extends Control

@onready var doc_name_txt = %docNameTxt
@onready var sub_title_txt = %subTitleTxt
@onready var root_dir_txt = %rootDirTxt
@onready var file_dialog = %FileDialog

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

# ================================= 自定义函数 =================================

# 返回指定路径的文件夹名
func get_dir_name(dir_path:String) -> String:
	var count = dir_path.get_slice_count("/")
	var idx = count - 2 if dir_path.ends_with("/") else count - 1
	return dir_path.get_slice("/",idx)
