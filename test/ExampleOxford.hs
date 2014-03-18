module ExampleOxford where

import OpenCVThrift.OpenCV

import LDBench.Experiments.WideBaseline.Oxford
import LDBench.Detectors.DoublyBoundedPairDetector
import qualified LDBench.Detectors.OpenCV as D
import qualified LDBench.Extractors.OpenCV as E
import LDBench.Matchers.Vector
import LDBench.Experiments.RuntimeConfig

oxford = Oxford
  "boat"
  2
  10
  (DoublyBoundedPairDetector 200 100 2.0 D.BRISK)
  E.BRISK
  L0

run :: RuntimeConfig -> IO ()
run runtimeConfig = do
  putStrLn $ show runtimeConfig
  {-runOpenCVComputation $ run oxford runtimeConfig-}
  putStrLn "Done" 
