#_aurhor_:张三香 2016.09.26

Feature:在售商品列表-商品库存和销量
	"""
		1.商品库存扣减规则：提交订单就减库存
		2.商品销量增加规则：支付订单成功后增加商品销量
		3.购买买赠商品：赠品只减库存，不计算销量
		4.成功支付订单后，'取消订单'或'退款成功'订单，商品库存增加，商品销量减少
	"""

Background:
	Given 重置'apiserver'的bdd环境
	Given jobs登录系统
	#添加支付方式
		When jobs添加支付方式
			"""
			{
				"type": "微信支付",
				"is_active": "启用"
			}
			"""
		When jobs添加支付方式
			"""
			{
				"type": "支付宝",
				"is_active": "启用"
			}
			"""
		When jobs添加支付方式
			"""
			{
				"type": "货到付款",
				"is_active": "启用"
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
			"name": "商品1",
			"is_enable_model":true,
			"model": {
				"models": {
					"黑色 S": {
						"user_code":"2111",
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "有限",
						"stocks": 10
					},
					"白色 S": {
						"user_code":"",
						"price": 10.00,
						"weight": 1.0,
						"stock_type": "有限",
						"stocks": 10
					}
				}
			},
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}]
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "商品2",
			"is_enable_model":false,
			"price": 20.00,
			"stock_type": "有限",
			"stocks": 20,
			"pay_interfaces":
				[{
					"type": "在线支付"
				},{
					"type": "货到付款"
				}]
		}
		"""
	#商品2参加买赠活动-买1赠2
	When jobs创建买赠活动
		"""
		{
			"name": "商品2买一赠二",
			"promotion_title":"",
			"start_date": "今天",
			"end_date": "1天后",
			"member_grade": "全部会员",
			"product_name": "商品2",
			"premium_products": 
				[{
					"name": "商品2",
					"count": 2
				}],
			"count": 1,
			"is_enable_cycle_mode": true
		}
		"""
	When bill关注jobs的公众号::apiserver

@product @saleingProduct
Scenario:1 生成'待支付'状态的订单-库存减少，销量不变
	#购买普通商品（10/10,0--9/8,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品1",
				"model": "黑色 S",
				"count": 1
			},{
				"name": "商品1",
				"model": "白色 S",
				"count": 2
			}]
		}
		"""
	#购买买赠商品-（20,0--17,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"002",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品2",
				"count": 1
			}]
		}
		"""
	Given jobs登录系统
	Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name": "商品2"},
				"is_enable_model":false,
				"stock":17,
				"sales":0
			},{
				"product_info":
					{
						"name": "商品1",
						"model": {
							"models": {
								"黑色 S": {
									"stock_type": "有限",
									"stocks": 9
									},
								"白色 S": {
									"stock_type": "有限",
									"stocks": 8
									}
								}
							}
					},
				"is_enable_model":true,
				"stock":"",
				"sales":0
			}]
			"""

@product @saleingProduct
Scenario:2 手机端或后台对'待支付'订单进行【取消订单】操作-库存增加，销量不变
	#购买普通商品1（10/10,0--9/8,0--10/10,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品1",
				"model": "黑色 S",
				"count": 1
			},{
				"name": "商品1",
				"model": "白色 S",
				"count": 2
			}]
		}
		"""
	#购买买赠商品2-（20,0--17,0--20,0--20,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"002",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品2",
				"count": 1
			}]
		}
		"""
	#手机端【取消订单】001
	When bill访问jobs的webapp::apiserver
	When bill取消订单'001'::apiserver
	Given jobs登录系统
	#后台【取消订单】002
	When jobs'取消订单'订单'002'
	Then jobs能获得'在售'商品列表
			"""
			[{
				"product_info":{"name": "商品2"},
				"is_enable_model":false,
				"stock":20,
				"sales":0
			},{
				"product_info":
					{
						"name": "商品1",
						"model": {
							"models": {
								"黑色 S": {
									"stock_type": "有限",
									"stocks": 10
									},
								"白色 S": {
									"stock_type": "有限",
									"stocks": 10
									}
								}
							}
					},
				"is_enable_model":true,
				"stock":"",
				"sales":0
			}]
			"""

@product @saleingProduct
Scenario:3 手机端或后台对'待支付'订单进行【支付】操作-库存不变，销量增加
	#购买普通商品1（10/10,0--9/8,0--9/8,3）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品1",
				"model": "黑色 S",
				"count": 1
			},{
				"name": "商品1",
				"model": "白色 S",
				"count": 2
			}]
		}
		"""
	When bill使用支付方式'微信支付'进行支付::apiserver
	#购买买赠商品2-（20,0--17,0--17,1），赠品只减库存，不计算销量
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"002",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品2",
				"count": 1
			}]
		}
		"""

	Given jobs登录系统
	When jobs'支付'订单'002'
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"},
			"is_enable_model":false,
			"stock":17,
			"sales":1
		},{
			"product_info":
				{
					"name": "商品1",
					"model": {
						"models": {
							"黑色 S": {
								"stock_type": "有限",
								"stocks": 9
								},
							"白色 S": {
								"stock_type": "有限",
								"stocks": 8
								}
							}
						}
				},
			"is_enable_model":true,
			"stock":"",
			"sales":3
		}]
		"""

