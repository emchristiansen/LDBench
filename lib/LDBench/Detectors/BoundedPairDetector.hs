module LDBench.Detectors.BoundedPairDetector where

import LDBench.Detector
import LDBench.PairDetector

import LDBench.Util
import Text.Printf

data BoundedPairDetector d = (Detector d) => BoundedPairDetector 
  { _maxKeyPoints :: Int
  , _threshold :: Double
  , _detector :: d
  }

instance PairDetector (BoundedPairDetector d) where
  detectPairs 
    (BoundedPairDetector 
      maxKeyPoints 
      threshold 
      detector)
    bijection
    image0
    image1 = do
      pairs <- detectPairs (threshold, detector) bijection image0 image1
      liftIO' $ putStrLn $ 
        printf "BoundedPairDetector num KeyPoint detections: %d" $ length pairs
      return $ take maxKeyPoints pairs
