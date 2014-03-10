module LDBench.Matchers.Vector where

import Control.Exception
import Data.List

import LDBench.Matcher
import LDBench.Matchers.Convert

data L0 = L0

data L1 = L1

data L2 = L2

instance Matcher L0 [Bool] where
  distance L0 x0 x1 = do
    return $ fromIntegral $
      assert (length x0 == length x1) $
      length $ filter id $ zipWith (\e0 e1 -> e0 == e1) x0 x1

  matchAll L0 = distanceToMatchAll $ distance L0
