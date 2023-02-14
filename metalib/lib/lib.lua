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
local label = guiCreateLabel(0,0,190,15,"",false)
--guiSetEnabled(label,false)
guiSetProperty(label,"DisabledTextColour","FFFFFFFF")
guiSetProperty(label,"AlwaysOnTop","True")
local status_tooltip = false

addEventHandler( "onClientMouseEnter", resourceRoot, function(aX, aY)
    if tooltip_elements[source] then 
        if not status_tooltip then 
            local _,piece = string.gsub(tooltip_elements[source][1], "\n", "")
            guiSetText(label,tooltip_elements[source][1])
            if tooltip_elements[source][2] then 
                guiLabelSetColor(label,hex2rgb(tooltip_elements[source][2]))
            end
            guiSetSize(label,190,(15+(piece*15)),false)
            guiSetPosition(label,aX+15,aY-50,false)
            status_tooltip = true
        end
    end
end)

addEventHandler( "onClientMouseLeave", resourceRoot, function()
    if status_tooltip then 
        guiSetText(label,"")
        guiLabelSetColor(label,255,255,255)
        status_tooltip = false
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


        if animt.anim_type == "sizing" then 
            if animt.relative then
                local startw,starth = relativeto(animt.startw,animt.starth)
                local sizew,sizeh =  relativeto(animt.sizew,animt.sizeh)
                sizew,sizeh = interpolateBetween(startw,starth,0,sizew,sizeh,0,(nowTick-animt.oldTick)/animt.duration,animt.easing)
                sizew,sizeh = torelative(sizew,sizeh)
                guiSetSize(animt.elm,sizew,sizeh,animt.relative) 
                if nowTick-animt.oldTick  > animt.duration then  table.remove(animations,index) end
            else
                local movew,moveh = interpolateBetween(animt.startw,animt.starth,0,animt.sizew,animt.sizeh,0,(nowTick-animt.oldTick)/animt.duration,animt.easing)
                guiSetSize(animt.elm,sizew,sizeh,animt.relative)
                if nowTick-animt.oldTick  > animt.duration then  table.remove(animations,index)  end
            end
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
    setTimer(function(element,elm_x,elm_y,relative)
        guiStopAniming(element)
        guiSetPosition(element,elm_x,elm_y,relative)
    end,650,1,element,elm_x,elm_y,relative)
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
    
end




_guiCreateMemo = guiCreateMemo
function guiCreateMemo(...) 
    local elm = _guiCreateMemo(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
    if elm and type(arg[#arg]) == 'table' then 
        setProperties(elm,arg[#arg]) 
    end 
    return elm 
end


_guiCreateWindow = guiCreateWindow
function guiCreateWindow(...) 
    local elm = _guiCreateWindow(unpack(arg,1,type(arg[#arg]) == 'table' and #arg-1 or #arg)) 
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
