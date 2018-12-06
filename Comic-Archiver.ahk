; Comic Archiver

#NoEnv

SendMode Input
SetWorkingDir %A_ScriptDir%

#singleinstance force


saveClipboard() { ; Also now clears it.
  global
  InitialClipboard := ClipboardAll
  Clipboard =
  return
}

restoreClipboard() {
  global
  Clipboard := InitialClipboard
  return
}

releaseModifierKeys() {
  Send {CtrlUp}
  Send {AltUp}
  return
}

basicSleep(MinorDelayScale:=1) {
  global
  Sleep (MinorDelayScale*80)
  return
}

pasteVar(Var) {
  global
  Clipboard =
  Clipboard := Var
  ClipWait, 0
  Send ^v
  basicSleep()
  return
}

copyAndReturnSelected() {
  global
  Clipboard =
  Send ^c
  ClipWait, 0
  basicSleep()
  return Clipboard
}

sendTabs(NumberOfTabs:=1) {
  global
  TabsSent = 0
  while (TabsSent < NumberOfTabs)
  {
    Send {Tab}
    TabsSent := TabsSent + 1
  }
  return
}

StartAnyFunction() {
  global
  saveClipboard()
  return
}

EndAnyFunction() {
  global
  restoreClipboard()
  releaseModifierKeys()
  return
}

reloadAndRelease() { ; Ctrl + Alt + L
  Reload
  releaseModifierKeys()
}

renamePages() { ; Ctrl + Alt + R
  basicSleep(10)
  StartAnyFunction()
  CurrPage = 1
  LoopedToStart = 0
  Send {Home}
  Send {Right}
  Send {Left}
  Send {F2}
  while (LoopedToStart == 0)
  {
    PageNumber := (StrLen(CurrPage)=1 ? "00" : "") (StrLen(CurrPage)=2 ? "0" : "") CurrPage
    pasteVar(PageNumber)
    Send {Tab}
    CurrPage := CurrPage + 1
    ; Check if we've looped back to the start.
    if (copyAndReturnSelected() == "001")
    {
      LoopedToStart = 1
    }
  }
  Send {Enter}
  EndAnyFunction()
}

makeArchive() { ; Ctrl + Alt + A
  StartAnyFunction()
  basicSleep(5)
  Send ^a
  Send {AppsKey}
  Send 7
  Send a
  basicSleep(5)
  sendTabs(2)
  Send {Down}
  Send {Down}
  Send {Down}
  sendTabs(11)
  Send {Space}
  sendTabs(5)
  Send {Enter}
  Send ^a
  EndAnyFunction()
}

selectLastThree() {
  global
  Send {End}
  Send +{Left}
  Send +{Left}
  Send +{Left}
  return
}

renameArchives() { ; Ctrl + Alt + 7
  basicSleep(10)
  StartAnyFunction()
  LoopedToStart = 0
  Send {F2}
  selectLastThree()
  while (LoopedToStart == 0)
  {
    Send cbz
    Send {Tab}
    basicSleep(3)
    Send {Enter}
    basicSleep(3)
    selectLastThree()
    ; Check if we've looped back to the start.
    if (copyAndReturnSelected() != "zip")
    {
      LoopedToStart = 1
    }
  }
  Send {Enter}
  EndAnyFunction()
}

; Release modifier keys and reload the script.
^!l::
reloadAndRelease()
return

; Rename Pages
^!r Up::
renamePages()
return

; Make Archive
^!a Up::
makeArchive()
return

; Rename Pages and Make Archive
^!s Up::
renamePages()
makeArchive()
return

; Rename Archives
^!7 Up::
renameArchives()
return