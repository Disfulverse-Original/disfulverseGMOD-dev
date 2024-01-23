----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
----- DO NOT TOUCH THAT -----
local function GetCurrentLuaFile()
    local source = debug.getinfo(2, "S").source
    if source:sub(1,1) == "@" then
        return source:sub(2)
    else
        error("Caller was not defined in a file", 2)
    end
end
 
local function GetCurrentLuaFileName()
    local luafile = GetCurrentLuaFile()
 
    local split = string.Split( luafile, "/")
 
    return split[#split]
end
 
local filename_wl = GetCurrentLuaFileName()
local filename = string.Replace(filename_wl, ".lua")
-------------------------------
 
CLOTHESMOD.Config.Sentences[1][filename] = "添加"
CLOTHESMOD.Config.Sentences[2][filename] = "图像编辑"
CLOTHESMOD.Config.Sentences[3][filename] = "图像"
CLOTHESMOD.Config.Sentences[4][filename] = "删除"
CLOTHESMOD.Config.Sentences[5][filename] = "文本编辑"
CLOTHESMOD.Config.Sentences[6][filename] = "文本"
CLOTHESMOD.Config.Sentences[7][filename] = "选择你的T桖"
CLOTHESMOD.Config.Sentences[8][filename] = "创建你的T桖"
CLOTHESMOD.Config.Sentences[9][filename] = "你想创建一个自定义T桖嘛?"
CLOTHESMOD.Config.Sentences[10][filename] = "错误"
CLOTHESMOD.Config.Sentences[11][filename] = "你已经有了自定义T桖"
CLOTHESMOD.Config.Sentences[12][filename] = "这个名字已经取了"
CLOTHESMOD.Config.Sentences[13][filename] = "创建"
CLOTHESMOD.Config.Sentences[14][filename] = "选择你的裤子"
CLOTHESMOD.Config.Sentences[15][filename] = "更改"
CLOTHESMOD.Config.Sentences[16][filename] = "衣服清单"
CLOTHESMOD.Config.Sentences[17][filename] = "购物车"
CLOTHESMOD.Config.Sentences[18][filename] = "合计"
CLOTHESMOD.Config.Sentences[19][filename] = "关闭"
CLOTHESMOD.Config.Sentences[20][filename] = "商店"
CLOTHESMOD.Config.Sentences[21][filename] = "添加到购物车"
CLOTHESMOD.Config.Sentences[22][filename] = "你已经拥有这个了"
CLOTHESMOD.Config.Sentences[23][filename] = "购买"
CLOTHESMOD.Config.Sentences[24][filename] = "定制"
CLOTHESMOD.Config.Sentences[25][filename] = "脱下衣服"
CLOTHESMOD.Config.Sentences[26][filename] = "脱下上衣"
CLOTHESMOD.Config.Sentences[27][filename] = "脱下裤子"
CLOTHESMOD.Config.Sentences[28][filename] = "欢迎"
CLOTHESMOD.Config.Sentences[29][filename] = "确认"
CLOTHESMOD.Config.Sentences[30][filename] = "返回"
CLOTHESMOD.Config.Sentences[31][filename] = "选择你的名字"
CLOTHESMOD.Config.Sentences[32][filename] = "选择你的性别"
CLOTHESMOD.Config.Sentences[33][filename] = "选择眼睛的颜色"
CLOTHESMOD.Config.Sentences[34][filename] = "选择你的头"
CLOTHESMOD.Config.Sentences[35][filename] = "确认"
CLOTHESMOD.Config.Sentences[36][filename] = "在目前工作中你不能这样做."
CLOTHESMOD.Config.Sentences[37][filename] = "你没有上衣"
CLOTHESMOD.Config.Sentences[38][filename] = "你没有底裤"
CLOTHESMOD.Config.Sentences[39][filename] = "你脱掉了上衣"
CLOTHESMOD.Config.Sentences[40][filename] = "你脱掉了裤子"
CLOTHESMOD.Config.Sentences[41][filename] = "你没有足够的钱!"
CLOTHESMOD.Config.Sentences[42][filename] = "你做过手术"
CLOTHESMOD.Config.Sentences[43][filename] = "你的衣服已经买了,现在在你的衣柜里"
CLOTHESMOD.Config.Sentences[44][filename] = "你的T恤已经买了,现在在你的衣柜里"
CLOTHESMOD.Config.Sentences[45][filename] = "你换了衣服"
CLOTHESMOD.Config.Sentences[46][filename] = "已经是你的名字了!"
CLOTHESMOD.Config.Sentences[47][filename] = "你的名字已经更改!"
CLOTHESMOD.Config.Sentences[48][filename] = "您的角色已创建!"
CLOTHESMOD.Config.Sentences[49][filename] = "衣柜"
CLOTHESMOD.Config.Sentences[50][filename] = "这件衣服是给异性穿的"
CLOTHESMOD.Config.Sentences[51][filename] = "Mike衣服经销商"
CLOTHESMOD.Config.Sentences[52][filename] = "整形医生"
CLOTHESMOD.Config.Sentences[53][filename] = "注意 : 如果你换了性,你衣柜里的衣服都会被删掉!"
CLOTHESMOD.Config.Sentences[54][filename] = "付手术费"
CLOTHESMOD.Config.Sentences[55][filename] = "你想要这个样子吗 ?"
CLOTHESMOD.Config.Sentences[56][filename] = "要花很多钱"
CLOTHESMOD.Config.Sentences[57][filename] = "你什么都没改变"
CLOTHESMOD.Config.Sentences[58][filename] = "支付"
CLOTHESMOD.Config.Sentences[59][filename] = "你好,我是整形医生"
CLOTHESMOD.Config.Sentences[60][filename] = "你想整形你的外貌嘛?"
CLOTHESMOD.Config.Sentences[61][filename] = "是的!"
CLOTHESMOD.Config.Sentences[62][filename] = "不,谢谢!"
CLOTHESMOD.Config.Sentences[63][filename] = "更改名字"
CLOTHESMOD.Config.Sentences[64][filename] = "你想更改你的名字嘛?"
CLOTHESMOD.Config.Sentences[65][filename] = "更改我的名字!"
CLOTHESMOD.Config.Sentences[66][filename] = "购买定制上衣"
CLOTHESMOD.Config.Sentences[67][filename] = "购买这个T桖"
CLOTHESMOD.Config.Sentences[68][filename] = "您的姓名和名字必须至少有3个字符长(必须英文)"
CLOTHESMOD.Config.Sentences[69][filename] = "这里没有免费的床，请稍后再试"
