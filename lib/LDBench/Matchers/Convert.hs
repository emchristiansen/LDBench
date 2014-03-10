module LDBench.Matchers.Convert where

import Data.Array.Repa
import Control.Monad

import LDBench.Matcher

distanceToMatchAll :: Distance f -> MatchAll f
distanceToMatchAll distance = \x0s x1s -> 
  let
    rows = length x0s :: Int
    cols = length x1s :: Int
  in
    liftM (fromListUnboxed (Z :. rows :. cols)) $ sequence $ do
      x0 <- x0s
      x1 <- x1s
      return $ distance x0 x1

