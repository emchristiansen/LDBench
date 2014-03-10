module LDBench.Detectors.DoublyBoundedPairDetector where

import LDBench.Detector
import LDBench.Detectors.BoundedDetector
import LDBench.PairDetector
import LDBench.Detectors.BoundedPairDetector

data DoublyBoundedPairDetector d = (Detector d) => DoublyBoundedPairDetector
  { _individualMaxKeyPoints :: Int
  , _pairMaxKeyPoints :: Int
  , _threshold :: Double
  , _detector :: d
  }

instance PairDetector (DoublyBoundedPairDetector d) where
  detectPairs 
    (DoublyBoundedPairDetector
      individualMaxKeyPoints
      pairMaxKeyPoints
      threshold
      detector) = 
      let
        boundedIndividual = BoundedDetector 
          individualMaxKeyPoints 
          detector
        boundedPair = BoundedPairDetector
          pairMaxKeyPoints
          threshold
          boundedIndividual
      in
        detectPairs boundedPair
        
