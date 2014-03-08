module LDBench.Detector where

import Data.Vector (Vector)

import OpenCVThrift.OpenCV
import OpenCVThrift.OpenCV.Core

import LDBench.OpenCVComputation
import LDBench.Image

class Detector a where
  detect :: a -> Image -> OpenCVComputation [KeyPoint]
