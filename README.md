# mta-gui-metalib
``` This gives you when creating gui in mta. It provides a lot of convenience, so you can write faster code. ```

```diff
-In your meta the lib should be at the top and the panel at the bottom.🚩
```
```xml
<meta>
	<info author="Meta Scripts" type="script" name="Libs" version="0.1.0" />
	
	<script src="lib/lib.lua" type="client" />
	
	<script src="util_c.lua" type="client" />
	<script src="panel.lua" type="client" />

    <min_mta_version server="1.3.4-0.00000" client="1.5.2-9.07903"></min_mta_version>
</meta>

```


**Anims Example**
```lua
function click_fc()
    guiSetSize(panel,0.1,0.1,true)
    guiSizeTo(panel,0.5,0.5,true,"Linear",2000)
end

function click_fc2()
    guiAlertAnim(panel,true)
    guiSetAlpha(panel,0)
    guiAlphaTo(panel,1.25,"Linear",1000)
end

```



**Window Example**
```lua
panel_property = {
    alpha = 0.8,
    font="sa-gothic",
    titlebar_font = "sa-gothic",
    sizing = "False",
    movable = "False",
    titlebar_enabled = "True",
    alwaysontop = "False",
    bindkey = "f4",
    command = "panelac",
    caption_color = "FFAA00AA"
}
panel = guiCreateWindow(0.1,0.25,0.5,0.5,"selam",true,panel_property)
```

**Button Example**
```lua
buton_property = {
    font="sa-gothic",
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    click = click_fc,
    tooltip = "Basma kardeşim lan \nBasmasana alooo \ntamam lan bas bas \nbana da sıra gelir",
}
buton = guiCreateButton(0.1,0.4,0.1,0.1,"Basma",true,panel,buton_property)
```

**Edit Example**
```lua
edit_property = {
    active_selection_color = "FF00FF77",
    inactive_selection_color = "00FF77",
    readonly_bg_color = "ffaa00aa",
    read_only = "False",
    selected_text_color ="FFFF0000",
    only_number = true,
    max_length = 8,
    selection_length = 2,
    tooltip = "Basma kardeşim lan \nBasmasana alooo \ntamam lan bas bas \nbana da sıra gelir",
    tooltip_text_color = "ff00ff"
}
edit = guiCreateEdit(0.1,0.55,0.1,0.1,"12",true,panel,edit_property)
```

**Memo Example**
```lua
memo_property = {
    active_selection_color = "FF00FF77",
    inactive_selection_color = "2200FF77",
    readonly_bg_color = "ffaa00aa",
    read_only = "False",
    selected_text_color ="FFFF0000"
}
memo = guiCreateMemo(0.1,0.75,0.1,0.1,"yok",true,panel,memo_property)
```


**CheckBox Example**
```lua
checkbox_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    click = click_fc,
    tooltip = "Basma kardeşim lan \nBasmasana alooo \ntamam lan bas bas \nbana da sıra gelir",
}

check = guiCreateCheckBox(0.1,0.85,0.1,0.1,"Basma",true,true,panel,checkbox_property)

```



**RadioButton Example**
```lua
radiobutton_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",

}
radio = guiCreateRadioButton(0.3,0.1,0.1,0.1,"Basma",true,panel,radiobutton_property))
```

**ComboBox Example**
```lua
combobox_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
}
combo = guiCreateComboBox(0.3,0.3,0.3,0.1,"Basma",true,panel,radiobutton_property)
```


**GridList Example**
```lua
gridlist_property = {
    list_hscroll = "False",
    list_vscroll = "False",
}
list = guiCreateGridList(0.3,0.4,0.3,0.3,true,panel,gridlist_property)

col = guiGridListAddColumn(list,"hopa",1)
for i=1,20 do 
    guiGridListAddRow(list,col,i)
end
```









