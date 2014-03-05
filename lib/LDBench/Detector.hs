module LDBench.Detector where

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.Image

{-type OpenCVComputation a = forall p t. Client p t -> IO a -}
newtype OpenCVComputation a = 
  OpenCVComputation { runOpenCVComputation :: forall p t. Client p t -> IO a }

    {-newtype Writer w a = Writer { runWriter :: (a, w) }  -}

class Detector a where
  detect :: a -> Image -> OpenCVComputation [KeyPoint]
