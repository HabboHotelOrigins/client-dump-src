property pActive, pSwitch

on prepare me, tdata
  if me.pSprList.count > 1 then
    removeEventBroker(me.pSprList[2].spriteNum)
  end if
  if me.pSprList.count > 2 then
    removeEventBroker(me.pSprList[3].spriteNum)
  end if
  if (tdata[#stuffdata] = "ON") or (tdata[#stuffdata] = "1") then
    me.setOn()
  else
    me.setOff()
  end if
  return 1
end

on updateStuffdata me, tValue
  if (tValue = "ON") or (tValue = "1") then
    me.setOn()
  else
    me.setOff()
  end if
end

on update me
  if pActive then
    if me.pSprList.count < 3 then
      return 
    end if
    tDelim = the itemDelimiter
    the itemDelimiter = "_"
    tName = me.pSprList[1].member.name
    tItem = tName.item[1..tName.item.count - 6]
    tPart = tName.item[tName.item.count - 5]
    tdata = tName.item[tName.item.count - 4..tName.item.count - 1]
    tNewNameA = tItem & "_" & "b" & "_" & tdata & "_" & pSwitch
    tNewNameB = tItem & "_" & "c" & "_" & tdata & "_" & pSwitch
    the itemDelimiter = tDelim
    me.pSprList[2].locZ = me.pSprList[1].locZ + 2
    me.pSprList[3].locZ = me.pSprList[2].locZ + 2
    if memberExists(tNewNameA) then
      tmember = member(getmemnum(tNewNameA))
      me.pSprList[2].castNum = tmember.number
      me.pSprList[2].width = tmember.width
      me.pSprList[2].height = tmember.height
    end if
    if memberExists(tNewNameB) then
      tmember = member(getmemnum(tNewNameB))
      me.pSprList[3].castNum = tmember.number
      me.pSprList[3].width = tmember.width
      me.pSprList[3].height = tmember.height
    end if
    pActive = 0
  end if
end

on setOn me
  pSwitch = 1
  pActive = 1
end

on setOff me
  pSwitch = 0
  pActive = 1
end

on select me
  if the doubleClick then
    if pSwitch then
      tStr = "OFF"
    else
      tStr = "ON"
    end if
    getThread(#room).getComponent().getRoomConnection().send("SETSTUFFDATA", [#string: string(me.getID()), #string: tStr])
  end if
  return 1
end
