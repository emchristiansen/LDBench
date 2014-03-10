module LDBench.Detectors.BoundedPairDetector where

import LDBench.Detector
import LDBench.PairDetector

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
      return $ take maxKeyPoints pairs
