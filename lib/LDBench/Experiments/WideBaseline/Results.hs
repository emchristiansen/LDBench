module LDBench.Experiments.WideBaseline.Results where

import Data.Array.Repa
import Control.Lens

declareFields [d|
  data Results = Results 
    { distances :: Array U DIM2 Double
    } deriving (Show)
  |]
