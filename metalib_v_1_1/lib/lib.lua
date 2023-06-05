--------------------------------------------
-- Debug Writter
-------------------------------------------


local sx,sy = guiGetScreenSize()


function debug(msg,type,r,g,b)
    outputDebugString(getResourceName(getThisResource()).." : - "..msg,type,r,g,b)
end



----------------------------------
--Elements Tooltip
-----------------------------------
local tooltip_elements = {}
background = guiCreateWindow(0,0,190,100,"İnfo Box",false)
local label = guiCreateLabel(0,20,190,100,"asdasd",false,background)
--guiSetEnabled(label,false)
guiSetProperty(label,"DisabledTextColour","FFFFFFFF")
guiSetProperty(background,"AlwaysOnTop","True")
guiSetProperty(label,"AlwaysOnTop","True")
guiLabelSetHorizontalAlign(label,"Center")
guiLabelSetVerticalAlign(label,"Center")
status_tooltip = false
guiSetVisible(background,false)

addEventHandler( "onClientMouseEnter", resourceRoot, function(aX, aY)
    if tooltip_elements[source] then 
        if not status_tooltip then 
            local aX,aY = getCursorPosition()
            aX,aY = relativeto(aX,aY)

            guiSetText(label,tooltip_elements[source][1])
            guiSetVisible(background,true)
            local _,piece = string.gsub(tooltip_elements[source][1], "\n", "")
            if tooltip_elements[source][2] then 
                guiLabelSetColor(label,hex2rgb(tooltip_elements[source][2]))
            end
            guiSetSize(label,190,(15+(piece*15)),false)
            guiSetSize(background,190,(55+(piece*15)),false)
            guiSetPosition(background,aX+45,aY-50,false)
            guiSetPosition(label,0,20,false)
            status_tooltip = true    
        end
    end
end)

addEventHandler( "onClientMouseLeave", resourceRoot, function()
    if status_tooltip then 
        guiSetText(label,"")
        guiLabelSetColor(label,255,255,255)
        status_tooltip = false
        guiSetVisible(background,false)
    end
end)


-------------------------
-- İmportant Functions
-------------------------
function relativeto(x1,x2)
    return sx *x1, sy*x2
end
function torelative(x1,x2)
    return x1/sx,x2/sy
end

function hex2rgb(hex) --Hex to R,G,B
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end

-------------------------
-- İmportant Functions
-------------------------
local sx,sy = guiGetScreenSize()

function debug(msg,type,r,g,b)
    outputDebugString(getResourceName(getThisResource()).." : - "..msg,type,r,g,b)
end
function relativeto(x1,x2)
    return sx *x1, sy*x2
end
function torelative(x1,x2)
    return x1/sx,x2/sy
end
function hex2rgb(hex) --Hex to R,G,B
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end


-------------------------------------------
--GUI Animations
-------------------------------------------
local animations = {}
local anim_timers = {}
--Gui moving animation
function guiMoveTo(elm,movex,movey,relative,easing,duration,waiting)
    local x,y = guiGetPosition(elm,relative)
    local tick  = getTickCount()
    table.insert(animations,{anim_type="moving",elm=elm,startx=x,starty=y,movex=movex,movey=movey,relative=relative,oldTick=tick,easing=easing,duration=duration})
    if waiting then
        table.insert(anim_timers,{
            elm = elm,
            timer = setTimer(function(elm,startx,starty,movex,movey,relative,easing,duration)
                table.insert(animations,{anim_type="moving",elm=elm,startx=x,starty=y,movex=movex,movey=movey,relative=relative,oldTick=tick,easing=easing,duration=duration})
            end,waiting,1,elm,startx,starty,movex,movey,relative,easing,duration)
        })
    end
end
--Gui Alpha animation
function guiAlphaTo(elm,movealpha,easing,duration,waiting)
    local startalpha = guiGetAlpha(elm)
    local tick  = getTickCount()
    table.insert(animations,{anim_type="alpha",elm=elm,startalpha=startalpha,movealpha=movealpha,oldTick=tick,easing=easing,duration=duration})
    if waiting then
        table.insert(anim_timers,{
            elm = elm,
            timer = setTimer(function(elm,startalpha,movealpha,easing,duration)
                table.insert(animations,{anim_type="alpha",elm=elm,startalpha=startalpha,movealpha=movealpha,oldTick=tick,easing=easing,duration=duration})
            end,waiting,1,elm,startalpha,movealpha,easing,duration)
        })
    end
end

function guiStopAniming(elm)
    for k,v in ipairs(anim_timers) do 
        if v.elm == elm then 
            if isTimer(v.timer) then 
                killTimer(v.timer)
            end
            table.remove(anim_timers,k)
        end
    end
    for index,animt in ipairs(animations) do 
        if animt.elm == elm then
            table.remove(animations,index)
        end 
    end
