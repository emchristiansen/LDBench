module LDBench.Detectors.OpenCV where

import Data.Vector (Vector)

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
data OpenCV = BRISK

imageToMatUnpacked :: Image -> MatUnpacked
imageToMatUnpacked = undefined

imageToMat :: Image -> OpenCVComputation Mat
imageToMat image = 
  let
    matUnpacked = imageToMatUnpacked image
    mat :: forall p t. OpenCV.Client p t -> IO Mat
    mat client = pack client T8UC3 matUnpacked
  in
    OpenCVComputation mat

helper detector image =
  let
    OpenCVComputation matClosure = imageToMat image
    keyPoints :: forall p t. OpenCV.Client p t -> IO (Vector KeyPoint)
    keyPoints client = do
      mat <- matClosure client
      OpenCVThrift.OpenCV.Features2D.Features2D.detect client detector mat
  in
    OpenCVComputation keyPoints

instance Detector OpenCV where
  detect BRISK = helper "BRISK"

