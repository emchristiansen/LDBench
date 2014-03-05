module LDBench.Detectors.OpenCV where

import OpenCVThrift.OpenCV.Core
import OpenCVThrift.OpenCV.Features2D.Features2D

-- TODO: We should not hard-code dependencies on any particular client.
-- But we're doing it here cause it's easy.
{-import qualified OpenCVLocalhost-}

import LDBench.Image
import LDBench.Detector

-- TODO: These enums should be defined as part of the Thrift interface.
data OpenCV = BRISK

imageToMat :: Image -> OpenCVComputation Mat
imageToMat = undefined

instance Detector OpenCV where
  detect BRISK image = do
    undefined
    {-client <- OpenCVLocalhost.openCVLocalhost -}
    {-image <- imageToMat-}
    {-detect client -}
