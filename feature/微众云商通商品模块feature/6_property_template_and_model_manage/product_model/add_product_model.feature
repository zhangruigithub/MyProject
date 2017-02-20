#editor:张三香 2015.10.14

Feature: 添加商品规格
	"""
		1、规格名不允许为空，校验提示'内容不能为空'
		2、添加规格时，允许添加规格信息为空的规格（只填写规格名称，不添加规格值）
		3、规格的显示样式：文本、图片，两种样式可以任意切换
		4、添加规格时默认选中'文本'样式
		5、规格名称保存成功后，点击'+'则弹出'创建规格名'弹窗，弹窗可以输入文本（必填）和上传图片
		6、规格列表显示顺序:创建时间正序显示
	"""

@product @module
Scenario:1 添加商品规格
	1.jobs添加空的规格（文本和图片类型）
	2.jobs添加非空的规格（文本和图片类型）

	Given jobs登录系统
	When jobs添加商品规格
		"""
		{
			"name": "文本空规格",
			"type": "文本",
			"values": []
		}
		"""
	Then jobs能获取商品规格'文本空规格'
		"""
		{
			"name": "文本空规格",
			"type": "文本",
			"values": []
		}
		"""
	When jobs添加商品规格
		"""
		{
			"name": "图片空规格",
			"type": "图片",
			"values": []
		}
		"""
	Then jobs能获取商品规格'图片空规格'
		"""
		{
			"name": "图片空规格",
			"type": "图片",
			"values": []
		}
		"""
	When jobs添加商品规格
		"""
		{
			"name": "颜色",
			"type": "图片",
			"values": [{
				"name": "黑色",
				"image": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"name": "白色",
				"image": ""
			}]
		}
		"""
	Then jobs能获取商品规格'颜色'
		"""
		{
			"name": "颜色",
			"type": "图片",
			"values": [{
				"name": "黑色",
				"image": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"name": "白色",
				"image": ""
			}]
		}
		"""
	When jobs添加商品规格
		"""
		{
			"name": "尺寸",
			"type": "文本",
			"values": [{
				"name": "M",
				"image":""
			},{
				"name": "S",
				"image": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	Then jobs能获取商品规格'尺寸'
		"""
		{
			"name": "尺寸",
			"type": "文本",
			"values": [{
				"name": "M",
				"image":""
			},{
				"name": "S",
				"image": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	And jobs能获取商品规格列表
		"""
		[{
			"name": "文本空规格",
			"type": "文本",
			"values": []
		},{
			"name": "图片空规格",
			"type": "图片",
			"values": []
		},{
			"name": "颜色",
			"type": "图片",
			"values": [{
				"name": "黑色",
				"image": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"name": "白色",
				"image": ""
			}]
		},{
			"name": "尺寸",
			"type": "文本",
			"values": [{
				"name": "M",
				"image":""
			},{
				"name": "S",
				"image": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}]
		"""


