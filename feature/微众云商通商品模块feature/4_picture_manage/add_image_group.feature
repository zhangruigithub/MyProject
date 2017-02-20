#editor:王丽 2015.10.14
#editor:三香 2016.05.15

Feature: 添加图片分组
	"""
		1.图片分组名称不允许为空，校验提示'请输入18位以内的字符，且不为空'
		2.图片分组列表按照添加图片分组添加时间正序排列
		3.允许添加空的图片分组（即:图片分组中不添加任何图片）
		4.列表中只显示前六张图，多出的，在详情中全部显示出来（BDD是否能验证？）
	"""

@product @picture
Scenario:1 添加图片分组
	Jobs添加图片分组后
	1. jobs能获取图片分组
	2. bill不能获取图片分组
	3. 多个图片分组按添加顺序排列

	Given jobs登录系统
	When jobs添加图片分组
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	And jobs添加图片分组
		"""
		{
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	And jobs添加图片分组
		"""
		{
			"name": "图片分组3",
			"images": []
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}, {
			"name": "图片分组2",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}, {
			"name": "图片分组3",
			"images": []
		}]
		"""
	And jobs能获取图片分组'图片分组1'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""
	And jobs能获取图片分组'图片分组2'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			}]
		}
		"""
	And jobs能获取图片分组'图片分组3'
		"""
		{
			"images": []
		}
		"""
	Given bill登录系统
	Then bill能获取图片分组列表
		"""
		[]
		"""

#editor:李娜 2016.09.05
@product @picture
Scenario:2 添加商品图片
	Given jobs登录系统
	When jobs添加图片分组
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			}]
		}
		"""

	And jobs添加商品图片
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou4.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou5.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou6.jpg"
			}]
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou4.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou5.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou6.jpg"
			}]
		}]
		"""
	And jobs能获取图片分组'图片分组1'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou4.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou5.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou6.jpg"
			}]
		}
		"""
	When jobs添加商品图片
		"""
		{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou7.jpg"
			}]
		}
		"""
	Then jobs能获取图片分组列表
		"""
		[{
			"name": "图片分组1",
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou4.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou5.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou6.jpg"
			}]
		}]
		"""
	And jobs能获取图片分组'图片分组1'
		"""
		{
			"images": [{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou4.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou5.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou6.jpg"
			},{
				"path": "/standard_static/test_resource_img/hangzhou7.jpg"
			}]
		}
		"""