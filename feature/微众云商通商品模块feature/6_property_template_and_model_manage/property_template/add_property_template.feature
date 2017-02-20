#author:张三香 2016.08.05

Feature: 创建属性模板
	"""
		1.属性模板名称不允许为空，校验提示'请输入18位以内的字符，且不为空'
		2.点击属性的【添加】按钮后:
			'属性'必填，校验提示'请输入长度在1到15直接的字符串'
			'描述'必填，校验提示'请输入长度在1到255直接的字符串'
			'操作'显示【删除】按钮，可删除该条属性
		3.每个属性模板中允许添加多条属性信息
		4.属性模板列表顺序，按照属性模板添加时间正序显示
		5.允许添加属性为空的属性模板
	"""

@product @property
Scenario:1 创建属性模板
	1.jobs创建空的属性模板
	2.jobs创建非空的属性模板

	Given jobs登录系统
	When jobs添加属性模板
		"""
		{
			"name": "空属性模板1",
			"properties": []
		}
		"""
	When jobs添加属性模板
		"""
		{
			"name": "非空属性模板2",
			"properties":
				[{
					"name": "产地",
					"description": "产地描述"
				},{
					"name": "材质",
					"description": "皮革"
				}]
		}
		"""
	Then jobs能获取属性模板列表
		"""
		[{
			"name": "空属性模板1",
			"properties":[]
		},{
			"name": "非空属性模板2",
			"properties":
				[{
					"name": "产地",
					"description": "产地描述"
				},{
					"name": "材质",
					"description": "皮革"
				}]
		}]
		"""
	