end
--Gui sizing animation
function guiSizeTo(elm,sizew,sizeh,relative,easing,duration,waiting)
    local w,h = guiGetSize(elm,relative)
    local tick  = getTickCount()
    table.insert(animations,{anim_type="sizing",elm=elm,startw=w,starth=h,sizew=sizew,sizeh=sizeh,relative=relative,oldTick=tick,easing=easing,duration=duration})
    if waiting then
        table.insert(anim_timers,{
            elm = elm,
            timer = setTimer(function(elm,startx,starty,sizex,sizey,relative,easing,duration)
                table.insert(animations,{anim_type="sizing",elm=elm,startw=w,starth=h,sizew=sizew,sizeh=h,relative=relative,oldTick=tick,easing=easing,duration=duration})
            end,waiting,1,elm,w,hsizex,sizey,relative,easing,duration)
        })
    end
end


function setAnimRender()
    local nowTick = getTickCount()
    for index,animt in ipairs(animations) do 
        if animt.anim_type == "moving" then 
            if animt.relative then
                local startx,starty = relativeto(animt.startx,animt.starty)
                local movex,movey =  relativeto(animt.movex,animt.movey)
                movex,movey = interpolateBetween(startx,starty,0,movex,movey,0,(nowTick-animt.oldTick)/animt.duration,animt.easing)
                movex,movey = torelative(movex,movey)
                guiSetPosition(animt.elm,movex,movey,animt.relative) 
                if nowTick-animt.oldTick  > animt.duration then  table.remove(animations,index) end
            else
                local movex,movey = interpolateBetween(animt.startx,animt.starty,0,animt.movex,animt.movey,0,(nowTick-animt.oldTick)/animt.duration,animt.easing)
                guiSetPosition(animt.elm,movex,movey,animt.relative)
                if nowTick-animt.oldTick  > animt.duration then  table.remove(animations,index)  end
            end
        end
        if animt.anim_type == "alpha" then 
            local movealpha= interpolateBetween(animt.startalpha,0,0,animt.movealpha,0,0,(nowTick-animt.oldTick)/animt.duration,animt.easing)
            guiSetAlpha(animt.elm,movealpha)
            if nowTick-animt.oldTick  > animt.duration then  table.remove(animations,index)  end
        end
    end
end
addEventHandler("onClientRender",root,setAnimRender)

---Custom Anims
--------------------------------------------------
--gui Alert Animation ( - gui uyarı animasyonu - )
---------------------------------------------------
function guiAlertAnim(element,relative)
    if not element then return end
    local elm_x,elm_y = guiGetPosition(element,relative)
    local elm_w,elm_h = guiGetSize(element,relative)
    local move_result = 0
    if relative then 
        move_result =  0.01
    else
        move_result = 10
    end
    guiMoveTo(element,elm_x-move_result,elm_y,relative,"SineCurve",500)
    guiMoveTo(element,elm_x+move_result,elm_y,relative,"SineCurve",500,50)
    guiMoveTo(element,elm_x-move_result,elm_y,relative,"SineCurve",500,100)
    guiMoveTo(element,elm_x+move_result,elm_y,relative,"SineCurve",500,150)
    guiMoveTo(element,elm_x-move_result,elm_y,relative,"SineCurve",500,200)
    guiMoveTo(element,elm_x+move_result,elm_y,relative,"SineCurve",500,250)
    guiMoveTo(element,elm_x-move_result,elm_y,relative,"SineCurve",500,300)
    guiMoveTo(element,elm_x+move_result,elm_y,relative,"SineCurve",500,350)
    guiMoveTo(element,elm_x-move_result,elm_y,relative,"SineCurve",500,400)
    guiMoveTo(element,elm_x,elm_y,relative,"SineCurve",500,450)
    setTimer(function(element,elm_x,elm_y,relative,elm_w,elm_h)
        guiStopAniming(element)
        guiSetPosition(element,elm_x,elm_y,relative)
        guiSetSize(element,elm_w,elm_h,relative)
    end,650,2,element,elm_x,elm_y,relative,elm_w,elm_h)
end


