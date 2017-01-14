--[[

Copyright (c) 2011-2016 chukong-incc.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

]]

require "cocos.cocos2d.Cocos2d"
require "cocos.cocos2d.Cocos2dConstants"
require "cocos.framework.init"

require "cocos.cocos2d.functions"
require "cocos.framework.package_support"
require "cocos.framework.extends.LayerEx"
require "cocos.framework.extends.MenuEx"
require "cocos.framework.extends.NodeEx"
require "cocos.framework.extends.SpriteEx"
require "cocos.framework.extends.UICheckBox"
require "cocos.framework.extends.UIEditBox"
require "cocos.framework.extends.UIListView"
require "cocos.framework.extends.UIPageView"
require "cocos.framework.extends.UIScrollView"
require "cocos.framework.extends.UISlider"
require "cocos.framework.extends.UITextField"
require "cocos.framework.extends.UIWidget"


cc.exports.__G__TRACKBACK__ = function(msg)
    local msg = debug.traceback(msg, 3)
    print(msg)
    return msg
end
