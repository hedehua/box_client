local aiConfig = {
        {
                id = 1,
                interval = 2,          -- 600
              
                fov     = 1800,          -- 视野范围
                panicDist = 50,        -- 低于该距离会远离障碍物
                safeDist = 20,         -- 逃逸过程中超过该距离会进入休闲

                maxPercent = 100,       -- 决定是百分比/千分比/万分比
                activity= 70,           -- 活跃度，用于反应idle状态是否频繁调整朝向
                search  = 80,          -- 搜索  休闲过程中 概率搜索（反应贪玩程度）
                pursue  = 50,          -- 追击（寻找靠近攻击源的方向）
                pick    = 80,          -- 拾取掉落
                escape  = 60,           -- 逃跑（寻找远离攻击源的方向）

	},

}

return aiConfig