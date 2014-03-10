module LDBench.Matcher where

import Data.Array.Repa

import OpenCVThrift.OpenCV

type Distance f = f -> f -> OpenCVComputation Double
type MatchAll f = [f] -> [f] -> OpenCVComputation (Array U DIM2 Double)

class Matcher m f where
  distance :: m -> Distance f 
  matchAll :: m -> MatchAll f


