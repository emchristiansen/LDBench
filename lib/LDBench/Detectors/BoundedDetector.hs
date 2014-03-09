module LDBench.Detectors.BoundedDetector where

import Control.Lens
import Control.Lens.TH
import Control.Applicative

import OpenCVThrift.OpenCV.Core

import LDBench.Detector

data BoundedDetector d = (Detector d) => BoundedDetector 
  { _maxKeyPointsL :: Int
  , _detectorL :: d
  } 

maxKeyPointsL :: Lens' (BoundedDetector d) Int
maxKeyPointsL f (BoundedDetector a b) = (\a' -> BoundedDetector a' b) <$> f a

detectorL :: Lens' (BoundedDetector d) d
detectorL f (BoundedDetector a b) = (\b' -> BoundedDetector a b') <$> f b

instance Detector (BoundedDetector d) where
  detect (BoundedDetector maxKeyPoints detector) image = do 
    keyPoints <- detect detector image
    return $ take maxKeyPoints keyPoints

