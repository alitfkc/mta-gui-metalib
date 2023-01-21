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


memo_property = {
    active_selection_color = "FF00FF77",
    inactive_selection_color = "2200FF77",
    readonly_bg_color = "ffaa00aa",
    read_only = "False",
    selected_text_color ="FFFF0000"
}

memo = guiCreateMemo(0.1,0.75,0.1,0.1,"yok",true,panel,memo_property)




checkbox_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    click = click_fc,
    tooltip = "Basma kardeşim lan \nBasmasana alooo \ntamam lan bas bas \nbana da sıra gelir",
}


check = guiCreateCheckBox(0.1,0.85,0.1,0.1,"Basma",true,true,panel,checkbox_property)


radiobutton_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",

}

radio = guiCreateRadioButton(0.3,0.1,0.1,0.1,"Basma",true,panel,radiobutton_property)

combobox_property = {
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
}
combo = guiCreateComboBox(0.3,0.3,0.3,0.1,"Basma",true,panel,radiobutton_property)

gridlist_property = {

}
list = guiCreateGridList(0.3,0.4,0.3,0.3,true,panel,gridlist_property)
col = guiGridListAddColumn(list,"hopa",1)
for i=1,20 do 
    guiGridListAddRow(list,col,i)
end

bar = guiCreateProgressBar(0.3,0.8,0.3,0.1,true,panel)


scroll = guiCreateScrollBar(0.8,0.2,0.03,0.3,false,true,panel)

pane = guiCreateScrollPane(0.8,0.4,0.3,0.3,true,panel)
for i=1,20 do 
    guiCreateButton(0.1,0.1+(i/10),0.09,0.09,"asd",true,pane)
end


panel_property2 = {
    alpha = 0.8,
    font="sa-gothic",
    titlebar_font = "sa-gothic",
    sizing = "False",
    movable = "False",
    titlebar_enabled = "True",
    alwaysontop = "False",
    bindkey = "f4",
    command = "panelac",
    caption_color = "FFAA00AA",

}


panel2 = guiCreateWindow(0.6,0.1,0.5,0.5,"selam",true,panel_property2)

buton_property2 = {
    font="sa-gothic",
    hover_text_color = "FFAA00AA",
    normal_text_color = "FF00AA00",
    disabled_text_color = "FF0000AA",
    pushed_text_color = "FF00AAAA",
    click = click_fc2,
    tooltip = "Basma kardeşim lan \nBasmasana alooo \ntamam lan bas bas \nbana da sıra gelir",
    count=2500,

}

buton2 = guiCreateButton(0.1,0.4,0.1,0.1,"Basma",true,panel2,buton_property2)

guiSetVisible(panel,false)
guiSetVisible(panel2,false)


