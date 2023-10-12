# ========================================================
# 名称：gd2md
# 类型：类
# 简介：提供将目标文件夹下.gd文件转化为保存目录下.md的功能
# 作者：巽星石
# Godot版本：4.1.1-stable (official)
# 创建时间：2023-08-27 20:35:13
# 最后修改时间：2023年8月27日20:57:22
# ========================================================
class_name gd2MD
# =================================== 属性 ===================================
var _target_dir:String # 目标路径，也就是.gd文件存在的根目录
var _save_dir:String   # 存储路径,也就是生成.md文件的根目录
var pojName:String     # 根目录名

# =================================== 依赖 ===================================
var myFile = preload("res://lib/myFile.gd").new()

# =================================== 实例化 ===================================
func _init(target_dir:String,save_dir:String):
	_target_dir = target_dir
	_save_dir = save_dir
	pojName= get_dir_name(_save_dir)
	
# =================================== 方法 ===================================
# 主要方法
func do_it():
	# 生成.md文件
	gdTomd()
	# 生成index.md
	create_index()


# 将_target_dir及其子文件夹下所有.gd文件转化为.md文件并存储到_save_dir
func gdTomd(target_dir:String = _target_dir,save_dir:String = _save_dir) -> void:
	# 1.将GD转化为MD
	for gd in myFile.get_sub_filter_files(target_dir,"gd"):
		var title = gd.replace(".gd","")
		var gdFile = "%s/%s" % [target_dir,gd]
		var mdFile = "%s/%s.md" % [save_dir,title]
		var code = myFile.loadString(gdFile)
		var md = """# {title}
```swift
{code}
```""".replace("{title}",title).replace("{code}",code)
		myFile.saveString(mdFile,md)
	
	# 2.遍历子文件夹
	for dir in myFile.get_sub_dirs(target_dir):
		# 创建文件夹
		myFile.dir_exists_or_create("%s/%s" % [save_dir,dir])
		gdTomd("%s/%s" % [target_dir,dir],"%s/%s" % [save_dir,dir]) # 递归


# =================================== 次要方法，供主要方法调用 ===================================
# 生成主页index.md
func create_index():
	var TOC = mdsTOC(_save_dir)
	var md = """# {pojName}

## 概述

概述在这里。

## 目录

{TOC}
""".replace("{pojName}",pojName).replace("{TOC}",TOC)
	var index_save_path = "%s/index.md" % _save_dir
	myFile.saveString(index_save_path,md)
	myFile.shell_open(index_save_path)

# 返回指定路径的文件夹名
func get_dir_name(dir_path:String) -> String:
	var count = dir_path.get_slice_count("/")
	var idx = count - 2 if dir_path.ends_with("/") else count - 1
	return dir_path.get_slice("/",idx)

# 检测_save_dir目录下所有.md文件，递归生成目录
func mdsTOC(save_dir:String,base_dir:String ="",deepth:int = 0) -> String:
	if base_dir == "":
		base_dir = save_dir
	
	var toc_code:String # 保存完整的返回字符串
	
	var relative_path = save_dir.replace(base_dir,".") # 相对路径
	if relative_path.begins_with("/"):
		relative_path = relative_path.right(-1)
	var dir_link = "%s- %s\n" % ["\t".repeat(deepth),relative_path if deepth != 0 else pojName] # 子文件夹目录
	toc_code += dir_link
	# 遍历所有.md文件 - 生成链接
	for file in myFile.get_sub_filter_files(save_dir,"md"):
		var title = file.replace(".md","")       # 链接标题
		var src = "%s/%s" % [relative_path,file] # 链接
		# 完整的.md文件链接
		var md_link = "%s- [%s](%s)\n" % ["\t".repeat(deepth+1),title,src]
		toc_code += md_link
	# 递归子文件夹
	for dir in myFile.get_sub_dirs(save_dir):
		if dir not in [".godot"] and not dir.ends_with(".assets"):
			toc_code += mdsTOC("%s/%s" % [save_dir,dir],base_dir,deepth+1)
	return toc_code
