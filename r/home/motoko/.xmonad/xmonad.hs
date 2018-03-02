import XMonad
import XMonad.Actions.GridSelect
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Util.ScratchpadAlt
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.MultiColumns
import System.IO

main = do
    xmonad $ defaultConfig
      { manageHook         = myManageHook
      , layoutHook         = avoidStruts $ myLayout
      , logHook            = myLogHook
      , modMask            = mod4Mask
      , terminal           = myTerminal
      , borderWidth        = 0
--      , normalBorderColor  = "#151515"
--      , focusedBorderColor = "#700070"
      } `additionalKeys`
      [ ((mod4Mask,               xK_Escape), spawn "xmonad --recompile && xmonad --restart")
      , ((mod4Mask,               xK_a     ), spawn (myTerminal ++ " &"))
      , ((mod4Mask,               xK_p     ), spawn "dmenu_run -b -i -fn 'DejaVu Sans Mono-12'")
      , ((mod4Mask,               xK_q     ), spawn "slock")
      , ((mod4Mask,               xK_o     ), scratchPad)
      , ((mod4Mask,               xK_s     ), goToSelected defaultGSConfig)
      , ((mod4Mask,               xK_c     ), kill)
      , ((0,                      0x1008ff11), spawn "amixer -q sset Master 2%-")
      , ((0,                      0x1008ff13), spawn "amixer -q sset Master 2%+")
      , ((0,                      0x1008ff12), spawn "amixer set Master toggle")
      ]
        where
          scratchPad  = scratchpadSpawnActionCustom
                  ("exec " ++ myTerminal ++ " --class=scratchpad-window")

myTerminal = "sakura"

myLogHook = fadeInactiveLogHook fadeAmount
              where fadeAmount = 0.6

myLayout = multiCol' |||
           Full
             where
               multiCol' = multiCol [1] 4 (3/100) (7/11)

-- className = 2nd property of xprop string WM_CLASS(STRING)
myManageHook = manageDocks <+>
               manageHook defaultConfig <+>
               manageScratchPad <+>
               composeAll
               [ className =? "Firefox-esr" --> doF W.focusDown
               , className =? "Tor Browser" --> doShift "9"
               , className =? "Signal" --> doShift "8"
               ]

manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect le te w h)
                     where
                       le = (1 - w) / 2
                       te = (1 - h) / 2
                       w  = 0.9
                       h  = 0.7
