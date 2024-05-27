Account = {balance = 0,
    withdraw = function (self, v)
        self.balance = self.balance - v
    end
}

function Account:deposit (v)
    self.balance = self.balance + v
end

function Account:new (o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end
