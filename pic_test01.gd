
# 图片网站生成  - 测试

@tool
extends EditorScript

# 常用网址
var links = [
	["百度","https://www.baidu.com"]
]


func _run():
	var station = myPicStation.new("主页标题","网站根目录","图片文件夹名",links)
	station.create_station()
