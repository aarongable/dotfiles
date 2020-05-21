{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE UnicodeSyntax #-}
{- |
Module       : xmonad.hs
Description  : Configuration for the XMonad window manager.
Copyright    : (c) Aaron Gable (aarongable@gmail.com)
License      : Fork me on GitHub

Maintainer   : aarongable@gmail.com
Stability    : experimental
Portability  : non-portable

My personal XMonad configuration, intended to run standalone on Ubuntu 14.04.
-}

-- | Imports
import XMonad hiding ((|||))

import Control.Monad
import System.Exit
import System.IO

import XMonad.Actions.Navigation2D
import XMonad.Actions.OnScreen

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place

import XMonad.Layout.IndependentScreens (countScreens)
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Util.EZConfig
import XMonad.Util.Run

import qualified Data.List as L
import qualified Data.Maybe as M
import qualified XMonad.StackSet as W
import qualified XMonad.Util.ExtensibleState as XS


-- TODO(aarongable):
-- Use LayoutCombinators to add jump-to-layout shortcuts
-- Use Submap for more intuitive and sometimes vimlike keys
-- Set workspace-specific layouts
-- Set a good startupHook


-- | Main config
main = do
  numScreens <- countScreens
  xmobarPipe <- spawnPipe myXmobar
  xmonad $ docks ( myConfig numScreens xmobarPipe )

myConfig n h = withNavigation2DConfig myNavigation2DConfig $ def
  -- In the same order as they are defined in the default config.hs.
  { borderWidth         = myBorderWidth
  , workspaces          = myWorkspaces n
  , layoutHook          = myLayoutHook
  , terminal            = myTerminal
  , normalBorderColor   = myNormalBorderColor
  , focusedBorderColor  = myFocusedBorderColor
  , modMask             = myModMask
  , keys                = myKeys n
  , logHook             = myLogHook h
  , startupHook         = myStartupHook
--, mouseBindings       = The default ones are good.
  , manageHook          = myManageHook
  , handleEventHook     = myHandleEventHook
  , focusFollowsMouse   = myFocusFollowsMouse
  , clickJustFocuses    = myClickJustFocuses
  }


-- | Basics
myTerminal = "gnome-terminal"
myModMask = mod4Mask  -- Windows/Super key isn't useful for anything else...
myFocusFollowsMouse = False  -- Who uses the mouse anyway?
myClickJustFocuses = False  -- But when you do, it should actually work.


-- | Colors
myBorderWidth = 1
myFocusedBorderColor = "red"
myNormalBorderColor = "#111111"
ubuntuBackgroundColor = "#5E2750"  -- "Mid aubergine"
ubuntuForegroundColor = "#AEA79F"  -- "Warm grey"


-- | Startup
myStartupHook = return ()


-- | Workspaces
-- The idea here is to always have 10 workspaces. But because xmonad always
-- shows one workspace per screen, instead create 10 * (number of screens)
-- workspaces. Then only assign a single key to each set of (number of screens)
-- workspaces and use myViewer to switch the workspace which is displayed
-- on all screens simultaneously.
-- If three screens are present, a single "virtual workspace" will consist of
-- a set of xmonad workspaces spaced 10 apart, e.g. "(3) (13) (23)".
-- The number of screens present is passed in as the argument to myWorkspaces
-- by the top level main function, and is passed downward from there.
myScreens n = [0..n-1]
myWsOrdering = [1..9] ++ [0]
calcOffset o n = 10 * o + n
myWorkspaces n = map show [ calcOffset o k | k <- myWsOrdering, o <- myScreens n ]
myWsKeys = myWsOrdering

-- needs to generalize over N screens
viewWsOnScreen ws screen = windows (onlyOnScreen screen (show $ calcOffset screen ws))
myViewer n k = foldr1 (>>) [viewWsOnScreen k s | s <- myScreens n]
myViewer1 k = foldr1 (>>) [
    windows (onlyOnScreen 0 (show $ calcOffset 0 k))
  , windows (onlyOnScreen 1 (show $ calcOffset 1 k))
  , windows (onlyOnScreen 2 (show $ calcOffset 2 k))
  ]
myViewer2 k = foldr1 (>>) $! [
    windows (onlyOnScreen m (show $ calcOffset m k))
  | m <- [0..2]
  ]

-- needs to send to given workspace with same offset as current workspace
myShifter n k = windows $ W.shift (show $ calcOffset 0 k)


-- | Layouts
-- windowNavigation for M-[hjkl] movement.
-- avoidStrutsOn [] to get toggleStruts, but hiding panels by default.
-- TODO(agable): Use layout combinators to get jump-to-layout functionality.
myLayoutHook = avoidStruts ( twocol ||| tworow  ||| threecol ||| tabbed )
    where twocol = renamed [Replace "twocol"] $ ResizableTall 1 (3/100) (1/2) []
          tworow = renamed [Replace "tworow"] $ Mirror twocol
          threecol = renamed [Replace "threecol"] $ ThreeColMid 1 (3/100) (2/3)
          tabbed = renamed [Replace "tabbed"] $ simpleTabbed


-- | Management
myManageHook = composeAll $ reverse
  [ className =? "Xmessage" --> doFloat
  , appName =? "gnubby_ssh_prompt" --> doFloat
  , manageDocks
  ]


-- | Desktop integration
myHandleEventHook = handleEventHook def <+> fullscreenEventHook


-- | Xmobar
myXmobar = "xmobar"  -- Uses default config file at ~/.xmobarrc.
myLogHook h = dynamicLogWithPP $ myPP h

-- Very similar to default, but with longer truncation for title.
myPP h = def
  { ppCurrent         = xmobarColor "yellow" "" . wrap "[" "]"
  , ppVisible         = xmobarColor "orange" "" . wrap "(" ")"
  , ppHidden          = id
  , ppHiddenNoWindows = const ""
  , ppUrgent          = xmobarColor "red" "yellow"
  , ppSep             = xmobarColor "red" "" " ❯ "
  , ppWsSep           = " "
  , ppTitle           = xmobarColor "green"  "" . shorten 128
  , ppLayout          = id
--, ppOrder           = The default order (ws, layout, command) is good.
--, ppSort            = The workspaces are already sorted correctly.
  , ppExtras          = []
  , ppOutput          = hPutStrLn h
  }


-- | Keyboard shortcuts
myNavigation2DConfig = def
  { layoutNavigation = [("tabbed", centerNavigation)]
  }

myKeys n = \conf -> mkKeymap conf $
  [ -- Directional window navigation (Navigation2D)
    ("M-h",             windowGo L False)
  , ("M-j",             windowGo D False)
  , ("M-k",             windowGo U False)
  , ("M-l",             windowGo R False)
  , ("M-S-h",           windowSwap L False)
  , ("M-S-j",           windowSwap D False)
  , ("M-S-k",           windowSwap U False)
  , ("M-S-l",           windowSwap R False)
  , ("M-S-y",           windowToScreen L False <+> windowGo L False)
  , ("M-S-u",           windowToScreen D False <+> windowGo D False)
  , ("M-S-i",           windowToScreen U False <+> windowGo U False)
  , ("M-S-o",           windowToScreen R False <+> windowGo R False)
  , ("M-y",             screenGo L False)
  , ("M-u",             screenGo D False)
  , ("M-i",             screenGo U False)
  , ("M-o",             screenGo R False)
  ]
  ++
  [ -- Navigation utilities
    ("M-<Tab>",         windows W.focusDown)
  , ("M-S-<Tab>",       windows W.focusUp  )
  , ("M-m",             windows W.focusMaster)
  , ("M-S-m",           windows W.swapMaster)
  , ("M-t",             withFocused $ windows . W.sink)
  , ("M-S-q",           kill)
  ]
  ++
  [ -- Layout Management
    ("M-<Space>",       sendMessage NextLayout)
  , ("M-S-<Space>",     setLayout $ XMonad.layoutHook conf)
  , ("M--",             sendMessage (IncMasterN (-1)))
  , ("M-=",             sendMessage (IncMasterN 1))
  , ("M-S--",           sendMessage Shrink)
  , ("M-S-=",           sendMessage Expand)
  , ("M-b",             sendMessage ToggleStruts)
  ]
  ++
  [ -- Applications
    ("M-<Return>",      spawn $ XMonad.terminal conf)
  , ("M-p",             spawn $ "code")
  , ("M-S-<Return>",    spawn $ "dmenu_run -l 4 -nb '#2C001E' -nf '#AEA79F'"
                                           ++ " -sb '#AEA79F' -sf '#2C001E'"
                                           ++ " -fn 'DejaVu Sans Mono Book'")
  , ("<F12>",           spawn $ "i3lock -c 2C001E")
  , ("<Print>",         spawn $ "gnome-screenshot --area")
  ]
  ++
  [ -- XMonad system
    ("M-C-<Esc>",       spawn $ "xkill")
  , ("M-C-S-q",         io (exitWith ExitSuccess))
  , ("M-S-r",           spawn "xmonad --recompile; xmonad --restart")
  ]
  ++
  [ -- Unified workspace shifting
    (mod ++ show key,        func key)
    | key <- myWsKeys,
--    (mod, func) <- [("M-", (myViewer n)), ("M-S-", (myShifter n))]
      (mod, func) <- [("M-", (myViewer1)), ("M-S-", (myShifter n))]
  ]
