module LDBench.Detectors.BoundedDetector where

import OpenCVThrift.OpenCV.Core

import LDBench.Detector

data BoundedDetector d = (Detector d) => BoundedDetector Int d

{-instance Detector (BoundedDetector d) where-}
  {-detect (BoundedDetector maxKeyPoints detector) image = -}
    {-let -}
      {-keyPoints client = do-}
        {-[>kPs :: [KeyPoint]<]-}
        {-kPs <- (detect detector image) client-}
        {-return kPs-}
    {-in-}
      {-undefined-}
