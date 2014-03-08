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

import LDBench.OpenCVComputation

-- TODO: We should not hard-code dependencies on any particular client.
-- But we're doing it here cause it's easy.
{-import qualified OpenCVLocalhost-}

import LDBench.Image
import LDBench.Detector

-- TODO: These enums should be defined as part of the Thrift interface.
data OpenCV = BRISK | FAST

imageToMatUnpacked :: Image -> MatUnpacked
imageToMatUnpacked = undefined


imageToMat :: Image -> OpenCVComputation Mat
imageToMat image = 
  let 
    matUnpacked = imageToMatUnpacked image
  in
    convert2 pack T8UC3 matUnpacked
{-imageToMat image = -}
  {-let-}
    {-matUnpacked = imageToMatUnpacked image-}
    {-mat :: forall p t. OpenCV.Client p t -> IO Mat-}
    {-mat client = pack client T8UC3 matUnpacked-}
  {-in-}
    {-OpenCVComputation mat-}

helper :: String -> Image -> OpenCVComputation [KeyPoint]
helper detector image = do
  mat <- imageToMat image
  keyPoints <- convert2
    OpenCVThrift.OpenCV.Features2D.Features2D.detect
    (Data.Text.Lazy.pack detector)
    mat
  let sorted = reverse $ sortBy (comparing f_KeyPoint_response) $ Data.Vector.toList keyPoints
  return $ sorted 

instance Detector OpenCV where
  detect BRISK = helper "BRISK"
  detect FAST = helper "FAST"