----- Automatic Anims
-----------------------
local auto_anim = {}
local auto_anim_timers = {}
function doing_automatic_anim(elm,state)
    stopAutoAnim(elm)
    local t_anim = auto_anim[elm]
    local not_waiting_time = 0
    local waiting_time_m = 0
    local waiting_time_s = 0
    local waiting_time_a = 0
    if t_anim then
        for k,v in ipairs(t_anim) do
            
            if not state and not v.onoff then  --we are calculating off timer
                if v.waiting then 
                    if v.type == "move" then
                        waiting_time_m = waiting_time_m + v.time+v.waiting
                    elseif v.type == "size" then
                        waiting_time_s = waiting_time_s + v.time+v.waiting
                    elseif v.type == "alpha" then
                        waiting_time_a = waiting_time_a + v.time+v.waiting
                    end
                else
                    if not_waiting_time < v.time then 
                        not_waiting_time = v.time
                    end
                end
            end--we are calculating off timer

            if v.onoff == state then
                if v.type == "move" then 
                    if v.waiting then
                        table.insert(auto_anim_timers,{
                            elm= elm,
                            timer = setTimer(function(elm,t)
                                guiSetPosition(elm,t.start_x,t.start_y,t.relative)
                            end,v.waiting,1,elm,v)}
                        )
                    else
                        guiSetPosition(elm,v.start_x,v.start_y,v.relative)
                    end
                    guiMoveTo(elm,v.finish_x,v.finish_y,v.relative,v.easing,v.time,v.waiting or false)
                elseif v.type == "size" then 
                    if v.waiting then
                        table.insert(auto_anim_timers,{
                            elm= elm,
                            timer = setTimer(function(elm,t)
                                guiSetSize(elm,t.start_w,t.start_h,t.relative)
                            end,v.waiting,1,elm,v)}
                        )
                    else
                        guiSetSize(elm,v.start_w,v.start_h,v.relative)
                    end
                    guiSizeTo(elm,v.finish_w,v.finish_h,v.relative,v.easing,v.time,v.waiting or false)
                elseif v.type == "alpha" then
                    if v.waiting then
                        table.insert(auto_anim_timers,{
                            elm= elm,
                            timer = setTimer(function(elm,t)
                                guiSetAlpha(elm,t.start_a)
                            end,v.waiting,1,elm,v)}
                        )
                    else
                        guiSetAlpha(elm,v.start_a)
                    end
                    guiAlphaTo(elm,v.finish_a,v.easing,v.time,v.waiting or false) 
                end
            end
        end
    end
    if not state then 
        return math.max(not_waiting_time,waiting_time_m,waiting_time_s,waiting_time_a)
    else
        return false
    end
end

function stopAutoAnim(elm)
    for k,v in ipairs(auto_anim_timers) do 
        if v.elm == elm then 
            if isTimer(v.timer) then 
                killTimer(v.timer)
                table.remove(auto_anim_timers,k)
            else
                table.remove(auto_anim_timers,k) 
            end
        end
    end
    guiStopAniming(elm)
end



-----------------------------------
--Changed Element Go to func
-----------------------------------
local changed_elements = {}
addEventHandler("onClientGUIChanged",resourceRoot,function(elm)
    if changed_elements[elm] then changed_elements[elm]() end
end)

-----------------------------------
--Edit only number write
-----------------------------------
local only_number_elements = {}
addEventHandler("onClientGUIChanged",resourceRoot,function(elm)
    if only_number_elements[elm] then 
        guiSetText(elm,string.gsub(guiGetText(elm), "%a", ""))
    end
end)

-----------------------------------
--Click elments will go to func
----------------------------------
local clickable_elements={}
local count_elements = {}
addEventHandler("onClientGUIClick",resourceRoot,function(...)
	if clickable_elements[source] then 
        --click and go to func
        clickable_elements[source](source,...)
        --button on/off count
        if count_elements[source] then 
            buttonOnOff(source,count_elements[source])
        end
    end
end)


--------------------------
--Button on/off count
--------------------------
function buttonOnOff(elm,count)
    guiSetEnabled(elm,false)
    setTimer(function(elm) guiSetEnabled(elm,true) end,count,1,elm)
end

---------------------------------------------
---SET PROPERTİES
---------------------------------------------
local GUI_PROPS = {
	["font"]="Font",
	["horizontal_align"]="HorizontalAlignment",
	["vertical_align"]="VerticalAlignment",
	["titlebar_enabled"]="TitlebarEnabled",
	["titlebar_font"]="TitlebarFont",
    ["alpha"] = "Alpha",
    ["alwaysontop"] = "AlwaysOnTop",
    ["movable"] = "DragMovingEnabled",
    ["hover_text_color"] = "HoverTextColour",
    ["normal_text_color"] = "NormalTextColour",
    ["disabled_text_color"] = "DisabledTextColour",
    ["pushed_text_color"] = "PushedTextColour",
    ["caption_color"] = "CaptionColour",
    ["active_selection_color"] = "ActiveSelectionColour",
    ["inactive_selection_color"] = "InactiveSelectionColour",
    ["readonly_bg_color"] = "ReadOnlyBGColour",
    ["read_only"] = "ReadOnly",
    ["selected_text_color"] = "SelectedTextColour",
    ["mask_text"] = "MaskText",
    ["sizing"] = "SizingEnabled",
    ["max_length"] = "MaxTextLength",
    ["selection_length"] = "SelectionLength",
    ["list_hscroll"] = "ForceHorzScrollbar",
    ["list_vscroll"] = "ForceVertScrollbar",
}


