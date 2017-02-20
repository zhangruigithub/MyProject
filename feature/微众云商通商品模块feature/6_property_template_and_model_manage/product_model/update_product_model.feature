#editor:张三香 2016.08.15

Feature: 更新商品规格
	"""
		1、修改规格名
		2、增加规格值、删除规格值
		3、修改规格的显示样式（文本改成图片，图片改成文本）
			a:文本-规格值+图片，修改样式为'图片'后，规格值则显示对应文本的图片
			b:文本-规格值，修改样式为'图片'后，规格值仍则显示文本
			c:图片-规格值+图片，修改样式为'文本'后，规格值则显示对应图片的文本
			d:图片-规格值，修改样式为'文本'后，规格值仍显示文本
		4、更新商品正在使用的规格（规格名、规格值）时，商品中的规格信息也随着变化
	"""

Background:
	Given 重置'apiserver'的bdd环境
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
				"name": "M",
				"image":""
			},{
				"name": "S",
				"image":"/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""

@product @module
Scenario:1 更新商品规格信息（无商品使用该规格）
	Jobs更新商品规格后, 更新包括：
		1.修改规格名
		2.增加、删除规格值
		3.修改规格的显示样式

	Given jobs登录系统
	#图片修改成文本
	When jobs更新商品规格'颜色'的规格名为
		"""
		{
			"name":"颜色*"
		}
		"""
	When jobs更新商品规格'颜色*'的规格值'黑色'为
		"""
		{
			"values":
			{
				"name": "黑色1",
				"image": ""
			}
		}
		"""
	When jobs向商品规格'颜色*'中增加规格值
		"""
		{
			"values":
				{
					"name": "黄色",
					"image": "/standard_static/test_resource_img/hangzhou3.jpg"
				}
		}
		"""
	When jobs删除商品规格'颜色*'的规格值'白色'
	Then jobs能获取商品规格'颜色*'
		"""
		{
			"name": "颜色*",
			"type": "图片",
			"values": [{
				"name": "黑色1",
				"image":""
			},{
				"name": "黄色",
				"image": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	When jobs更新商品规格'颜色*'的类型为
		"""
		{
			"type": "文本"
		}
		"""
	Then jobs能获取商品规格'颜色*'
		"""
		{
			"name": "颜色*",
			"type": "文本",
			"values": [{
				"name": "黑色1",
				"image":""
			},{
				"name": "黄色",
				"image": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	#文本修改成图片
	When jobs更新商品规格'尺寸'的类型为
		"""
		{
			"type": "图片"
		}
		"""
	When jobs更新商品规格'尺寸'的规格值'M'为
		"""
		{
			"values":
				{
					"name": "M1",
					"image": "/standard_static/test_resource_img/hangzhou1.jpg"
				}
		}
		"""
	Then jobs能获取商品规格列表
		"""
		[{
			"name": "颜色*",
			"type": "文本",
			"values": [{
				"name": "黑色1"
			},{
				"name": "黄色"
			}]
		},{
			"name": "尺寸",
			"type": "图片",
			"values": [{
				"name": "M1",
				"image":"/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"name": "S",
				"image":"/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}]
		"""

@product @module
Scenario:2 更新商品规格信息（有商品使用该规格）
	#修改商品正在使用的规格信息后，商品对应的规格信息也会随之变化
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "多规格商品1",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 S": {
						"price": 10.00,
						"weight": 3.1,
						"stock_type": "有限",
						"stocks": 3
					},
					"白色 S": {
						"price": 9.10,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs批量上架商品
		"""
		["多规格商品1"]
		"""
	#修改正在使用的规格值的名称
	When jobs更新商品规格'颜色'的规格值'黑色'为
		"""
		{
			"values":
			{
				"name": "黑色1",
				"image": "/standard_static/test_resource_img/hangzhou1.jpg"
			}
		}
		"""
	When jobs更新商品规格'尺寸'的规格值'S'为
		"""
		{
			"values":
			{
				"name": "S1",
				"image": ""
			}
		}
		"""
	#修改正在使用的规格名称（这部分前端进行校验）
	When jobs更新商品规格'颜色'的规格名为
		"""
		{
			"name":"颜色*"
		}
		"""
	Then jobs能获取商品'多规格商品1'
		"""
		{
			"name": "多规格商品1",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色1 S1": {
						"price": 10.00,
						"weight": 3.1,
						"stock_type": "有限",
						"stocks": 3
					},
					"白色 S1": {
						"price": 9.10,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	#修改规格信息（规格名称、规格值名称）后，手机端商品详情页校验
	When bill关注jobs的公众号::apiserver
	When bill访问jobs的webapp::apiserver
	Then bill能获取手机端商品'多规格商品1'::apiserver
		"""
		{
			"name": "多规格商品1",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色1 S1": {
						"price": 10.00
					},
					"白色 S1": {
						"price": 9.10
					}
				}
			}
		}
		"""