import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig{
    manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = spacing 3 $ avoidStruts  $  layoutHook defaultConfig
    , logHook = dynamicLogWithPP xmobarPP
        {
        ppOutput = hPutStrLn xmproc
        , ppTitle = xmobarColor "#cc6666" "" . shorten 50
        , ppCurrent = xmobarColor "#40e2b4" "" . wrap "[" "]"
        , ppUrgent = xmobarColor "#cc6666" "" . wrap "<" ">"
        }
    , modMask = mod1Mask
    , terminal = "xterm"
    , borderWidth = 1
    , normalBorderColor = "#707880"
    , focusedBorderColor = "#cc6666"
    , focusFollowsMouse = False
    }
