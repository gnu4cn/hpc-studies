Account = {balance = 0}

function Account:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Account:deposit (v)
    self.balance = self.balance + v
end

function Account:withdraw (v)
    if v > self.balance then error"资金不足" end
    self.balance = self.balance - v
end