function setProperties(elm,p)
	for key,v in pairs(p) do
		local propname = GUI_PROPS[key]
		if propname then
			guiSetProperty(elm,propname,v)
		end
	end

    --Bindkey element on-off
    if p.bindkey then
        bindKey(p.bindkey,"down",function()
            local state = guiGetVisible(elm)
            guiSetVisible(elm,not state)
            showCursor(not state)
        end) 
    end

    --Click element go to function
	if p.click then 
		clickable_elements[elm] = p.click 
    end


    --only_number
	if p.only_number then 
		only_number_elements[elm] = elm
    end
    -- Elements tooltip
    if p.tooltip  then 
        tooltip_elements[elm] = {p.tooltip,p.tooltip_text_color or false}
    end

    --Command and element on-off
    if p.command then 
        addCommandHandler(p.command,function()
            local state = guiGetVisible(elm)
            guiSetVisible(elm,not state)
            showCursor(not state)
        end)
    end


    --Changed Elements
    if p.changed then
        changed_elements[elm] = p.changed
    end

    --Button on/off count 
    if p.count then 
        count_elements[elm] = p.count
    end
    --gui auto animation
    if p.animation then 
        auto_anim[elm] = p.animation
    end

    --gui hover animation
    if p.hover_animation then 
    end

end




_guiCreateMemo = guiCreateMemo
function guiCreateMemo(...) 
    local elm = _guiCreateMemo(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


-- _guiCreateWindow = guiCreateWindow
function tuiCreateWindow(...) 
    local elm = guiCreateWindow(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end



_guiCreateBrowser = guiCreateBrowser
function guiCreateBrowser(...) local 
    elm = _guiCreateBrowser(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return 
    elm 
end


_guiCreateScrollBar = guiCreateScrollBar
function guiCreateScrollBar(...) 
    local elm = _guiCreateScrollBar(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return 
    elm 
end



_guiCreateScrollPane = guiCreateScrollPane
function guiCreateScrollPane(...) 
    local elm = _guiCreateScrollPane(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateComboBox = guiCreateComboBox
function guiCreateComboBox(...) 
    local elm = _guiCreateComboBox(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateCheckBox = guiCreateCheckBox
function guiCreateCheckBox(...) 
    local elm = _guiCreateCheckBox(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end



_guiCreateTabPanel = guiCreateTabPanel
function guiCreateTabPanel(...) 
    local elm = _guiCreateTabPanel(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateRadioButton = guiCreateRadioButton
function guiCreateRadioButton(...) 
    local elm = _guiCreateRadioButton(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateFont = guiCreateFont
function guiCreateFont(...) 
    local elm = _guiCreateFont(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end

_guiCreateLabel = guiCreateLabel
function guiCreateLabel(...) 
    local elm = _guiCreateLabel(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateEdit = guiCreateEdit
function guiCreateEdit(...) 
    local elm = _guiCreateEdit(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateProgressBar = guiCreateProgressBar
function guiCreateProgressBar(...) 
    local elm = _guiCreateProgressBar(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateTab = guiCreateTab
function guiCreateTab(...) 
    local elm = _guiCreateTab(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateStaticImage = guiCreateStaticImage
function guiCreateStaticImage(...) 
    local elm = _guiCreateStaticImage(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateButton = guiCreateButton
function guiCreateButton(...) 
    local elm = _guiCreateButton(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateGridList = guiCreateGridList
function guiCreateGridList(...) 
    local elm = _guiCreateGridList(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end




_guiSetVisible = guiSetVisible
timer_visible_t = {}
function guiSetVisible(elm,state)
    for k,v in ipairs(timer_visible_t) do --will stop visible timers
        if v.elm == elm then 
            if isTimer(v.timer)  then 
                stopAutoAnim(elm)
                killTimer(v.timer)
                _guiSetVisible(elm,v.state)
                state = not v.state
                table.remove(timer_visible_t,k)
            else
                table.remove(timer_visible_t,k)
            end
        end
    end

    local t_value = doing_automatic_anim(elm,state) -- We are doing automatic animation

    if not t_value then 

        _guiSetVisible(elm,state)
    else
        local timer  = setTimer(function(elm,state)
            _guiSetVisible(elm,state)
        end,t_value,1,elm,state)
        table.insert(timer_visible_t,{elm=elm,timer=timer,state=state})
    end
end

