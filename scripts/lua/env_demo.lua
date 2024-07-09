-- 将当前环境修改未一个新的空表
_ENV = {}
a = 1           -- 在 _ENV 中创建出一个字段
print(a)
    --> stdina:4: attempt to call a nil value (global 'print')
