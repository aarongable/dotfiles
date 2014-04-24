{-# LANGUAGE DeriveDataTypeable #-}

-- | Imports
import XMonad hiding ((|||))

-- Basic data types
import qualified Data.List as L
import qualified Data.Maybe as M

-- Utils
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import System.Exit
import System.IO

-- Imports for various layouts
import XMonad.Layout hiding ((|||))
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation

-- Imports for desktop management
import XMonad.Hooks.ManageDocks

-- For special extensions and TODOs
-- * for storing state, specifically the screen pairing boolean
import qualified XMonad.Util.ExtensibleState as XS
-- * for executing actions on both screens without changing focus
import XMonad.Actions.OnScreen
-- * for alt-tab functionality between screens and workspaces
import XMonad.Actions.CycleWS


-- TODO(aarongable):
-- Use LayoutCombinators to add jump-to-layout shortcuts
-- Use Submap for more intuitive and sometimes vimlike keys
-- Set workspace-specific layouts
-- Set a good startupHook


-- | Main config
main = xmonad $ defaultConfig
  { terminal            = myTerminal
  , modMask             = mod4Mask
  , focusFollowsMouse   = False
  , workspaces          = myWorkspaces
  , layoutHook          = myLayoutHook
  , manageHook          = myManageHook
  , keys                = myKeys
  , normalBorderColor   = myInactiveBorderColor
  , focusedBorderColor  = myActiveBorderColor
  }


-- | Terminal
myTerminal = "gnome-terminal"


-- | Workspaces
myWorkspaces = nums ++ map ("F"++) nums
    where nums = map show [1..10]
-- workspace switching keys
myWsKeys = myNumKeys ++ myFunKeys
myNumKeys = map show [1..9] ++ ["0"]
myFunKeys = map (\n -> "<F"++n++">") (map show [1..10])


-- | Layouts
-- windowNavigation for M-[hjkl] movement
-- avoidStrutsOn [] to get toggleStruts, but hiding panels by default
myLayoutHook = windowNavigation $ avoidStrutsOn []
  ( two ||| Mirror two ||| ThreeCol 1 (3/100) (1/3) ||| spiral (1) ||| simpleTabbed )
    where two = ResizableTall 1 (3/100) (1/2) []


-- | Management
myManageHook = composeAll
    [ className =? "Xmessage" --> doFloat
    , manageDocks
    ]


-- | Keyboard shortcuts
myKeys = \conf -> mkKeymap conf $
  -- Window Navigation
  [ ("M-h",             sendMessage $ Go L)
  , ("M-j",             sendMessage $ Go D)
  , ("M-k",             sendMessage $ Go U)
  , ("M-l",             sendMessage $ Go R)
  , ("M-m",             windows W.focusMaster)

  -- Window Movement
  , ("M-S-h",           sendMessage $ Swap L)
  , ("M-S-j",           sendMessage $ Swap D)
  , ("M-S-k",           sendMessage $ Swap U)
  , ("M-S-l",           sendMessage $ Swap R)
  , ("M-S-m",           windows W.swapMaster)

  -- Drop floating window back into tiling
  , ("M-t",             withFocused $ windows . W.sink)

  -- Kill window
  , ("M-q",             kill)
  ]

  -- Layout Management
  ++
  [ ("M-<Space>",       sendMessage NextLayout)
  , ("M-S-<Space>",     sendMessage FirstLayout)

  , ("M--",             sendMessage (IncMasterN (-1)))
  , ("M-=",             sendMessage (IncMasterN 1))

  , ("M-S--",           sendMessage Shrink)
  , ("M-S-=",           sendMessage Expand)

  , ("M-b",             sendMessage ToggleStruts)

  , ("M-<Scroll_lock>", XS.modify wsTogglePairState)
  ]

  -- Applications
  ++
  [ ("M-<Return>",      spawn $ XMonad.terminal conf)
                                -- colors chosen to match Ubuntu 12.04
  , ("M-S-<Return>",    spawn $ "dmenu_run -nb '#2C001E' -nf '#AEA79F'"
                                        ++ " -sb '#AEA79F' -sf '#2C001E'"
                                        ++ " -l 4 -m 1")
  ]

  -- XMonad system
  ++
  [ ("M-C-<Esc>",       spawn $ "xkill")
  , ("M-S-q",           io (exitWith ExitSuccess))
  , ("M-S-r",           spawn "xmonad --recompile; xmonad --restart")
  ]

  -- Shift monitors
    -- mod-{y/u,o/i}: Switch to physical/Xinerama screens 1, 2
    -- mod-shift-{y/u,o/i}: Move window to screen 1, 2
  ++
  [ (m ++ key, screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip ["y", "u", "o", "i"] [0, 0, 1, 1]
  , (m, f) <- [("M-", W.view), ("M-S-", W.shift)]
  ]
  -- alt-tab for monitors and workspaces, via CycleWS
  ++
  [ ("M-<Tab>",         nextScreen)
  , ("M-S-<Tab>",       shiftNextScreen >> nextScreen)
  , ("M-`",             toggleWS)
  ]

  -- Unified workspace shifting
  ++
  [ (m ++ k,            f k)
  | k <- myWsKeys
  , (m, f) <- [("M-", myViewer), ("M-S-", myShifter)]
  ]


-- | Colors
myActiveBorderColor = "red"
myInactiveBorderColor = "black"


-- | Helper functions
-- let bools be stored in persistent storage
data WsPairState = WsPairState Bool deriving (Typeable, Read, Show)
instance ExtensionClass WsPairState where
  initialValue  = WsPairState False
  extensionType = PersistentExtension

-- toggle the state of the stored bool
wsTogglePairState (WsPairState s) = WsPairState $ not s

-- The core of the workspace switching
-- * if the pair state is false, just do normal views
-- * if the pair state is true, do paired workspace switching
myViewer k = do
  WsPairState s <- XS.get
  case s of
    False -> windows $ W.view (keyWs k)
    True  -> windows (onlyOnScreen 0 (numKeyWs k)) >> windows (onlyOnScreen 1 (funKeyWs k))

myShifter k = windows $ W.shift (keyWs k)

-- Maps input keys to corresponding workspaces
keyWs k = snd . head $ filter ((==k) . fst) myWsMap
  where
    myWsMap = zip myWsKeys myWorkspaces
-- Maps input keys to corresponding number or function workspaces
numKeyWs k = keyWs $ myNumKeys !! modIndex k
funKeyWs k = keyWs $ myFunKeys !! modIndex k
modIndex k = M.fromJust (L.elemIndex k myWsKeys) `mod` 10 

