module LDBench.Extractors.OpenCV where

import qualified Data.Vector
import qualified Data.Text.Lazy

import OpenCVThrift.OpenCV
import qualified OpenCVThrift.OpenCV.Features2D.Features2D
import OpenCVThrift.OpenCV.Features2D

import LDBench.Extractor
import LDBench.Convert

data BRISK = BRISK

instance Extractor BRISK [Bool] where
  extract BRISK image keyPoints = do
    imageMat <- imageToMat image
    ExtractorResponse (Just descriptors) (Just keyPointMask) <- convert3 
      OpenCVThrift.OpenCV.Features2D.Features2D.extract 
      (Data.Text.Lazy.pack "BRISK")
      imageMat
      (Data.Vector.fromList keyPoints)
    {-return $ do-}

    undefined

