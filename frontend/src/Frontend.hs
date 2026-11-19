module Frontend where

import Obelisk.Frontend
import Obelisk.Generated.Static ()
import Obelisk.Route
import Obelisk.Route.Frontend
import Reflex.Dom

import Common.Route

import Control.Monad (void)
import Control.Monad.Fix (MonadFix)

import qualified Data.Text as T
import qualified Data.Map as M


frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = frontendHead
  , _frontend_body = frontendBody
  }

frontendHead :: ObeliskWidget t route m => RoutedT t route m ()
frontendHead = do
  el "title" $ text "Obelisk Skeleton"

frontendBody :: ObeliskWidget t (R FrontendRoute) m => RoutedT t (R FrontendRoute) m ()
frontendBody = do
  el "h1" $ text "Welcome to Obelisk"
  el "p" $ text "Edit frontend/src/Frontend.hs to get started."

  _ <- el "ul"
    --  $ prerender blank
     $ void disappearingMap

  return ()

disappearingMap :: forall t m.
  ( DomBuilder t m
  , PostBuild t m
  , MonadHold t m
  , MonadFix m
  ) => m ()
disappearingMap = let
  theMap   ::                   M.Map Int T.Text
  dynMap   ::        Dynamic t (M.Map Int T.Text)
  display' :: Int -> Dynamic t T.Text -> m ()
  theMap = 2 =: "two" <> 3 =: "three" <> 1 =: "one"
  dynMap = constDyn theMap
  display' = const $ el "li" . dynText
 in void $ listWithKey dynMap display'