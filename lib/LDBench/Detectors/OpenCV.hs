module LDBench.Detectors.OpenCV where

import qualified Data.Vector
import Data.Vector (Vector)
import qualified Data.Text.Lazy
import Data.List
import Data.Ord

import qualified OpenCVThrift.OpenCV as OpenCV
import OpenCVThrift.OpenCV.Core
import OpenCVThrift.OpenCV.Core.MatUtil
import OpenCVThrift.OpenCV.Features2D.Features2D
import qualified OpenCVThrift.OpenCV.Features2D.Features2D

import LDBench.Convert

-- TODO: We should not hard-code dependencies on any particular client.
-- But we're doing it here cause it's easy.
{-import qualified OpenCVLocalhost-}

import LDBench.Image
import LDBench.Detector

-- TODO: These enums should be defined as part of the Thrift interface.
{-data OpenCV = BRISK | FAST-}
data BRISK = BRISK
data FAST = FAST

helper :: String -> Image -> OpenCV.OpenCVComputation [KeyPoint]
helper detector image = do
  mat <- imageToMat image
  keyPoints <- OpenCV.convert2
    OpenCVThrift.OpenCV.Features2D.Features2D.detect
    (Data.Text.Lazy.pack detector)
    mat
  let sorted = reverse $ sortBy (comparing f_KeyPoint_response) $ Data.Vector.toList keyPoints
  return $ sorted 

instance Detector BRISK where
  detect BRISK = helper "BRISK"

instance Detector FAST where
  detect FAST = helper "FAST"

{-instance Detector OpenCV where-}
  {-detect BRISK = helper "BRISK"-}
  {-detect FAST = helper "FAST"-}

