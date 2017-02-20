#editor: 张三香 2016.08.15

Feature: 删除商品规格
	"""
		删除商品规格（无商品使用该规格），则该规格在规格列表中消失
	"""

Background:
	Given jobs登录系统
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
				"image": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	When jobs添加商品规格
		"""
		{
			"name": "尺寸",
			"type": "文本",
			"values": [{
				"name": "M"
			},{
				"name": "S"
			}]
		}
		"""

@product @module
Scenario:1 删除商品规格
	Given jobs登录系统
	When jobs删除商品规格'颜色'
	Then jobs能获取商品规格列表
		"""
		[{
			"name": "尺寸"
		}]
		"""