@product @saleingProduct
Scenario:4 后台对支付成功的订单进行【取消订单】操作-库存增加，销量减少
	#购买普通商品-优惠抵扣（10/10,0--9/10,1--10/10,0）
	Given jobs登录系统
	When jobs添加优惠券规则
		"""
		[{
			"name": "全店通用券1",
			"money": 100.00,
			"limit_counts": 1,
			"count": 5,
			"start_date": "今天",
			"end_date": "1天后",
			"description":"使用说明",
			"coupon_id_prefix": "coupon1_id_"
		}]
		"""
	When jobs创建优惠券发放规则发放优惠券
		"""
		{
			"name": "全店通用券1",
			"count": 2,
			"members": ["bill"]
		}
		"""
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品1",
				"model": "黑色 S",
				"count": 1
			}],
			"coupon":"coupon1_id_1"
		}
		"""
	#购买买赠商品-货到付款（20,0--17,1--20,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"002",
			"pay_type": "货到付款",
			"products": [{
				"name": "商品2",
				"count": 1
			}]
		}
		"""

	Given jobs登录系统
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"},
			"is_enable_model":false,
			"stock":17,
			"sales":1
		},{
			"product_info":
				{
					"name": "商品1",
					"model": {
						"models": {
							"黑色 S": {
								"stock_type": "有限",
								"stocks": 9
								},
							"白色 S": {
								"stock_type": "有限",
								"stocks": 10
								}
							}
						}
				},
			"is_enable_model":true,
			"stock":"",
			"sales":1
		}]
		"""

	When jobs'取消订单'订单'001'
	When jobs'取消订单'订单'002'
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"},
			"is_enable_model":false,
			"stock":20,
			"sales":0
		},{
			"product_info":
				{
					"name": "商品1",
					"model": {
						"models": {
							"黑色 S": {
								"stock_type": "有限",
								"stocks": 10
								},
							"白色 S": {
								"stock_type": "有限",
								"stocks": 10
								}
							}
						}
				},
			"is_enable_model":true,
			"stock":"",
			"sales":0
		}]
		"""

@product @saleingProduct
Scenario:5 后台对支付成功的订单进行【退款成功】操作-库存增加，销量减少
	#购买普通商品（10/10,0--9/8,3--10/10,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"001",
			"pay_type": "微信支付",
			"products": [{
				"name": "商品1",
				"model": "黑色 S",
				"count": 1
			},{
				"name": "商品1",
				"model": "白色 S",
				"count": 2
			}]
		}
		"""
	When bill使用支付方式'微信支付'进行支付::apiserver
	#购买买赠商品-（20,0--17,1--20,0）
	When bill访问jobs的webapp::apiserver
	When bill购买jobs的商品::apiserver
		"""
		{
			"order_id":"002",
			"pay_type": "支付宝",
			"products": [{
				"name": "商品2",
				"count": 1
			}]
		}
		"""
	When bill使用支付方式'支付宝'进行支付::apiserver

	Given jobs登录系统
	#订单状态为'退款中'时，商品库存和销量不变
	When jobs'申请退款'订单'001'
	When jobs'申请退款'订单'002'
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"},
			"is_enable_model":false,
			"stock":17,
			"sales":1
		},{
			"product_info":
				{
					"name": "商品1",
					"model": {
						"models": {
							"黑色 S": {
								"stock_type": "有限",
								"stocks": 9
								},
							"白色 S": {
								"stock_type": "有限",
								"stocks": 8
								}
							}
						}
				},
			"is_enable_model":true,
			"stock":"",
			"sales":3
		}]
		"""

	#订单状态为'退款成功'时，商品库存增加，销量减少
	When jobs通过财务审核'退款成功'订单'001'
	When jobs通过财务审核'退款成功'订单'002'
	Then jobs能获得'在售'商品列表
		"""
		[{
			"product_info":{"name": "商品2"},
			"is_enable_model":false,
			"stock":20,
			"sales":0
		},{
			"product_info":
				{
					"name": "商品1",
					"model": {
						"models": {
							"黑色 S": {
								"stock_type": "有限",
								"stocks":10
								},
							"白色 S": {
								"stock_type": "有限",
								"stocks":10
								}
							}
						}
				},
			"is_enable_model":true,
			"stock":"",
			"sales":0
		}]
		"""