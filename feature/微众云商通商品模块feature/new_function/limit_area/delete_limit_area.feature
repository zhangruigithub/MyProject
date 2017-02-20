# __author__ : "田丰敏"

Feature:删除限定区域配置

Background:
	Given jobs登录系统

	When jobs添加限定区域配置
		"""
		{
			"name": "禁售地区",
			"limit_area": [{
				"area": "直辖市",
				"province": ["北京市","天津市"]
			}]
		}
		"""
	When jobs添加限定区域配置
		"""
		{
			"name": "仅售地区",
			"limit_area": [{
				"area": "西北-西南",
				"province": "陕西省",
				"city": ["西安市"]
			}]
		}
		"""
	When jobs添加限定区域配置
		"""
		{
			"name": "仅售地区1",
			"limit_area": [{
				"area": "直辖市",
				"province": ["北京市","天津市"]
			},{
				"area": "华北-东北",
				"province": "河北省",
				"city": ["石家庄市","唐山市","沧州市"]
			},{
				"area": "西北-西南",
				"province": "陕西省",
				"city": ["西安市"]
			},{
				"area": "华北-东北",
				"province": "山西省",
				"city": ["太原市","大同市","阳泉市","长治市","晋城市","朔州市","晋中市","运城市","忻州市","临汾市","吕梁市"]
			}]
		}
		"""

@mall2 @product_limit_area @eugene
Scenario:1 删除未使用的限定区域配置
	Jobs删除"限定区域配置"
	1. jobs能获得删除后的限定区域列表

	Given jobs登录系统

	

	When jobs删除'仅售地区'限定区域配置

	Then jobs能获得限定区域列表
		"""
		[{
			"name": "仅售地区1",
			"limit_area": [{
				"area": "直辖市",
				"province": ["北京市","天津市"]
			},{
				"area": "华北-东北",
				"province": "河北省",
				"city": ["石家庄市","唐山市","沧州市"]
			},{
				"area": "华北-东北",
				"province": "山西省",
				"city": ["太原市","大同市","阳泉市","长治市","晋城市","朔州市","晋中市","运城市","忻州市","临汾市","吕梁市"]
			},{
				"area": "西北-西南",
				"province": "陕西省",
				"city": ["西安市"]
			}],
			"actions": ["修改","删除"]
		},{
			"name": "禁售地区",
			"limit_area": [{
				"area": "直辖市",
				"province": ["北京市","天津市"]
			}],
			"actions": ["修改","删除"]
		}]
		"""
	When jobs删除'仅售地区1'限定区域配置
	When jobs删除'禁售地区'限定区域配置

	Then jobs能获得限定区域列表
		"""
		[]
		"""

Scenario:2 删除使用中的限定区域
	删除使用中的限定区域后，商品详情页的限定类型会变成'无限制'
	Given jobs登录系统
	When jobs添加商品
		"""
		{
			"name": "禁售商品1",
			"price": 10.00,
			"limit_zone_type":"禁售地区",
			"limit_zone":"禁售地区"
		}
		"""
	When jobs添加商品
		"""
		{
			"name": "仅售商品2",
			"price": 20.00,
			"limit_zone_type":"仅售地区",
			"limit_zone":"禁售地区"
		}
		"""
	When jobs删除'禁售地区'限定区域配置
	Then jobs能获得限定区域列表
		"""
		[{
			"name": "仅售地区1"
		},{
			"name": "仅售地区"
		}]
		"""
	Then jobs能获取商品'禁售商品1'
		"""
		{
			"name": "禁售商品1",
			"limit_zone_type":"无限制"
		}
		"""
	Then jobs能获取商品'仅售商品2'
		"""
		{
			"name": "仅售商品2",
			"limit_zone_type":"无限制"
		}
		"""