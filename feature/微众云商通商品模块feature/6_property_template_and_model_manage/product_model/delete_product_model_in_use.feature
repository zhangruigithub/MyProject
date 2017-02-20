#author: 张三香
#editor: 张三香 2015.10.14
#editor: 张三香 2016.08.15

Feature:删除规格或规格值对商品的影响
	"""
		1.删除规格或规格值会导致使用该规格或规格值的商品下架:
			a.若该商品开始创建时就是多规格商品，则商品下架且商品价格、库存、重量均变为0
			b.若该商品是由无规格修改成的多规格商品，则商品下架且库存变为0,保留无规格时的价格和重量
		2.创建如下商品数据
			#无规格:没有规格的商品
			#商品1：S
			#商品2：黑,白
			#商品3：黑M  白M
			#商品4: 白S
			#商品5：黑M 黑S 白M 白S
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
			}, {
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
	When jobs添加商品
		"""
		{
			"name":"无规格",
			"is_enable_model":false,
			"price": 10.00,
			"weight": 10.0,
			"stock_type": "有限",
			"stocks": 10
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品1",
			"is_enable_model":true,
			"model": {
				"models": {
					"S": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
						}
					}
				}
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品2",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
					"白色": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品3",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
					"白色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品4",
			"is_enable_model":true,
			"model": {
				"models": {
					"白色 S": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品5",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 S": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
					"白色 S": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
					"黑色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
						"白色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs批量上架商品
		"""
		["无规格","商品1","商品2","商品3","商品4","商品5"]
		"""

@product @module   
Scenario:1 删除商品规格值'S'
	Given jobs登录系统
	When jobs删除商品规格'尺寸'的规格值'S'
	Then jobs能获取商品'商品1'
		"""
		{
			"name": "商品1",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品4'
		"""
		{
			"name": "商品4",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品5'
		"""
		{
			"name": "商品5",
			"status": "待售",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					},
					"白色 M": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""

@product @module   
Scenario:2 删除商品规格'颜色'
	Given jobs登录系统
	When jobs删除商品规格'颜色'
	Then jobs能获取商品'商品2'
		"""
		{
			"name":"商品2",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品3'
		"""
		{
			"name":"商品3",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品4'
		"""
		{
			"name":"商品4",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品5'
		"""
		{
			"name":"商品5",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""

@product @module   
Scenario:3 删除商品规格值 '黑'和 'M'
	Given jobs登录系统
	When jobs删除商品规格'颜色'的规格值'黑色'
	When jobs删除商品规格'尺寸'的规格值'M'
	Then jobs能获取商品'商品2'
		"""
		{
			"name":"商品2",
			"status": "待售",
			"is_enable_model":true,
			"model": {
				"models": {
					"白色": {
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'商品3'
		"""
		{
			"name":"商品3",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	Then jobs能获取商品'商品5'
		"""
		{
			"name": "商品5",
			"status": "待售",
			"is_enable_model": true,
			"model": {
				"models": {
					"白色 S": {
						"price":10.00,
						"weight": 1.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""

@product @module   
Scenario:4 删除商品规格'颜色'和'尺寸'
	Given jobs登录系统
	When jobs删除商品规格'颜色'
	And jobs删除商品规格'尺寸'
	Then jobs能获取商品'商品1'
		"""
		{
			"name":"商品1",
			"status": "待售",
			"is_enable_model": false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品2'
		"""
		{
			"name":"商品2",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品3'
		"""
		{
			"name":"商品3",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品4'
		"""
		{
			"name":"商品4",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""
	And jobs能获取商品'商品5'
		"""
		{
			"name":"商品5",
			"status": "待售",
			"is_enable_model":false,
			"price": 0.00,
			"weight": 0.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""

@product @module   
Scenario:5 无规格商品修改成多规格后,再删除商品规格
	#无规格商品修改成多规格后，删除商品规格会导致:
	#商品下架,库存变为0,会保留无规格时的价格和重量

	Given jobs登录系统
	When jobs更新商品'无规格'
		"""
		{
			"name":"无规格",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					},
					"白色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"status": "在售",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					},
					"白色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs删除商品规格'颜色'
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"status": "待售",
			"is_enable_model":false,
			"price": 10.00,
			"weight": 10.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""

@product @module   
Scenario:6 无规格商品修改成多规格后,再删除商品规格值
	#无规格商品修改成多规格后,再删除商品规格值会导致:
	#商品下架,库存变为0,会保留无规格时的价格和重量

	Given jobs登录系统
	When jobs更新商品'无规格'
		"""
		{
			"name":"无规格",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs删除商品规格'颜色'的规格值'黑色'
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"status": "待售",
			"is_enable_model":false,
			"price": 10.00,
			"weight": 10.0,
			"stock_type": "有限",
			"stocks": 0
		}
		"""

@product @module   
Scenario:7 无规格商品修改成多规格后(2个规格),再删除商品规格值
	#无规格商品修改成多规格后，删除商品规格会导致:
	#保留一个商品规格展现

	Given jobs登录系统
	When jobs更新商品'无规格'
		"""
		{
			"name":"无规格",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					},
					"白色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"status": "在售",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					},
					"白色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""
	When jobs删除商品规格'颜色'的规格值'黑色'
	Then jobs能获取商品'无规格'
		"""
		{
			"name":"无规格",
			"is_enable_model":true,
			"model": {
				"models": {
					"白色": {
						"price": 11.00,
						"weight": 11.0,
						"stock_type": "无限"
					}
				}
			}
		}
		"""