function click_fc()
    print("tıklama be")
    guiSetSize(panel,0.1,0.1,true)
    guiSizeTo(panel,0.5,0.5,true,"Linear",2000)
end

function click_fc2()
    print("tıklama be")
    guiAlertAnim(panel2,true)
    guiSetAlpha(panel2,0)
    guiAlphaTo(panel2,1.25,"Linear",1000)
end

